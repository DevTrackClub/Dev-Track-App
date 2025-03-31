import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/login_api.dart';
import '../models/login_model.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? errorMessage;
  LoginModel? user;

  Future<void> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      user = await _authService.login(email, password);
    } catch (e) {
      errorMessage = 'Login failed. Please check your credentials.';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      user = null; // Clear user data
    } catch (e) {
      errorMessage = 'Logout failed';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  Future<String?> getCsrfToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('csrf_token');
  }

  Future<String?> getSessionCookie() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('session_cookie');
  }
}
