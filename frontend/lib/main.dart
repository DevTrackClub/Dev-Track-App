import 'package:dev_track_app/pages/common_pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/admin_post_view_model.dart';
import 'models/login_view_model.dart';

// void main() {
//   runApp(const MyApp());
// }

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => PostViewModel()),
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
