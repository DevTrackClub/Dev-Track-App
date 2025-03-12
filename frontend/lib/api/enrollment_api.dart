import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/enrollment_model.dart';

class EnrollmentApi {
  static const String domainListUrl =
      'https://dev-track-app.onrender.com/api/projects/domains/list';
  static const String enrollUrl =
      'https://dev-track-app.onrender.com/api/applications/enroll';

  // Get CSRF token from SharedPreferences
  Future<String?> _getCsrfToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('csrf_token');
    print('CSRF token from prefs: $token');
    return token;
  }

  // Get session cookie from SharedPreferences
  Future<String?> _getSessionCookie() async {
    final prefs = await SharedPreferences.getInstance();

    // First try to get the session cookie stored by AuthService
    final sessionCookie = prefs.getString('session_cookie');
    if (sessionCookie != null && sessionCookie.isNotEmpty) {
      print('✅ Using session cookie from AuthService');
      return sessionCookie;
    }

    // Fallback to checking for specific keys
    final possibleKeys = ['sessionid', 'session'];
    for (var key in possibleKeys) {
      final cookie = prefs.getString(key);
      if (cookie != null && cookie.isNotEmpty) {
        print('✅ Using session cookie key: $key');
        return cookie;
      }
    }

    print('⚠️ No valid session cookie found.');
    return null;
  }

  // Get HTTP headers with CSRF token and session cookie
  Future<Map<String, String>> _getHeaders() async {
    final csrfToken = await _getCsrfToken();
    final sessionCookie = await _getSessionCookie();

    final headers = {
      'Content-Type': 'application/json',
      'X-CSRFToken': csrfToken ?? '',
    };

    if (sessionCookie != null && sessionCookie.isNotEmpty) {
      // Use the full cookie string as it's stored by AuthService
      headers['Cookie'] = sessionCookie;
      print('✅ Added session cookie to headers');
    }

    return headers;
  }

  // Debug authentication state
  Future<void> debugAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();
    print('--- Auth Debug Information ---');
    print('Available SharedPreferences keys: $allKeys');

    final keysToCheck = [
      'csrf_token',
      'sessionid',
      'session',
      'session_cookie'
    ];
    for (var key in keysToCheck) {
      if (prefs.containsKey(key)) {
        final value = prefs.getString(key);
        final maskedValue =
            value != null ? '${value.substring(0, 4)}...[masked]' : 'null';
        print('$key: $maskedValue');
      } else {
        print('$key: not found');
      }
    }
    print('-------------------------------');
  }

  // Fetch available domains
  Future<List<Domain>> getDomains() async {
    print('EnrollmentApi: getDomains() called');

    try {
      await debugAuthState(); // Debug auth state before making request
      final headers = await _getHeaders();
      print('Making GET request to $domainListUrl');
      print('Request headers: $headers');

      final response =
          await http.get(Uri.parse(domainListUrl), headers: headers);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> domainsJson = jsonDecode(response.body);
        return domainsJson.map((json) => Domain.fromJson(json)).toList();
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception('Authentication failed: Please log in again');
      } else {
        throw Exception('Failed to load domains: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception in getDomains: $e');
      rethrow;
    }
  }

  // Submit enrollment preferences
  Future<EnrollmentResponse> submitEnrollment(EnrollmentRequest request) async {
    print('EnrollmentApi: submitEnrollment() called');

    try {
      await debugAuthState(); // Debug auth state before making request
      final headers = await _getHeaders();
      final requestBody = jsonEncode(request.toJson());

      // print('Making POST request to $enrollUrl');
      // print('Request headers: $headers');
      // print('Request body: $requestBody');

      final response = await http.post(
        Uri.parse(enrollUrl),
        headers: headers,
        body: requestBody,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return EnrollmentResponse.fromJson(jsonDecode(response.body));
      } else {
        String errorMessage = 'Enrollment failed';
        try {
          final responseData = jsonDecode(response.body);
          errorMessage =
              responseData['detail'] ?? responseData['message'] ?? errorMessage;
        } catch (e) {
          errorMessage = 'Enrollment failed: ${response.reasonPhrase}';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Exception in submitEnrollment: $e');
      rethrow;
    }
  }

  Future<bool> isActiveCycleRunning() async {
    print('🔍 EnrollmentApi: isActiveCycleRunning() called');

    try {
      final headers = await _getHeaders();
      print('🔑 Headers for cycle API request: $headers');

      print('📡 Making GET request to check active cycle status');
      final response = await http.get(
        Uri.parse(
            'https://dev-track-app.onrender.com/api/projects/cycle/create'),
        headers: headers,
      );

      print('📊 Cycle check response status: ${response.statusCode}');
      print('📄 Cycle check response body: ${response.body}');

      if (response.statusCode == 200) {
        final cycleData = jsonDecode(response.body);
        final isActive = cycleData['is_active'] ?? false;
        print('🔄 Cycle active status: $isActive');
        return isActive;
      } else {
        print(
            '⚠️ Non-200 response when checking cycle status. Defaulting to inactive');
        return false;
      }
    } catch (e) {
      print('❌ Exception in isActiveCycleRunning: $e');
      print('⚠️ Error occurred, defaulting to inactive cycle');
      return false;
    }
  }
}
