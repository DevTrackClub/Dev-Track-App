import 'package:dev_track_app/view_models/user_feed_view_model.dart';
import 'package:dev_track_app/pages/common_pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_models/login_view_model.dart';
import 'pages/user_pages/user_feed_page.dart';


// void main() {
//   runApp(const MyApp());
// }

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => UserFeedViewModel()),
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
      home: UserFeedPage(),
      // home: LoginPage(),
    );
  }
}
