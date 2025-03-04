import 'package:dev_track_app/views/admin_pages/admin_feed_view/admin_feed_page.dart';
import 'package:dev_track_app/views/common_pages/general_feed_page.dart';
import 'package:dev_track_app/views/user_pages/user_feed_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_models/login_view_model.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 150,
                    decoration: const BoxDecoration(
                      color: Color(0xFF5e00b0),
                      shape: BoxShape.rectangle,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                  ),
                  const Positioned(
                    top: 48,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 45,
                        //       backgroundImage: AssetImage(
                        //           "frontend/assets/images/dev_track_logo.jpg")
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 60),
              const Text(
                'Welcome Back',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Sign in to your account',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'Email',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Password',
                    suffix: Text(
                      'Forgot ?',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
              ),
              if (loginViewModel.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    loginViewModel.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ElevatedButton(
                  onPressed: loginViewModel.isLoading
                      ? null
                      : () async {
                          await loginViewModel.login(
                            emailController.text,
                            passwordController.text,
                          );

                          if (loginViewModel.user != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    loginViewModel.user!.role == 'admin'
                                        ? AdminFeedPage()
                                        : UserFeedPage(),
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5e00b0),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: loginViewModel.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Login',
                          style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 15),
              const Text('OR',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 15, 25, 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GeneralFeedPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Color(0xFF5e00b0)),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    textStyle: TextStyle(fontSize: 18, color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Text('Browse as a Guest',
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
