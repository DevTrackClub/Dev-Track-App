import 'package:dev_track_app/pages/home.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _alignment;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _alignment = Tween<Alignment>(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).animate(_controller);

    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(Duration(milliseconds: 2000));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePag()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 73, 169, 77),
                  Color.fromARGB(255, 5, 72, 8),
                  Colors.black,
                ],
                begin: _alignment.value,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: SizedBox(
                width: 320, // Set the desired width
                height: 320, // Set the desired height
                child: Image.asset('assets/images/dtlogo.png'),
              ),
            ),
          );
        },
      ),
    );
  }
}
