import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dev_track_app/models/user_feed_model.dart';
import 'package:dev_track_app/view_models/user_feed_view_model.dart';

class UserFeedPage extends StatefulWidget {
  const UserFeedPage({super.key});

  @override
  State<UserFeedPage> createState() => _UserFeedPageState();
}

// class Post {
//   final String details;

//   Post({required this.details});
// }

class _UserFeedPageState extends State<UserFeedPage> {
  
  // final List<Post> posts = [
  //   Post(details: "Post 1 details"),
  //   Post(details: 'Post 2 details'),
  //   Post(details: 'Post 3 details'),
  // ];

  @override
  // void initState() {
  //   super.initState();
  //   // Fetch feed data as soon as the screen is initialized
  //   Provider.of<UserFeedViewModel>(context, listen: false).fetchUserFeed();
  // }

    void initState() {
    super.initState();
    Future.microtask(() {
      context.read<UserFeedViewModel>().fetchUserFeed();
    });
  }

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
              // _buildTabBar(),
              // const SizedBox(height: 10),

              // Main Feed Area
              Expanded(
                child: Consumer<UserFeedViewModel>(
                  builder: (context, feedVM, child) {
                    if (feedVM.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (feedVM.errorMessage != null) {
                      return Center(child: Text(feedVM.errorMessage!));
                    }
                    return ListView.builder(
                      itemCount: feedVM.feedItems.length,
                      itemBuilder: (context, index) {
                        final post = feedVM.feedItems[index];
                        return UserFeedCard(
                          post: post,
                          onViewMore: () => _showPopup(context, post),
                        );
                      },
                    );
                  },
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

  void _showPopup(BuildContext context, UserFeedModel post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(post.title),
          content: Text(post.description), // fetchhh post details.....
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("WELCOME BACK"),
        Text(
          "Bharathan",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Widget _buildTabBar() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.grey[200],
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       children: [
  //         _buildTab("Primary", isSelected: true),
  //         _buildTab("Secondary"),
  //         _buildTab("Ternary"),
  //       ],
  //     ),
  //   );
  // }

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
}

class UserFeedCard extends StatelessWidget {
  final UserFeedModel post;
  final VoidCallback onViewMore;

  const UserFeedCard({Key? key, required this.post, required this.onViewMore,}):super(key: key);

  @override
  Widget build(BuildContext context) {
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
                children: [
                  // Name or "created_by_id" can be used if your API returns it
                  const Text(
                    "Name",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  // Example: format from post.createdAt
                  Text(
                    "Posted on ${post.createdAt}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            post.description,
            style: const TextStyle(fontSize: 14),
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
                onPressed: onViewMore,
                backgroundColor: Colors.purple,
                mini: true,
                child: const Icon(Icons.arrow_forward,
                    color: Colors.white, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
