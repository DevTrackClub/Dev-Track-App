import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/admin_post_view_model.dart';

class EditPostDialog extends StatefulWidget {
  final int index;
  final int postId;
  final String currentTitle;
  final String currentDescription;

  const EditPostDialog({
    Key? key,
    required this.index,
    required this.postId,
    required this.currentTitle,
    required this.currentDescription,
  }) : super(key: key);

  @override
  _EditPostDialogState createState() => _EditPostDialogState();
}

class _EditPostDialogState extends State<EditPostDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.currentTitle);
    _descController = TextEditingController(text: widget.currentDescription);
  }

  @override
  Widget build(BuildContext context) {
    final postViewModel = Provider.of<PostViewModel>(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Edit Post',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Edit your title',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Edit your message',
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                  onPressed: () async {
                    if (_titleController.text.isNotEmpty &&
                        _descController.text.isNotEmpty) {
                      await postViewModel.editPost(
                        widget.postId,
                        _titleController.text,
                        _descController.text,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: postViewModel.isLoading
                      ? CircularProgressIndicator()
                      : const Text('Save',
                          style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
