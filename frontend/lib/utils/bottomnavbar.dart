import 'package:dev_track_app/theme/colors.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({Key? key, required this.currentIndex, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10), // Adjust spacing
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12, // Increased for stronger shadow
            spreadRadius: 2, // Slightly wider shadow
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none, // Allows elements to overflow
        children: [
          BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            backgroundColor: Colors.transparent,
            elevation: 0,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: [
              _buildNavItem(Icons.article, "Feed", 0), // Updated icon
              _buildNavItem(Icons.image, "Projects", 1), // Updated icon
              _buildNavItem(Icons.person_outline, "Profile", 2), // Updated icon
            ],
          ),
          Positioned(
            top: -22, // Adjusted slightly for better alignment
            left: (MediaQuery.of(context).size.width / 3) * currentIndex +
                (MediaQuery.of(context).size.width / 6) -
                26, // Center it on the selected tab
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: Material(
                elevation: 10, // Increased shadow depth
                shadowColor: Colors.black54, // Darker shadow
                shape: const CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: AppColors.primaryLight,
                  radius: 28, // Slightly bigger for emphasis
                  child: Icon(
                    _getIcon(currentIndex),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Icon(icon, color: index == currentIndex ? Colors.transparent : Colors.black54),
      label: label,
    );
  }

  IconData _getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.article; // Matches Feed icon
      case 1:
        return Icons.image; // Matches Projects icon
      case 2:
        return Icons.person_outline; // Matches Profile icon
      default:
        return Icons.article;
    }
  }
}
