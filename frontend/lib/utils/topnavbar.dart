import 'package:flutter/material.dart';
import "package:dev_track_app/theme/theme.dart";
import 'package:dev_track_app/theme/colors.dart';

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  const TopNavBar({
    Key? key,
    required this.onNotificationTap,
  }) : super(key: key);

  final VoidCallback onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundLight,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        onPressed: () {
          // This will automatically handle the navigation stack
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.notifications,
            color: Colors.black,
          ),
          onPressed: onNotificationTap,
        ),
        const SizedBox(width: 8), // Adds some padding to the right
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
