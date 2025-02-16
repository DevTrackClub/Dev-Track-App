import 'package:flutter/material.dart';
import 'package:dev_track_app/pages/common_pages/domain_pages/topNav.dart';
import 'specific_project.dart';
import 'package:dev_track_app/routing/previous_projects_routing.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dev_track_app/theme/colors.dart';

class PreviousProjects extends StatefulWidget {
  const PreviousProjects({super.key});

  @override
  State<PreviousProjects> createState() => _PreviousProjectsState();
}

class _PreviousProjectsState extends State<PreviousProjects> {
  @override
 
 //all our components gets built here
   Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: Stack(
          children: [
            Column(
              children: [
                const TopNav(),  // Fixed at top
                _buildSearchBar(), // Fixed below navbar
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: _buildTitle(), // Title scrolls with projects
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
          ],
        ),
      ),
    );
  }

  //builds our search bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: SizedBox(
        height: 50,
        child: TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.backgroundLight,
            labelText: 'search all projects',
            prefixIcon: Icon(Icons.search, color: AppColors.neutralDark),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.0),
              borderSide: BorderSide(color: const Color(0xFF5B2333)),
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

  final List<Map<String, String>> projects = 
  [
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
      "image": "assets/images/devtrack.png"
    },
    {
      "title": "E-commerce App",
      "subtitle": "Shopping made easy",
      "description": "An intuitive mobile shopping experience.",
      "image": "assets/images/ecommerce.png"
    },
    {
      "title": "E-commerce App",
      "subtitle": "Shopping made easy",
      "description": "An intuitive mobile shopping experience.",
      "image": "assets/images/ecommerce.png"
    },
    {
      "title": "E-commerce App",
      "subtitle": "Shopping made easy",
      "description": "An intuitive mobile shopping experience.",
      "image": "assets/images/ecommerce.png"
    },
  ];


//ui for cards
  Widget _buildProjectCard(Map<String, String> project) {
    return Container(
      padding: EdgeInsets.all(24),
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF6901AE),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Flexible(
              flex: 1, // Image takes available space proportionally
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'assets/images/game.png', // Replace with actual image URL or use AssetImage
                    fit: BoxFit
                        .cover, // Ensures the image fills the available space
                  ),
                ),
              )),
          SizedBox(width: 15),
          Expanded(
            flex: 3, // Text takes more space
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "UI/UX 42",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Budgeting application",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    textStyle: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    PreviousProjectsRouting.pushToSpecificProject(context);                           
                  },
                  child: Text("Explore"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
