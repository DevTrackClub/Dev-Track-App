import 'package:dev_track_app/view_models/user_feed_view_model.dart';
import 'package:dev_track_app/views/admin_pages/admin_feed_view/admin_feed_page.dart';
import 'package:dev_track_app/views/common_pages/domain_pages/domain.dart';
import 'package:dev_track_app/views/common_pages/login_page.dart';
import 'package:dev_track_app/views/user_pages/project_pages/project_display/previous_projects.dart';
import 'package:dev_track_app/views/user_pages/user_feed_page.dart';
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
        routes: {
          '/userFeed': (context) => const UserFeedPage(),
          '/userProjects': (context) => const DomainPage(),
          '/adminFeed': (context) => const AdminFeedPage(),
          '/adminDomain': (context) => const PreviousProjects(),
        },
        title: 'Dev Track App',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        debugShowCheckedModeBanner: false,
        home: LoginPage());
  }
}
