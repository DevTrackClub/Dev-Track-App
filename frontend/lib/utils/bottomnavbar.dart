import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/login_view_model.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10), // Adjust spacing
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12, // Increased for st ronger shadow
            spreadRadius: 2, // Slightly wider shadow
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Colors.transparent,
        elevation: 0,
        onTap: (index) => _onNavBarTapped(context, index),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          _buildNavItem(Icons.article, "Feed", 0), // Updated icon
          _buildNavItem(Icons.image, "Projects", 1), // Updated icon
          _buildNavItem(Icons.person_outline, "Profile", 2), // Updated icon
        ],
      ),
    );
  }

  void _onNavBarTapped(BuildContext context, int index) {
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    final user = loginViewModel.user;

    if (user == null) return;

    bool isAdmin = user.role == 'admin';
    print("Tapped index: $index");

    String route = "";
    switch (index) {
      case 0:
        route = '/userFeed';
        break;
      case 1:
        route = '/userProjects';
        break;
      case 2:
        return; // cus profile page not made yet
    }

    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  BottomNavigationBarItem _buildNavItem(
      IconData icon, String label, int index) {
    // Change the color based on the selected index
    Color iconColor = index == currentIndex ? Colors.purple : Colors.black54;
    return BottomNavigationBarItem(
      icon: Icon(icon, color: iconColor),
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
