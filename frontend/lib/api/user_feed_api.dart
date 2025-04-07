// user_feed_api.dart

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_feed_model.dart';

class UserFeedApi {
  static const String feedUrl = 'https://dev-track-app.onrender.com/api/posts/';

  Future<List<UserFeedModel>> getUserFeed() async {
    final prefs = await SharedPreferences.getInstance();
    final csrfToken = prefs.getString('csrf_token');

    final headers = {
      'Content-Type': 'application/json',
      'X-CSRFToken': csrfToken ?? '',
    };

    print('Making GET request to $feedUrl');

    final url = Uri.parse('$feedUrl');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => UserFeedModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}
