import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserFeedPage(),
    );
  }
}

class UserFeedPage extends StatefulWidget {
  const UserFeedPage({super.key});

  @override
  State<UserFeedPage> createState() => _UserFeedPageState();
}


class Post {
  final String details;

  Post({required this.details});
}

// In your _UserFeedPageState class
final List<Post> posts = [
  Post(details: "Lorem ipsum dolor sit amet et delectus accommodare  his consul copiosae legendos at vix ad putent delectus  delicata usu"),
  Post(details: 'Post 2 details'),
  Post(details: 'Post 3 details'),
];


class _UserFeedPageState extends State<UserFeedPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              const SizedBox(height: 10),
              _buildHeader(),
              const SizedBox(height: 10),
              _buildTabBar(),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) => _buildPostCard(context, index),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }
// when clicked on the more detail button it shulb pop up with a message of more deatils fetched from the card?
  void showPopup(BuildContext context , Post post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Post Details"),
          content: Text(post.details), // Display the post details
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the popup
            },
            child: Text("Close"),
          ),
        ],
      );
    },
  );
}

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(children: [
        Text("WELCOME BACK"),
         const Text(
          "Bharathan",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),],),
        
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTab("Primary", isSelected: true),
          _buildTab("Secondary"),
          _buildTab("Ternary"),
        ],
      ),
    );
  }

  Widget _buildTab(String title, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.purple : Colors.black,
        ),
      ),
    );
  }

 Widget _buildPostCard(BuildContext context, int index) {
  final post = posts[index];
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 20,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Name",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "2 Days ago • DD/month Time",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          "Lorem ipsum dolor sit amet et delectus accommodare "
          "his consul copiosae legendos at vix ad putent delectus "
          "delicata usu.",
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: List.generate(
                3,
                (index) => Container(
                  margin: const EdgeInsets.only(right: 8),
                  height: 10,
                  width: 30,
                  color: Colors.grey[300],
                ),
              ),
            ),
            FloatingActionButton(
              tooltip: 'View More',
              onPressed: () => showPopup(context, post), // Pass the post to showPopup
              backgroundColor: Colors.purple,
              mini: true,
              child: const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
            ),
          ],
        ),
      ],
    ),
  );
}
}
