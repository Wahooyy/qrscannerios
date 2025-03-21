import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:hugeicons/hugeicons.dart';

import '../services/auth_service.dart';
import 'homepage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with SingleTickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _usernameError;
  String? _passwordError;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _showCustomSnackBar(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10, // Show at the top
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -1), // Slide from top
              end: const Offset(0, 0),
            ).animate(CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeOut,
            )),
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7E4E4),
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 8,
                  cornerSmoothing: 1,
                ),
                border: Border.all(color: const Color(0xFFFFA3A6)),
              ),
              child: Row(
                children: [
                  const Icon(
                    HugeIcons.strokeRoundedAlertCircle,
                    color: Color(0xFFE21C3D),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      message,
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF141414),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      HugeIcons.strokeRoundedMultiplicationSign,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: () => overlayEntry.remove(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Auto-dismiss after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }


  Future<void> _initializeAuth() async {
    try {
      bool isAuthenticated = await AuthService.initializeAuth();
      if (isAuthenticated && mounted) {
        // If user is already authenticated, navigate to home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      if (mounted) {
        _showCustomSnackBar(context, 'Error initializing connection');
      }
    }
  }

  Future<void> _signIn() async {
    bool isValid = _validateInputs();
    if (!isValid) return;

    setState(() => _isLoading = true);

    try {
      final response = await AuthService.login(
        _usernameController.text,  // This is now niklogin in the updated AuthService
        _passwordController.text,
      );

      if (!mounted) return;

      if (response['status'] == true) {  // Changed from 'success' to true based on new AuthService
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        _showCustomSnackBar(context, response['message'] ?? 'Login failed');
      }
    } catch (e) {
      if (!mounted) return;
      _showCustomSnackBar(context, 'Koneksi Error: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  bool _validateInputs() {
    bool isValid = true;
    
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
      hintStyle: GoogleFonts.outfit(
        color: const Color(0xFF262626),
        fontWeight: FontWeight.w400,
      ),
      filled: true,
      fillColor: const Color(0xFFF5F9FE),
      suffixIcon: suffixIcon,
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
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2A4ECA),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Pakai username dan kata sandi kamu',  // Changed username to NIK
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 60,
                        child: TextFormField(
                          controller: _usernameController,
                          decoration: _getInputDecoration(
                            hintText: 'Username',  // Changed from Username to NIK
                            isError: _usernameError != null,
                          ),
                          style: GoogleFonts.outfit(
                            color: const Color(0xFF262626),
                            fontWeight: FontWeight.w400,
                          ),
                          onChanged: (value) {
                            if (_usernameError != null) {
                              setState(() {
                                _usernameError = value.isEmpty ? 'Username harus diisi' : null;  // Changed error message
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
                            style: GoogleFonts.outfit(
                              color: const Color(0xFFE21C3D),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
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
                              icon: Icon(
                                _obscurePassword ? HugeIcons.strokeRoundedViewOffSlash : HugeIcons.strokeRoundedView,
                                color: const Color(0xFF262626),
                                size: 20, // Adjust the size to match the previous SVG icon size
                              ),
                              padding: EdgeInsets.zero, // Remove default padding
                              constraints: const BoxConstraints(), // Ensures no extra spacing
                            ),
                          ),
                          style: GoogleFonts.outfit(
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
                            style: GoogleFonts.outfit(
                              color: const Color(0xFFE21C3D),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
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
                              style: GoogleFonts.outfit(
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
}