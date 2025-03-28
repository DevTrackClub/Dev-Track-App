import 'package:dev_track_app/models/enrollment_model.dart';
import 'package:dev_track_app/pages/common_pages/domain_pages/domain.dart';
import 'package:dev_track_app/pages/common_pages/general_feed_page.dart';
import 'package:dev_track_app/To-Be-Discarded/home_page.dart';
import 'package:dev_track_app/pages/home.dart';
import 'package:dev_track_app/pages/user_pages/project_pages/project_display/previous_projects.dart';
import 'package:dev_track_app/pages/user_pages/project_pages/project_display/specific_project.dart';
import 'package:dev_track_app/view_models/user_feed_view_model.dart';
import 'package:dev_track_app/views/common_pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_models/admin_post_view_model.dart';
//other models
import 'view_models/enrollment_view_model.dart';
//login cmponent
import 'view_models/login_view_model.dart';

// void main() {
//   runApp(const MyApp());
// }

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => UserFeedViewModel()),
        ChangeNotifierProvider(create: (_) => PostViewModel()),
        ChangeNotifierProvider(create: (_) => EnrollmentViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Dev Track App',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        debugShowCheckedModeBanner: false,
        home: LoginPage());
  }
}
