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
                  backgroundColor: Colors.purple,
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

  void _onNavBarTapped(BuildContext context, int index) {
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    final user = loginViewModel.user;

    if (user == null) return; // Prevents navigation if user is not logged in

    bool isAdmin = user.role == 'admin';
    print("Tapped index: $index");

    String route = "";
    switch (index) {
      case 0:
        route = isAdmin ? '/adminFeed' : '/userFeed';
        break;
      case 1:
        route = isAdmin ? '/adminDomain' : '/userProjects';
        break;
      case 2:
        route = isAdmin ? '/adminDomain' : '/userProjects';
        break;
    }

    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  BottomNavigationBarItem _buildNavItem(
      IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Icon(icon,
          color: index == currentIndex ? Colors.transparent : Colors.black54),
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
