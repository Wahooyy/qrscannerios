//main.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/sign_in.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:page_transition/page_transition.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  
  await Supabase.initialize(
    url: 'https://metxmtsnkyecrguekpao.supabase.co',
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
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.light(
          background: Colors.white,
          surface: Colors.white,
        ),
        primarySwatch: MaterialColor(
          0xFF3461FD,
          <int, Color>{
            50: Color(0xFFE3E7FE),
            100: Color(0xFFB9C4FD),
            200: Color(0xFF8CA0FC),
            300: Color(0xFF5E7BFB),
            400: Color(0xFF3A5DFB),
            500: Color(0xFF153EFA),
            600: Color(0xFF1238F9),
            700: Color(0xFF0E30F8),
            800: Color(0xFF0B28F7),
            900: Color(0xFF061AF5),
          },
        ),
        textTheme: GoogleFonts.outfitTextTheme(
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
    Future.delayed(const Duration(milliseconds: 100), () {
      FlutterNativeSplash.remove();
    });
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.fade, // Bisa diganti dengan slide, scale, dll.
          child: const SignInPage(),
          duration: const Duration(milliseconds: 600),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset('assets/lottie/Splash-Screen-Test.json'),
      ),
    );
  }
}