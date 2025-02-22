import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user_model.dart';
// static const String baseUrl = "https://dev-track-app.onrender.com";
// static const String loginEndpoint = "$baseUrl/user/login";

class AuthService {
  final String baseUrl = "https://dev-track-app.onrender.com/api/user/login";

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "password": password}),
      );
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        throw Exception('Failed to login  ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
