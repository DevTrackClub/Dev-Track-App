import 'package:dev_track_app/models/user_feed_model.dart';
import 'package:dev_track_app/utils/bottomnavbar.dart';
import 'package:dev_track_app/utils/topnavbar.dart';
import 'package:dev_track_app/view_models/user_feed_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
      final viewModel = context.read<UserFeedViewModel>();
      viewModel.fetchUserFeed();
      viewModel.startPolling();
    });
  }

  @override
  void dispose() {
    context.read<UserFeedViewModel>().stopPolling();
    super.dispose();
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
                    if (feedVM.error != null) {
                      return Center(child: Text(feedVM.error!));
                    }
                    return ListView.builder(
                      itemCount: feedVM.posts.length,
                      itemBuilder: (context, index) {
                        final post = feedVM.posts[index];
                        return UserFeedCard(
                          post: post,
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

class UserFeedCard extends StatefulWidget {
  final UserFeedModel post;

  UserFeedCard({Key? key, required this.post}) : super(key: key);

  @override
  State<UserFeedCard> createState() => _UserFeedCardState();
}

class _UserFeedCardState extends State<UserFeedCard> {
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

  bool _isExpanded = false;

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
                  Text(
                    "${widget.post.title}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    formatDate(widget.post.createdAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Description
          Text(
            widget.post.description,
            maxLines: _isExpanded ? null : 2,
            overflow:
                _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
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
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Text(
                  _isExpanded ? "View less" : "View more",
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
