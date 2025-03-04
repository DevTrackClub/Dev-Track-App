import 'package:dev_track_app/pages/admin_pages/admin_feed_view/admin_feed_page.dart';
import 'package:dev_track_app/pages/admin_pages/mgmg_prev_projects.dart';
import 'package:dev_track_app/pages/common_pages/Theme-Demo-Page/sample.dart';
import 'package:dev_track_app/pages/common_pages/confirm_page.dart';
import 'package:dev_track_app/pages/common_pages/domain_pages/domain.dart';
import 'package:dev_track_app/pages/common_pages/home_page.dart';
import 'package:dev_track_app/pages/user_pages/project_pages/project_display/previous_projects.dart';
import 'package:dev_track_app/pages/user_pages/project_pages/project_display/specific_project.dart';
import 'package:dev_track_app/pages/user_pages/project_pages/submission_page/submission_page.dart';
import 'package:dev_track_app/pages/user_pages/studentview.dart';
import 'package:dev_track_app/pages/user_pages/tracker.dart';
import 'package:dev_track_app/pages/user_pages/user_feed_page.dart';
import 'package:dev_track_app/theme/splashscreen.dart';
import 'package:flutter/material.dart';

class HomePag extends StatelessWidget {
  const HomePag({super.key});

  Widget buildNavButton(
      BuildContext context, String text, Color color, Widget page) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shadowColor: Colors.blueAccent,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildNavButton(
                context, "Home Page", Colors.green, const HomePage()),
            buildNavButton(
                context, "Domain Page", Colors.purple, const DomainPage()),
            buildNavButton(context, "Theme Page Implementation", Colors.blue,
                const ThemedPage()),
            buildNavButton(
                context, "Submission Page", Colors.blue, SubmissionPage()),
            buildNavButton(
                context, "Confirm", Colors.amber, const ConfirmPage()),
            buildNavButton(context, "Previous Projects", Colors.deepOrange,
                const PreviousProjects()),
            buildNavButton(
                context, "SplashScreen", Colors.indigo, const Splash()),
            buildNavButton(context, "Tracker Page", Colors.teal,
                const ProgressTrackerPage()),
            buildNavButton(context, "Management Project View", Colors.teal,
                const MgmtPreviousProjects()),
            buildNavButton(
                context, "Student View", Colors.indigo, const Studentview()),
            buildNavButton(context, "New Project Detail Page", Colors.indigo,
                const ProjectDetailPage()),
            buildNavButton(context, "Admin fees",
                const Color.fromARGB(255, 9, 9, 9), const AdminFeedPage()),
            buildNavButton(context, "User feed",
                const Color.fromARGB(255, 200, 198, 49), const UserFeedPage()),
          ],
        ),
      ),
    );
  }
}
