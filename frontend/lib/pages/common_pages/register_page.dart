import 'package:flutter/material.dart';
import 'confirm_page.dart'; // Ensure this import is correct

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: const Color.fromARGB(255, 53, 156, 19),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Registration Form',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          'What should we call you?',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter your name',
                            filled: true,
                            fillColor: Colors.grey[700],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          'SRN and Phone number',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter your SRN',
                            filled: true,
                            fillColor: Colors.grey[700],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter your phone number',
                            filled: true,
                            fillColor: Colors.grey[700],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          'If you have worked on some projects, drop us a link',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Project link',
                            filled: true,
                            fillColor: Colors.grey[700],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          'Course',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter your course',
                            filled: true,
                            fillColor: Colors.grey[700],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          'Which domain do you think suits you the best?',
                          style: TextStyle(color: Colors.white),
                        ),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[700],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: 'appdev',
                                child: Text('App Development')),
                            DropdownMenuItem(
                                value: 'webdev',
                                child: Text('Web Development')),
                            DropdownMenuItem(
                                value: 'gamedev',
                                child: Text('Game Development')),
                            DropdownMenuItem(
                                value: 'aiml', child: Text('AI/ML')),
                            DropdownMenuItem(
                                value: 'web3', child: Text('Web3')),
                            DropdownMenuItem(
                                value: 'uiux', child: Text('UI/UX')),
                          ],
                          onChanged: (value) {},
                          hint: const Text('Select a domain'),
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          'Enter LinkedIn ID',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'LinkedIn URL',
                            filled: true,
                            fillColor: Colors.grey[700],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          'Enter email',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Email address',
                            filled: true,
                            fillColor: Colors.grey[700],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            Checkbox(
                              value: _isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isChecked = value ?? false;
                                });
                              },
                              fillColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 53, 156, 19)),
                            ),
                            const Expanded(
                              child: Text(
                                'I agree to the terms and conditions',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to confirmation page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ConfirmPage()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 53, 156, 19),
                              fixedSize: const Size(120, 50),
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[850],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
