import 'package:dev_track_app/utils/bottomnavbar.dart';
import 'package:dev_track_app/views/user_pages/enroll_pages/enroll_page.dart';
import 'package:flutter/material.dart';

class DomainPage extends StatefulWidget {
  const DomainPage({super.key});

  @override
  State<DomainPage> createState() => _DomainPageState();
}

class _DomainPageState extends State<DomainPage> {
  //bottomnavbar index
  int _selectedIndex = 1;

  final List<Map<String, String>> projects = List.generate(
    6,
    (index) => {
      "name": "Project name",
      "team": "Team A",
      "description": "Lorem ipsum dolor sit amet.",
    },
  );
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarCommon(),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            searchBar(),
            welcomeBack(),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) => domainArea(),
                ),
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

  PreferredSizeWidget appBarCommon() {
    return AppBar(
      elevation: 0.00,
      backgroundColor: Colors.white,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.notifications),
          tooltip: 'Setting Icon',
          onPressed: () {},
        ), //IconButton
      ],
    );
  }

  Widget searchBar() {
    return Container(
      padding: EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'search all projects',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  Widget welcomeBack() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Welcome Back,',
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'VIEWER',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 20), // Space between text and button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EnrollPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[100], // Cute color
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded edges
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'My Projects',
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios, size: 20), // Arrow icon
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget domainArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("AI/ML",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        SizedBox(
          height: 130,
          //width: 80,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: projects.map((project) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SizedBox(width: 170, child: domainCards(project)),
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Explore more projects",
          style: TextStyle(
              color: Colors.purple,
              decoration: TextDecoration.underline,
              decorationThickness: 2),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget domainCards(Map<String, String> project) {
    return Card(
      shadowColor: Colors.black87,
      elevation: 5,
      color: Color.fromRGBO(122, 36, 180, 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(project["name"]!,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            Text(project["team"]!, style: TextStyle(color: Colors.white70)),
            SizedBox(height: 5),
            Text(project["description"]!,
                style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
