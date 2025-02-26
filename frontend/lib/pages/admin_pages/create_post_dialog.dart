import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/admin_post_model.dart';

class CreatePostDialog extends StatefulWidget {
  final Function(Post) onPostCreated;

  const CreatePostDialog({Key? key, required this.onPostCreated})
      : super(key: key);

  @override
  _CreatePostDialogState createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<CreatePostDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text("Create Post"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter your name',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _postController,
            maxLines: 4,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Type your message',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Close dialog
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
          onPressed: () {
            if (_nameController.text.isNotEmpty &&
                _postController.text.isNotEmpty) {
              DateTime now = DateTime.now();
              String formattedDate = DateFormat('dd/MMM hh:mm a').format(now);

              String daysAgo = "Today";
              DateTime postDate = now.subtract(const Duration(days: 0));
              int difference = now.difference(postDate).inDays;

              if (difference == 1) {
                daysAgo = "Yesterday";
              } else if (difference > 1) {
                daysAgo = "$difference Days ago";
              }

              String finalTime = "$daysAgo • $formattedDate";
              Post newPost = Post(
                name: _nameController.text,
                dateTime: finalTime,
                description: _postController.text,
              );
              widget.onPostCreated(newPost); // Add post to list
              Navigator.pop(context); // Close dialog
            }
          },
          child: const Text(
            'Post',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
