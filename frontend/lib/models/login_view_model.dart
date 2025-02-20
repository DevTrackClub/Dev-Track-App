import 'package:flutter/material.dart';
import '../api/login_api.dart';
import '../models/user_model.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserModel? _user;
  UserModel? get user => _user;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final user = await _authService.login(email, password);

    if (user != null) {
      _user = user;
    } else {
      _errorMessage = "Invalid email or password!";
    }

    _isLoading = false;
    notifyListeners();
  }
}
