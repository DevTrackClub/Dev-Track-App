import 'package:dev_track_app/models/user_feed_model.dart';
import 'package:dev_track_app/utils/bottomnavbar.dart';
import 'package:dev_track_app/utils/topnavbar.dart';
import 'package:dev_track_app/view_models/user_feed_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../view_models/login_view_model.dart';
import '../common_pages/login_page.dart';

class UserFeedPage extends StatefulWidget {
  const UserFeedPage({super.key});

  @override
  State<UserFeedPage> createState() => _UserFeedPageState();
}

class _UserFeedPageState extends State<UserFeedPage> {
  int _selectedIndex = 0;

  @override
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
        appBar: TopNavBar(onNotificationTap: () {}),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildHeader(),
              const SizedBox(height: 10),
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
          onPressed: () {},
        ),
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

  void _showPopup(BuildContext context, UserFeedModel post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(post.title),
          content: Text(post.description),
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
          "Retard",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class UserFeedCard extends StatelessWidget {
  final UserFeedModel post;
  final VoidCallback onViewMore;

  const UserFeedCard({Key? key, required this.post, required this.onViewMore})
      : super(key: key);

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
                  const Text(
                    "Name",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    "${post.createdAt}",
                    style: TextStyle(fontSize: 12, color: Colors.grey[800]),
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
