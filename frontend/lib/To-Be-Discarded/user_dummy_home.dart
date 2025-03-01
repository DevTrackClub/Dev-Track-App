import 'package:flutter/material.dart';
import 'package:dev_track_app/pages/user_pages/enroll_pages/enroll_page.dart';

class UserDummyHome extends StatefulWidget {
  const UserDummyHome({super.key});

  @override
  State<UserDummyHome> createState() => _UserDummyHomeState();
}

class _UserDummyHomeState extends State<UserDummyHome> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('user home'),
      ),
    );
  }
}
