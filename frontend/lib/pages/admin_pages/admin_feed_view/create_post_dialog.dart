import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/admin_post_model.dart';
import '../../../models/admin_post_view_model.dart';

class CreatePostDialog extends StatefulWidget {
  const CreatePostDialog({Key? key}) : super(key: key);

  @override
  _CreatePostDialogState createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<CreatePostDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final postViewModel = Provider.of<PostViewModel>(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text("Create Post"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter Title',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _descController,
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
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
          onPressed: () async {
            if (_titleController.text.isNotEmpty &&
                _descController.text.isNotEmpty) {
              Post newPost = Post(
                id: 0, // ID will be assigned by the backend
                title: _titleController.text,
                description: _descController.text,
                createdAt: "",
                createdBy: 0,
              );

              await postViewModel.createPost(newPost);
              Navigator.pop(context); // Close dialog
            }
          },
          child: postViewModel.isLoading
              ? CircularProgressIndicator()
              : const Text('Post', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
