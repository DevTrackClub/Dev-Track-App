import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/login_api.dart';
import '../models/user_model.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? errorMessage;
  UserModel? user;

  Future<void> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      user = await _authService.login(email, password);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('role', user!.role);
      await prefs.setString('csrf_token', user!.csrfToken);
    } catch (e) {
      errorMessage = 'Login failed. Please check your credentials.';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }
}
