import 'package:dev_track_app/pages/admin_pages/admin_feed_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/login_view_model.dart';

// void main() {
//   runApp(const MyApp());
// }

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
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
        home: AdminFeedPage());
  }
}
