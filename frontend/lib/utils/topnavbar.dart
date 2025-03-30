import 'package:dev_track_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/login_view_model.dart';
import '../views/common_pages/login_page.dart';

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
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () async {
            final loginViewModel =
                Provider.of<LoginViewModel>(context, listen: false);
            await loginViewModel.logout();

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          child: Text("Logout"),
        ), // Adds some padding to the right
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
