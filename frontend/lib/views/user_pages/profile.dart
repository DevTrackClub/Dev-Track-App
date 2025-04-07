import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  // Dummy backend data
  final String userName = "nameeeee";
  final String userEmail = "username@gmail.com";
  final String userSRN = "R22ER071";
  final String teamName = "Awesome Team";

  final String githubLink = "https://github.com/yourusername";
  final String linkedinLink = "https://linkedin.com/in/yourprofile";
  final String emailLink = "mailto:username@gmail.com";
  final String instagramLink = "https://instagram.com/yourprofile";

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Stack(
                children: [
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/elmoo.jpg'), // Replace with actual image
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 12,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 16,
                    child: Text(
                      "logout?",
                      style: TextStyle(
                        color: Colors.red.shade400,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Positioned(
  top: 90,
  left: width / 2 - 48,
  child: Stack(
    alignment: Alignment.bottomCenter,
    children: [
      CircleAvatar(
        radius: 48,
        backgroundColor: Colors.white,
        child: ClipOval(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple,
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Icon(Icons.person, size: 48, color: Colors.black),
            ),
          ),
        ),
      ),
    ],
  ),
),

                ],
              ),

              const SizedBox(height: 60),

              // User Info
              Text(
                userName,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(userEmail, style: const TextStyle(color: Colors.grey)),
              Text(userSRN, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 12),

              ElevatedButton.icon(
                onPressed: () {
                  // placeholder navigation
                },
                icon: const Icon(Icons.edit, size: 18),
                label: const Text("edit profile"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Social Links
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Wrap(
                  spacing: 20,
                  children: [
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.github),
                      onPressed: () => _launchURL(githubLink),
                    ),
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.linkedin),
                      onPressed: () => _launchURL(linkedinLink),
                    ),
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.envelope),
                      onPressed: () => _launchURL(emailLink),
                    ),
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.instagram),
                      onPressed: () => _launchURL(instagramLink),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Recent Projects
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Recent projects",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(
                  3,
                  (index) => GestureDetector(
                    onTap: () {
                      // placeholder route
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.insert_drive_file,
                          color: Colors.white, size: 40),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Team Name section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    teamName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: List.generate(
                    4,
                    (index) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Nameeeee", style: TextStyle(color: Colors.white)),
                        Text("link", style: TextStyle(color: Colors.white)),
                        Text("2025", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(right: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text("edit",
                        style: TextStyle(color: Colors.deepPurple, fontSize: 14)),
                    SizedBox(width: 4),
                    Icon(Icons.edit, size: 16, color: Colors.deepPurple),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
