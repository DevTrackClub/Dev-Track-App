import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/admin_post_model.dart';

class PostService {
  final String baseUrl = "https://dev-track-app.onrender.com/api/posts";

  //ADMIN CREATES POST
  Future<PostResponse> createPost(Post post) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? csrfToken = prefs.getString('csrf_token');
    String? sessionCookie = prefs.getString('session_cookie');

    print("Stored CSRF Token: $csrfToken");
    print("Stored Session Cookie: $sessionCookie");
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "X-CSRFToken": csrfToken ?? "",
    };

    if (sessionCookie != null && sessionCookie.isNotEmpty) {
      headers["Cookie"] = sessionCookie;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/add'),
      headers: headers,
      body: jsonEncode(post.toJson()),
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      return PostResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to create post");
    }
  }

  // LISTING ALL POSTS FOR DA ADMIN
  Future<List<Post>> getPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('session_cookie');

    final response = await http.get(
      Uri.parse('$baseUrl/'),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception("Failed to fetch posts");
    }
  }

  //CHAD EDITOR
  Future<Post> editPost(int postId, String title, String description) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? csrfToken = prefs.getString('csrf_token');
    String? sessionCookie = prefs.getString('session_cookie');

    print("Stored Session Cookie: $sessionCookie");

    final response = await http.put(
      Uri.parse('$baseUrl/$postId'),
      headers: {
        "Content-Type": "application/json",
        "Cookie": sessionCookie ?? "",
        "X-CSRFToken": csrfToken ?? "",
      },
      body: jsonEncode({
        "title": title,
        "description": description,
      }),
    );
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to edit post");
    }
  }
}
