import 'package:dev_track_app/routing/previous_projects_routing.dart';
import 'package:dev_track_app/theme/colors.dart';
import 'package:dev_track_app/utils/bottomnavbar.dart';
import 'package:dev_track_app/utils/topnavbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../user_feed_page.dart';

class PreviousProjects extends StatefulWidget {
  const PreviousProjects({super.key});

  @override
  State<PreviousProjects> createState() => _PreviousProjectsState();
}

class _PreviousProjectsState extends State<PreviousProjects> {
  //bottomnavbarindex index
  int _selectedIndex = 1;

  void _onNavBarTapped(int index) {
    print("Tapped index: $index"); // Debugging print statement

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserFeedPage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PreviousProjects()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: TopNavBar(
          onNotificationTap: () {
            // Handle notification tap
          },
        ),
        body: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _buildTitle(),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildProjectCard(projects[index]),
                      childCount: projects.length,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _selectedIndex,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: SizedBox(
        height: 50,
        child: TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.backgroundLight,
            labelText: 'Search all projects',
            prefixIcon: Icon(Icons.search, color: AppColors.neutralDark),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.0),
              borderSide: const BorderSide(color: Color(0xFF5B2333)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 15, 15, 0),
      child: Text(
        'Explore our projects',
        style: GoogleFonts.poppins(
          fontSize: 30,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.italic,
          color: const Color(0xFF6901AE),
        ),
      ),
    );
  }

  final List<Map<String, String>> projects = [
    {
      "title": "UI/UX 42",
      "subtitle": "Budgeting application",
      "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      "image": "assets/images/game.png"
    },
    {
      "title": "Dev Track",
      "subtitle": "Project management tool",
      "description": "A tool to track developer progress in real-time.",
      "image": "assets/images/dev_track_logo.jpg"
    },
    {
      "title": "E-commerce App",
      "subtitle": "Shopping made easy",
      "description": "An intuitive mobile shopping experience.",
      "image": "assets/images/user.png"
    },
    {
      "title": "E-commerce App",
      "subtitle": "Shopping made easy",
      "description": "An intuitive mobile shopping experience.",
      "image": "assets/images/game.png"
    },
    {
      "title": "E-commerce App",
      "subtitle": "Shopping made easy",
      "description": "An intuitive mobile shopping experience.",
      "image": "assets/images/hitler.png"
    },
  ];

  Widget _buildProjectCard(Map<String, String> project) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF6901AE),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  project["image"]!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project["title"]!,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  project["subtitle"]!,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  project["description"]!,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    textStyle: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    PreviousProjectsRouting.pushToSpecificProject(context);
                  },
                  child: const Text("Explore"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
