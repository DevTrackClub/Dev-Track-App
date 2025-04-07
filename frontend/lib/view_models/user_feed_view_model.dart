import 'dart:async';

import 'package:dev_track_app/api/user_feed_api.dart';
import 'package:flutter/foundation.dart';

import '../models/user_feed_model.dart';

class UserFeedViewModel extends ChangeNotifier {
  final UserFeedApi _feedApi = UserFeedApi();

  List<UserFeedModel> _posts = [];
  bool _isLoading = false;
  String? _error;
  Timer? _pollingTimer;

  List<UserFeedModel> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchUserFeed({bool showLoading = true}) async {
    if (showLoading) _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fetchedPosts = await _feedApi.getUserFeed();
      if (!listEquals(_posts, fetchedPosts)) {
        _posts = fetchedPosts;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }

    if (showLoading) {
      _isLoading = false;
      notifyListeners();
    }
  }

  void startPolling({int intervalSeconds = 30}) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(
      Duration(seconds: intervalSeconds),
      (_) => fetchUserFeed(showLoading: false),
    );
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
