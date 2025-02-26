import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/admin_post_model.dart';

class EditPostDialog extends StatefulWidget {
  final int index;
  final Function(Post) onPostUpdated;
  final Function() onPostDeleted;

  const EditPostDialog({
    Key? key,
    required this.index,
    required this.onPostUpdated,
    required this.onPostDeleted,
  }) : super(key: key);

  @override
  _EditPostDialogState createState() => _EditPostDialogState();
}

class _EditPostDialogState extends State<EditPostDialog> {
  late TextEditingController _postController;

  @override
  void initState() {
    super.initState();
    _postController =
        TextEditingController(text: Post.samplePosts[widget.index].description);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Edit Post',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _postController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Edit your message',
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // DELETE BUTTON
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    widget.onPostDeleted(); // Remove post
                    Navigator.pop(context);
                  },
                  child: Text('Delete', style: TextStyle(color: Colors.white)),
                ),

                // SAVE BUTTON
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                  onPressed: () {
                    if (_postController.text.isNotEmpty) {
                      String updatedTime =
                          DateFormat("d/MMM hh:mm a").format(DateTime.now());
                      Post updatedPost = Post(
                        name: Post.samplePosts[widget.index].name,
                        dateTime: "Edited • $updatedTime", // Mark as edited
                        description: _postController.text,
                      );

                      widget.onPostUpdated(updatedPost);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
