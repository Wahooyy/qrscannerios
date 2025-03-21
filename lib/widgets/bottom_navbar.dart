import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import '../pages/scanner.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade100,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              icon: HugeIcons.strokeRoundedHome01,
              title: 'Home',
              isSelected: selectedIndex == 0,
              onTap: () => onItemTapped(0),
            ),
            _buildNavItem(
              icon: HugeIcons.strokeRoundedFile01,
              title: 'Order',
              isSelected: selectedIndex == 1,
              onTap: () => onItemTapped(1),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const QRScannerPage(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(position: offsetAnimation, child: child);
                    },
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFF3461FD),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  HugeIcons.strokeRoundedQrCode01,
                  color: Color.fromARGB(255, 255, 255, 255),
                  size: 28,
                ),
              ),
            ),
            _buildNavItem(
              icon: HugeIcons.strokeRoundedClock01,
              title: 'Riwayat',
              isSelected: selectedIndex == 3,
              onTap: () => onItemTapped(3),
            ),
            _buildNavItem(
              icon: HugeIcons.strokeRoundedUser,
              title: 'Profil',
              isSelected: selectedIndex == 4,
              onTap: () => onItemTapped(4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF000000) : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: isSelected ? const Color(0xFF000000) : Colors.grey,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
