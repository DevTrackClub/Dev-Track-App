// lib/view_models/enrollment_view_model.dart

import 'package:flutter/material.dart';
import '../models/enrollment_model.dart';
import '../api/enrollment_api.dart';

class EnrollmentViewModel extends ChangeNotifier {
  final EnrollmentApi _api = EnrollmentApi();

  // State management
  List<Domain> _domains = [];
  bool _isLoadingDomains = true;
  bool _isSubmitting = false;
  String? _errorMessage;
  String? _successMessage;

  User? _user;
  bool _isLoading = true;

  // Selected domains
  Domain? _firstPreference;
  Domain? _secondPreference;

  // Getters
  List<Domain> get domains => _domains;
  bool get isLoadingDomains => _isLoadingDomains;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  Domain? get firstPreference => _firstPreference;
  Domain? get secondPreference => _secondPreference;
  User? get user => _user;
  bool get isLoading => _isLoading;

  // Initialize and fetch domains
  Future<void> initialize() async {
    await fetchDomains();
  }

  Future<void> fetchUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(Duration(seconds: 1)); // Simulate network delay
      _user = User(username: 'User'); // Placeholder
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch domains from API
  Future<void> fetchDomains() async {
    _isLoadingDomains = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _domains = await _api.getDomains();
      _isLoadingDomains = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoadingDomains = false;
      notifyListeners();
    }
  }

  // Set first preference
  void setFirstPreference(Domain? domain) {
    _firstPreference = domain;
    _errorMessage = null;
    notifyListeners();
  }

  // Set second preference
  void setSecondPreference(Domain? domain) {
    _secondPreference = domain;
    _errorMessage = null;
    notifyListeners();
  }

  // Validate preferences
  bool validatePreferences() {
    if (_firstPreference == null || _secondPreference == null) {
      _errorMessage = 'Please select both preferences';
      notifyListeners();
      return false;
    }

    if (_firstPreference!.id == _secondPreference!.id) {
      _errorMessage = 'First and second preferences cannot be the same';
      notifyListeners();
      return false;
    }

    return true;
  }

  // Submit enrollment
  Future<bool> submitEnrollment() async {
    if (!validatePreferences()) {
      return false;
    }

    _isSubmitting = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final request = EnrollmentRequest(
        firstPreferenceId: _firstPreference!.id,
        secondPreferenceId: _secondPreference!.id,
      );

      final response = await _api.submitEnrollment(request);
      _successMessage = response.message;
      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  // Clear messages
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}
