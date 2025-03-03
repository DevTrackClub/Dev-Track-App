import 'package:flutter/material.dart';


class AdminFeedPage extends StatefulWidget {
  const AdminFeedPage({super.key});

  @override
  State<AdminFeedPage> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<AdminFeedPage> {
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
                  itemCount: 3,
                  itemBuilder: (context, index) => _buildPostCard(),
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

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Feed",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreatePostPage()),
            );
          },
          child: const Text("+ Create Post"),
        ),
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

  Widget _buildPostCard() {
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  EditPostPage()),
                  );
                },
                backgroundColor: Colors.purple,
                mini: true,
                child: const Icon(Icons.edit, color: Colors.white, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CreatePostPage extends StatelessWidget {
  const CreatePostPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8, 
            height: MediaQuery.of(context).size.height * 0.5, 
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.purple, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Create Post',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Type your message',
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple),
                  onPressed: () {
                  },
                  child: Text('Post',
                    style: TextStyle(color: Colors.white),
                ),  
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditPostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8, 
            height: MediaQuery.of(context).size.height * 0.5, 
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.purple, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Edit Post',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Type your message',
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple),
                  onPressed: () {
                  },
                  child: Text('Save',
                    style: TextStyle(color: Colors.white),
                ),  
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}