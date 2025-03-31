import 'dart:async';

import 'package:dev_track_app/api/user_feed_api.dart';
import 'package:flutter/foundation.dart';

import '../models/user_feed_model.dart';

class UserFeedViewModel extends ChangeNotifier {
  final UserFeedApi _feedApi = UserFeedApi();

  bool isLoading = false;
  String? errorMessage;
  List<UserFeedModel> feedItems = [];
  Timer? _pollingTimer;

  UserFeedViewModel() {
    fetchUserFeed();
    startPolling();
  }

  Future<void> fetchUserFeed({bool showLoading = false}) async {
    if (showLoading) {
      isLoading = true;
      notifyListeners();
    }

    try {
      final newFeedItems = await _feedApi.getUserFeed();

      if (!listEquals(feedItems, newFeedItems)) {
        // Only update if there's a change
        feedItems.clear();
        feedItems.addAll(newFeedItems);
        notifyListeners();
      }
    } catch (e) {
      errorMessage = 'Could not fetch user feed: $e';
      notifyListeners();
    }

    if (showLoading) {
      isLoading = false;
      notifyListeners();
    }
  }

  void startPolling({int intervalSeconds = 30}) {
    // Increase interval to 30s or more
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(Duration(seconds: intervalSeconds), (timer) {
      fetchUserFeed(showLoading: false);
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  @override
  void dispose() {
    stopPolling();
    super.dispose();
  }
}

// import 'package:dev_track_app/api/user_feed_api.dart';
// import 'package:flutter/material.dart';
// import '../models/user_feed_model.dart';

// class UserFeedViewModel extends ChangeNotifier {
//   final UserFeedApi _feedApi = UserFeedApi();

//   bool isLoading = false;
//   String? errorMessage;
//   List<UserFeedModel> feedItems = [];

//   Future<void> fetchUserFeed() async {
//     isLoading = true;
//     errorMessage = null;
//     notifyListeners();

//     try {
//       feedItems = await _feedApi.getUserFeed();
//       // Sort by date (most recent on top) if needed
//       feedItems.sort((a, b) => b.createdAt.compareTo(a.createdAt));
//     } catch (e) {
//       errorMessage = 'Could not fetch user feed: $e';
//     }

//     isLoading = false;
//     notifyListeners();
//   }
// }
