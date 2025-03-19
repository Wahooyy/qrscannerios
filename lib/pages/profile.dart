import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../services/auth_service.dart';
import 'sign_in.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = AuthService.userData;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Profile Picture, Username & Email (Centered)
          Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade300,
                ),
                child: const Center(
                  child: Icon(
                    HugeIcons.strokeRoundedUser,// Default User Icon
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                userData?['username'] ?? 'Username',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                userData?['email'] ?? 'Email',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Section Title
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Pengaturan Profil',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // White Card with List Items
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildProfileOption(
                  icon: HugeIcons.strokeRoundedPencilEdit02,
                  text: 'Profil',
                  subtitle: 'Ubah informasi profil',
                  onTap: () {},
                ),
                _buildSeparator(),
                _buildProfileOption(
                  icon: HugeIcons.strokeRoundedSquareLock02,
                  text: 'Kata Sandi',
                  subtitle: 'Ubah kata sandi',
                  onTap: () {},
                ),
                _buildSeparator(),
                _buildProfileOption(
                  icon: HugeIcons.strokeRoundedSettings05,
                  text: 'Pengaturan',
                  subtitle: 'Pengaturan aplikasi',
                  onTap: () {},
                ),
                _buildSeparator(), // Add separator before Logout
                _buildProfileOption(
                  icon: HugeIcons.strokeRoundedLogout03, // Default logout icon
                  text: 'Keluar',
                  subtitle: 'Keluar dari akun kamu',
                  onTap: () async {
                    await AuthService.signOut();
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const SignInPage()),
                        (route) => false,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Profile Option Widget with Default Icons
  Widget _buildProfileOption({
    required IconData icon,
    required String text,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            // Grey Circle with Default Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Text & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Right Arrow Icon
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

  // Separator Widget
  Widget _buildSeparator() {
    return Divider(
      color: Colors.grey.shade300,
      height: 1,
      thickness: 1,
      indent: 20,
      endIndent: 20,
    );
  }
}
