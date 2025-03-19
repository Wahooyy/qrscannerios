import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/sign_in.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  // Ensure the splash screen stays visible until Flutter is ready
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  
  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://metxmtsnkyecrguekpao.supabase.co', // Replace with your actual Supabase URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1ldHhtdHNua3llY3JndWVrcGFvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIzNTMxNjUsImV4cCI6MjA1NzkyOTE2NX0.SoK56-fpfM4cojQ9buoexYMWIzrQrLH_DdWJrWinBr0', // Replace with your actual Supabase anon key
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Remove the native splash screen after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      FlutterNativeSplash.remove();
    });

    // Navigate to SignInPage after the Lottie animation
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const SignInPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset('assets/lottie/Splash-Screen-Test.json'), // Ensure this file exists in the assets folder
      ),
    );
  }
}