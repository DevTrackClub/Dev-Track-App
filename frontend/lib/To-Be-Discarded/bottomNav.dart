// import 'package:flutter/material.dart';
// //Testing change
// import 'package:dev_track_app/pages/domain_pages/domain.dart';
// import 'package:dev_track_app/pages/home.dart';

// class BottomNav extends StatefulWidget {
//   const BottomNav({super.key});

//   @override
//   State<BottomNav> createState() => _BottomNavState();
// }

// class _BottomNavState extends State<BottomNav> {
//   int _currentIndex = 0;
//   final List<Widget> pages = [
//     const HomePag(),
//     // const ScrumPage(),
//     const DomainPage(),
//     // const ProgressPage(),
//     // const ProfilePage(),
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: pages[_currentIndex],
//         bottomNavigationBar: BottomNavigationBar(
//           currentIndex: _currentIndex,
//           type: BottomNavigationBarType.fixed,
//           backgroundColor: Colors.black,
//           selectedItemColor:
//               Colors.green, // Set the selected icon color to green
//           unselectedItemColor: Color.fromARGB(255, 2, 155, 73),
//           iconSize: 35, // Set the unselected icon color to green
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: 'Feed',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.supervisor_account),
//               label: 'Scrum',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.apps),
//               label: 'Domain',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.access_time),
//               label: 'Progress',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.person_rounded),
//               label: 'Profile',
//             ),
//           ],
//           onTap: (index) {
//             setState(() {
//               _currentIndex = index;
//             });
//           },
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(const BottomNav());
// }
