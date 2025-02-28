// user_feed_view_model.dart

import 'package:dev_track_app/api/user_feed_api.dart';
import 'package:flutter/material.dart';
import '../models/user_feed_model.dart';

class UserFeedViewModel extends ChangeNotifier {
  final UserFeedApi _feedApi = UserFeedApi();

  bool isLoading = false;
  String? errorMessage;
  List<UserFeedModel> feedItems = [];

  Future<void> fetchUserFeed() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      feedItems = await _feedApi.getUserFeed();
      // Sort by date (most recent on top) if needed
      feedItems.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      errorMessage = 'Could not fetch user feed: $e';
    }

    isLoading = false;
    notifyListeners();
  }
}
