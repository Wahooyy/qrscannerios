import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:figma_squircle/figma_squircle.dart';


import '../services/auth_service.dart';
import 'homepage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _usernameError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    try {
      await AuthService.initializeAuth();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error initializing connection',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: const Color(0xFFE21C3D),
          ),
        );
      }
    }
  }

  Future<void> _signIn() async {
    bool isValid = _validateInputs();
    if (!isValid) return;

    setState(() => _isLoading = true);

    try {
      final response = await AuthService.login(
        _usernameController.text,
        _passwordController.text,
      );

      if (!mounted) return;

      if (response['status'] == 'success') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response['message'] ?? 'Login failed',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: const Color(0xFFE21C3D),
            // behavior: SnackBarBehavior.floating,
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(12),
            // ),
            // margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            // elevation: 6,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Koneksi Error.',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: const Color(0xFFE21C3D),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  bool _validateInputs() {
    bool isValid = true;
    
    // Validate username
    if (_usernameController.text.isEmpty) {
      setState(() {
        _usernameError = 'Username harus diisi';
      });
      isValid = false;
    } else {
      setState(() {
        _usernameError = null;
      });
    }
    
    // Validate password
    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = 'Password harus diisi';
      });
      isValid = false;
    } else {
      setState(() {
        _passwordError = null;
      });
    }
    
    return isValid;
  }

  InputDecoration _getInputDecoration({
    required String hintText,
    Widget? suffixIcon,
    bool isError = false,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.poppins(
        color: const Color(0xFF262626),
        fontWeight: FontWeight.w400,
      ),
      filled: true,
      fillColor: const Color(0xFFF5F9FE),
      suffixIcon: suffixIcon,
      
      // Apply Figma squircle effect using SmoothBorderRadius
      border: OutlineInputBorder(
        borderRadius: SmoothBorderRadius(
          cornerRadius: 14,
          cornerSmoothing: 1,
        ),
        borderSide: isError 
            ? BorderSide.none 
            : BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: SmoothBorderRadius(
          cornerRadius: 14,
          cornerSmoothing: 1,
        ),
        borderSide: isError 
            ? BorderSide.none 
            : BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: SmoothBorderRadius(
          cornerRadius: 14,
          cornerSmoothing: 1,
        ),
        borderSide: isError 
            ? BorderSide.none 
            : BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: SmoothBorderRadius(
          cornerRadius: 14,
          cornerSmoothing: 1,
        ),
        borderSide: const BorderSide(
          color: Color(0xFFE21C3D),
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: SmoothBorderRadius(
          cornerRadius: 14,
          cornerSmoothing: 1,
        ),
        borderSide: const BorderSide(
          color: Color(0xFFE21C3D),
          width: 1,
        ),
      ),
      // Hide the default error message
      errorStyle: const TextStyle(
        height: 0,
        color: Colors.transparent,
        fontSize: 0,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 20,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Masuk',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2A4ECA),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Pakai username dan kata sandi kamu',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Username field with fixed height
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 60,
                        child: TextFormField(
                          controller: _usernameController,
                          decoration: _getInputDecoration(
                            hintText: 'Username',
                            isError: _usernameError != null,
                          ),
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF262626),
                            fontWeight: FontWeight.w400,
                          ),
                          onChanged: (value) {
                            if (_usernameError != null) {
                              setState(() {
                                _usernameError = value.isEmpty ? 'Username harus diisi' : null;
                              });
                            }
                          },
                        ),
                      ),
                      if (_usernameError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4, left: 1),
                          child: Text(
                            _usernameError!,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFFE21C3D),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Password field with fixed height
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 60,
                        child: TextFormField(
                          controller: _passwordController,
                          decoration: _getInputDecoration(
                            hintText: 'Kata Sandi',
                            isError: _passwordError != null,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: SvgPicture.asset(
                                  _obscurePassword
                                      ? 'assets/icons/Hide.svg'
                                      : 'assets/icons/Eye.svg',
                                  width: 24,
                                  height: 24,
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFF262626),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF262626),
                            fontWeight: FontWeight.w400,
                          ),
                          obscureText: _obscurePassword,
                          onChanged: (value) {
                            if (_passwordError != null) {
                              setState(() {
                                _passwordError = value.isEmpty ? 'Kata sandi harus diisi' : null;
                              });
                            }
                          },
                        ),
                      ),
                      if (_passwordError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4, left: 1),
                          child: Text(
                            _passwordError!,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFFE21C3D),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Login button
                  SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signIn,
                      style: ElevatedButton.styleFrom(
                        shape: SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius(
                            cornerRadius: 14,
                            cornerSmoothing: 1,
                          ),
                        ),
                        backgroundColor: const Color(0xFF3461FD),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Masuk',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}