// user_feed_api.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_feed_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserFeedApi {
  static const String feedUrl = 'https://dev-track-app.onrender.com/api/posts/';

  Future<List<UserFeedModel>> getUserFeed() async {

    print('--- UserFeedService: getUserFeed() called ---');

    // Retrieve the stored CSRF token
    final prefs = await SharedPreferences.getInstance();
    final csrfToken = prefs.getString('csrf_token');
    print('CSRF token from prefs: $csrfToken');

    // 2. Prepare the headers
    final headers = {
      'Content-Type': 'application/json',
      // If your server expects a different header (e.g., Authorization), change it here
      'X-CSRFToken': csrfToken ?? '',
    };

    print('Making GET request to $feedUrl');
    print('Request headers: $headers');



    // // If your Django backend expects the CSRF token in a header like "X-CSRFToken":
    // final response = await http.get(
    //   Uri.parse(feedUrl),
    //   headers: {
    //     'Content-Type': 'application/json',
    //     'X-CSRFToken': csrfToken ?? '',
    //   },
    // );
 try {
      // 3. Make the GET request
      final response = await http.get(Uri.parse(feedUrl), headers: headers);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // 4. Check if the call was successful
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Parsed data length: ${data.length}');
        // Convert each item in the list to UserFeedModel
        return data.map((item) => UserFeedModel.fromJson(item)).toList();
      } else {
        // If not 200, throw an error with status & body
        throw Exception('Could not fetch user feed: '
            'Status ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Catch any network or parsing exceptions
      print('Exception in getUserFeed: $e');
      rethrow; // rethrow so the ViewModel can handle it
    }
  }
}

//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       return data.map((jsonItem) => UserFeedModel.fromJson(jsonItem)).toList();
//     } else {
//       throw Exception('Failed to load feed: ${response.body}');
//     }
//   }
// }
