import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:figma_squircle/figma_squircle.dart';

import '../services/auth_service.dart';
import 'sign_in.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (AuthService.userData != null) {
      setState(() {
        userData = AuthService.userData;
        isLoading = false;
      });
      return;
    }

    final dbData = await AuthService.getUserData();
    if (dbData != null) {
      setState(() {
        userData = dbData;
        isLoading = false;
      });
      return;
    }

    final storedData = await AuthService.getStoredUserInfo();
    setState(() {
      userData = storedData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String firstLetter = 'U';
    if (userData != null && userData!['adminname'] != null) {
      final adminName = userData!['adminname'].toString();
      if (adminName.isNotEmpty) {
        firstLetter = adminName.substring(0, 1).toUpperCase();
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE6F0FF),
                        ),
                        child: Center(
                          child: Text(
                            firstLetter,
                            style: GoogleFonts.outfit(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3461FD),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        userData?['adminname'] ?? 'Name',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        userData?['username'] ?? 'Username',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  Container(
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(
                          cornerRadius: 16,
                          cornerSmoothing: 0.6,
                        ),
                        side: BorderSide(
                          color: Colors.grey.shade100,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildProfileOption(
                          icon: HugeIcons.strokeRoundedPencilEdit02,
                          text: 'Profil',
                          onTap: () {},
                        ),
                        _buildSeparator(),
                        _buildProfileOption(
                          icon: HugeIcons.strokeRoundedSquareLock02,
                          text: 'Kata Sandi',
                          onTap: () {},
                        ),
                        _buildSeparator(),
                        _buildProfileOption(
                          icon: HugeIcons.strokeRoundedSettings05,
                          text: 'Pengaturan',
                          onTap: () {},
                        ),
                        _buildSeparator(),
                        _buildProfileOption(
                          icon: HugeIcons.strokeRoundedLogout03,
                          text: 'Keluar',
                          onTap: () async {
                            await AuthService.signOut();
                            if (context.mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignInPage()),
                                (route) => false,
                              );
                            }
                          },
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                  const Text(
                    'Versi 1.0.0',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const Text(
                    '© 2025 Wahooyy',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color color = Colors.black, // Default hitam, bisa diubah
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: color, // Warna teks sesuai parameter
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildSeparator() {
    return Divider(
      color: Colors.grey.shade100,
      height: 1,
      thickness: 2,
      indent: 20,
      endIndent: 20,
    );
  }
}
