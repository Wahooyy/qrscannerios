  import 'package:flutter/material.dart';
  import 'package:flutter_svg/flutter_svg.dart';

  import '../pages/scanner.dart';

  class CustomBottomNavBar extends StatelessWidget {
    final int selectedIndex;
    final Function(int) onItemTapped;

    const CustomBottomNavBar({
      super.key,
      required this.selectedIndex,
      required this.onItemTapped,
    });

    @override
    Widget build(BuildContext context) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/Navbar.svg', // Make sure the path is correct
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
          Positioned(
            child: Theme(
              data: Theme.of(context).copyWith(
                splashFactory: NoSplash.splashFactory, // Removes the ripple animation
                highlightColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.grey,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                currentIndex: selectedIndex,
                onTap: onItemTapped,
                  items: [
                  BottomNavigationBarItem(
                    icon: Transform.translate(
                      offset: Offset(0, 10),
                      child: SvgPicture.asset(
                        'assets/icons/Home.svg',
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(selectedIndex == 0 ? Colors.black : Colors.grey,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Transform.translate(
                      offset: Offset(0, 10),
                      child: SvgPicture.asset(
                        'assets/icons/Search.svg',
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(selectedIndex == 1 ? Colors.black : Colors.grey,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Transform.translate(
                      offset: Offset(0, -10),
                      child: Icon(Icons.scanner),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Transform.translate(
                      offset: Offset(0, 10),
                      child: SvgPicture.asset(
                        'assets/icons/Vector.svg',
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(selectedIndex == 3 ? Colors.black : Colors.grey,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Transform.translate(
                      offset: Offset(0, 10),
                      child: SvgPicture.asset(
                        'assets/icons/User.svg',
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(selectedIndex == 4 ? Colors.black : Colors.grey,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    label: '',
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QRScannerPage()),
                );
              },
              child: Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF2563EB).withOpacity(0.2),
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/Scanner.svg',
                      width: 28,
                      height: 28,
                      color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }