import 'package:dev_track_app/pages/admin_pages/edit_post_dialog.dart';
import 'package:flutter/material.dart';

import '../../models/admin_post_model.dart';
import 'create_post_dialog.dart';

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
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: Post.samplePosts.length,
                  itemBuilder: (context, index) =>
                      _buildPostCard(Post.samplePosts[index], context, index),
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
            showDialog(
              context: context,
              builder: (context) => CreatePostDialog(
                onPostCreated: (newPost) {
                  setState(() {
                    Post.samplePosts
                        .insert(0, newPost); // Add new post at the top
                  });
                },
              ),
            );
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
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    post.dateTime,
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
              FloatingActionButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => EditPostDialog(
                      index: index,
                      onPostUpdated: (updatedPost) {
                        setState(() {
                          Post.samplePosts[index] = updatedPost;
                        });
                      },
                      onPostDeleted: () {
                        setState(() {
                          Post.samplePosts.removeAt(index);
                        });
                      },
                    ),
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
