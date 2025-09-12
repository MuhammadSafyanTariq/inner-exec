import 'package:flutter/material.dart';

/// Custom bottom navigation bar with unique design
class CustomBottomNavBar extends StatelessWidget {
  /// Current selected index
  final int currentIndex;

  /// Callback when item is tapped
  final Function(int) onTap;

  /// Creates a custom bottom navigation bar
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Container(
    height: 80,
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2)),
      ],
    ),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final itemWidth = (availableWidth / 5).clamp(50.0, 80.0);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              index: 0,
              imagePath: 'assets/images/nav_1.png',
              label: 'Dashboard',
              isActive: currentIndex == 0,
              itemWidth: itemWidth,
            ),
            _buildNavItem(
              index: 1,
              imagePath: 'assets/images/nav_2.png',
              label: 'Jobs',
              isActive: currentIndex == 1,
              itemWidth: itemWidth,
            ),
            _buildNavItem(
              index: 2,
              imagePath: 'assets/images/nav_3.png',
              label: 'Assistant',
              isActive: currentIndex == 2,
              itemWidth: itemWidth,
            ),
            _buildNavItem(
              index: 3,
              imagePath: 'assets/images/nav_4.png',
              label: 'Add-Ons',
              isActive: currentIndex == 3,
              itemWidth: itemWidth,
            ),
            _buildNavItem(
              index: 4,
              imagePath: 'assets/images/nav_5.png',
              label: 'Profile',
              isActive: currentIndex == 4,
              itemWidth: itemWidth,
            ),
          ],
        );
      },
    ),
  );

  /// Builds individual navigation item
  Widget _buildNavItem({
    required int index,
    required String imagePath,
    required String label,
    required bool isActive,
    required double itemWidth,
  }) => GestureDetector(
    onTap: () => onTap(index),
    child: Container(
      width: itemWidth,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Active background with blob effect
          if (isActive)
            Positioned(
              top: -10,
              child: Container(
                width: (itemWidth * 1.2).clamp(60.0, 80.0),
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          // Image and label
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 24,
                height: 24,
                color: isActive
                    ? const Color(0xFF8A2BE2)
                    : const Color(0xFF9E9E9E),
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to icons if images are not available
                  IconData iconData;
                  switch (index) {
                    case 0:
                      iconData = Icons.dashboard;
                      break;
                    case 1:
                      iconData = Icons.work;
                      break;
                    case 2:
                      iconData = Icons.psychology;
                      break;
                    case 3:
                      iconData = Icons.extension;
                      break;
                    case 4:
                      iconData = Icons.person;
                      break;
                    default:
                      iconData = Icons.circle;
                  }
                  return Icon(
                    iconData,
                    size: 24,
                    color: isActive
                        ? const Color(0xFF8A2BE2)
                        : const Color(0xFF9E9E9E),
                  );
                },
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: isActive
                        ? const Color(0xFF8A2BE2)
                        : const Color(0xFF9E9E9E),
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
