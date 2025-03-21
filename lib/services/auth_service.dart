import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final SupabaseClient _supabaseClient = Supabase.instance.client;
  
  // Static variable to cache user data
  static Map<String, dynamic>? userData;
  
  // Initialize auth and check if user is already logged in
  static Future<bool> initializeAuth() async {
    try {
      // Check if there's an active session
      final session = _supabaseClient.auth.currentSession;
      if (session != null) {
        // Load user data if session exists
        userData = await getUserData();
        if (userData == null) {
          userData = await getStoredUserInfo();
        }
      }
      return session != null;
    } catch (e) {
      debugPrint('Error initializing auth: $e');
      return false;
    }
  }

  // Convert password to MD5 hash to match your database format
  static String _convertToMd5(String password) {
    return crypto.md5.convert(utf8.encode(password)).toString();
  }

  // Login method that matches your existing sign_in_page.dart interface
  static Future<Map<String, dynamic>> login(String niklogin, String password) async {
    try {
      // Step 1: Query tbl_user to find the matching user by niklogin
      final List<dynamic> userResponse = await _supabaseClient
          .from('tbl_user')
          .select('email, password, user_uuid, niklogin, level, adminname, username')
          .eq('niklogin', niklogin)
          .limit(1);
      debugPrint('User Response: $userResponse');
      
      // Check if we got any results back
      if (userResponse.isEmpty) {
        return {'status': false, 'message': 'Username tidak ditemukan'};
      }
      
      // Get the first matching user
      final userDataFromDb = userResponse[0];
      
      // Step 2: Verify the password with MD5 hash
      final storedPassword = userDataFromDb['password'] as String;
      final hashedInputPassword = _convertToMd5(password);
      
      if (storedPassword != hashedInputPassword) {
        return {'status': false, 'message': 'Password salah'};
      }
      
      // Step 3: Get the email and uuid for Supabase auth
      final email = userDataFromDb['email'] as String;
      // ignore: unused_local_variable
      final userUuid = userDataFromDb['user_uuid'] as String;
      
      // Step 4: Sign in with Supabase auth using email
      try {
        final authResponse = await _supabaseClient.auth.signInWithPassword(
          email: email,
          password: password, // Supabase will hash this differently
        );
        
        if (authResponse.user == null) {
          return {'status': false, 'message': 'Gagal otentikasi dengan sistem'};
        }
        
        // Store user data in the static variable
        userData = userDataFromDb;
        
        // Store additional user info in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_info', jsonEncode(userDataFromDb));
        
        return {'status': true, 'message': 'Login berhasil'};
      } catch (authError) {
        debugPrint('Auth error: $authError');
        // Special handling for auth errors
        String errorMessage = 'Koneksi error, silahkan coba lagi';
        
        if (authError is AuthException) {
          // Check for specific auth error types
          if (authError.message.contains('Invalid login')) {
            errorMessage = 'Email atau password tidak cocok di sistem autentikasi';
          }
        }
        
        return {'status': false, 'message': errorMessage};
      }
    } catch (e) {
      debugPrint('Login error: $e');
      return {'status': false, 'message': 'Error: ${e.toString()}'};
    }
  }
  
  // Get current authenticated user
  static User? getCurrentUser() {
    return _supabaseClient.auth.currentUser;
  }
  
  // Get additional user data from tbl_user
  static Future<Map<String, dynamic>?> getUserData() async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) return null;
      
      final List<dynamic> userDataFromDb = await _supabaseClient
          .from('tbl_user')
          .select('*')
          .eq('user_uuid', user.id)
          .limit(1);
          
      if (userDataFromDb.isEmpty) return null;
      
      // Update the static userData variable
      userData = userDataFromDb[0];
      return userData;
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      return null;
    }
  }
  
  // Retrieve stored user info
  static Future<Map<String, dynamic>?> getStoredUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userInfoString = prefs.getString('user_info');
      if (userInfoString == null) return null;
      
      final storedData = jsonDecode(userInfoString) as Map<String, dynamic>;
      // Update the static userData variable
      userData = storedData;
      return storedData;
    } catch (e) {
      debugPrint('Error getting stored user info: $e');
      return null;
    }
  }
  
  // Logout method
  static Future<void> signOut() async {
    // Clear stored user info
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_info');
    
    // Clear the static userData variable
    userData = null;
    
    // Sign out from Supabase
    await _supabaseClient.auth.signOut();
  }
}