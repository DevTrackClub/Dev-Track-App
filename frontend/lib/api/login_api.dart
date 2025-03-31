import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/login_model.dart';
// static const String baseUrl = "https://dev-track-app.onrender.com/api/user/user";
// static const String loginEndpoint = "$baseUrl/user/login";

class AuthService {
  final String baseUrl = "https://dev-track-app.onrender.com/api/user/login";

  Future<LoginModel> login(String email, String password) async {
    try {
      print("Logging in ... ");

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "password": password}),
      );
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('role', data["role"]);
        await prefs.setString('csrf_token', data["csrf_token"]);

        String? sessionCookie = response.headers['set-cookie'];
        if (sessionCookie != null) {
          await prefs.setString('session_cookie', sessionCookie);
          print("Stored Session Cookie: $sessionCookie");
        }
        return LoginModel.fromJson(data);
      } else {
        throw Exception('Failed to login  ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? sessionCookie = prefs.getString('session_cookie');
      String? csrfToken = prefs.getString('csrf_token');

      if (sessionCookie != null && csrfToken != null) {
        final response = await http.post(
          Uri.parse("$baseUrl/logout"),
          headers: {
            'Content-Type': 'application/json',
            'Cookie': sessionCookie,
            'X-CSRFToken': csrfToken,
          },
        );

        if (response.statusCode == 200) {
          print("Logout successful");
        } else {
          print("Failed to logout: ${response.body}");
        }
      }

      // Clear stored session details after logout
      await prefs.remove('role');
      await prefs.remove('csrf_token');
      await prefs.remove('session_cookie');

      print("User session cleared from SharedPreferences");
    } catch (e) {
      throw Exception('Error during logout: $e');
    }
  }
}
