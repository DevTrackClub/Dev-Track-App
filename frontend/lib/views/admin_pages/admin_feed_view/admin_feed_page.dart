import 'package:dev_track_app/utils/bottomnavbar.dart';
import 'package:dev_track_app/views/admin_pages/admin_feed_view/edit_post_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/admin_post_model.dart';
import '../../../view_models/admin_post_view_model.dart';
import '../../../view_models/login_view_model.dart';
import '../../common_pages/login_page.dart';
import '../admin_feed_view/create_post_dialog.dart';

class AdminFeedPage extends StatefulWidget {
  const AdminFeedPage({super.key});

  @override
  State<AdminFeedPage> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<AdminFeedPage> {
  //bottomnavbar index
  int _selectedIndex = 0;

  String formatDate(String createdAt) {
    DateTime postDate = DateTime.parse(createdAt).toLocal();
    DateTime now = DateTime.now();

    String formattedDate = DateFormat("dd/MMM hh:mm a").format(postDate);
    int difference = now.difference(postDate).inDays;

    String daysAgo = (difference == 0)
        ? "Today"
        : (difference == 1)
            ? "Yesterday"
            : "$difference Days ago";

    return "$daysAgo • $formattedDate";
  }

  @override
  void initState() {
    super.initState();
    Provider.of<PostViewModel>(context, listen: false).fetchPosts();
  }

  Widget build(BuildContext context) {
    final postViewModel = Provider.of<PostViewModel>(context);
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
              const SizedBox(height: 10),
              Expanded(
                child: postViewModel.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: postViewModel.posts.length,
                        itemBuilder: (context, index) {
                          return _buildPostCard(
                              postViewModel.posts[index], context, index);
                        },
                      ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _selectedIndex,
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
            onPressed: () {
              Navigator.pop(context);
            }),
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.black),
          onPressed: () {},
        ),
        ElevatedButton(
          onPressed: () async {
            final loginViewModel =
                Provider.of<LoginViewModel>(context, listen: false);
            await loginViewModel.logout();

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          child: Text("Logout"),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Feeed",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            showDialog(context: context, builder: (_) => CreatePostDialog());
          },
          child: const Text("+ Create Post"),
        ),
      ],
    );
  }

  Widget _buildPostCard(Post post, BuildContext context, int index) {
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
                  backgroundImage:
                      AssetImage("assets/images/dev_track_logo.jpg")),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    formatDate(post.createdAt),
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            post.description,
            style: const TextStyle(fontSize: 17),
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
              Row(
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditPostDialog(
                          index: index,
                          postId: post.id,
                          currentTitle: post.title,
                          currentDescription: post.description,
                        ),
                      );
                    },
                    backgroundColor: Colors.purple,
                    mini: true,
                    child:
                        const Icon(Icons.edit, color: Colors.white, size: 18),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Delete Post"),
                            content: const Text(
                                "Are you sure you want to delete this post?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  final postViewModel =
                                      Provider.of<PostViewModel>(context,
                                          listen: false);
                                  await postViewModel.deletePost(post.id);
                                  Navigator.pop(context);
                                },
                                child: const Text("Delete",
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    backgroundColor: Colors.purple,
                    mini: true,
                    child: const Icon(Icons.delete_forever,
                        color: Colors.white, size: 18),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
