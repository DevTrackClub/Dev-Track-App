import 'package:flutter/material.dart';

import '../api/admin_post_api.dart';
import '../models/admin_post_model.dart';

class PostViewModel extends ChangeNotifier {
  final PostService _postService = PostService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Post> _posts = [];
  List<Post> get posts => _posts;

  String _message = "";
  String get message => _message;

  // Create a post
  Future<void> createPost(Post post) async {
    try {
      _isLoading = true;
      notifyListeners();

      PostResponse response = await _postService.createPost(post);
      _message = response.message;
      fetchPosts(); // Refresh the post list after creation
    } catch (e) {
      _message = "Failed to create post";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch all posts
  Future<void> fetchPosts() async {
    try {
      _isLoading = true;
      notifyListeners();

      _posts = await _postService.getPosts();
    } catch (e) {
      _message = "Failed to fetch posts";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> editPost(int postId, String title, String description) async {
    try {
      _isLoading = true;
      notifyListeners();

      Post updatedPost =
          await _postService.editPost(postId, title, description);
      int index = _posts.indexWhere((post) => post.id == postId);
      if (index != -1) {
        _posts[index] = updatedPost;
      }
      _message = "Post updated successfully";
    } catch (e) {
      _message = "Failed to edit post";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
