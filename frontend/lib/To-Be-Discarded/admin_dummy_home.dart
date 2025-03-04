import 'package:flutter/material.dart';

class AdminDummyHome extends StatefulWidget {
  const AdminDummyHome({super.key});

  @override
  State<AdminDummyHome> createState() => _AdminDummyHomeState();
}

class _AdminDummyHomeState extends State<AdminDummyHome> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('admin home'),
      ),
    );
  }
}
