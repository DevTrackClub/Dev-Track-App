// lib/models/enrollment_model.dart

class Domain {
  final int id;
  final String name;

  Domain({required this.id, required this.name});

  factory Domain.fromJson(Map<String, dynamic> json) {
    return Domain(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class User {
  final String username;
  // Add other user properties as needed

  User({required this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? '',
    );
  }
}

class EnrollmentRequest {
  final int firstPreferenceId;
  final int secondPreferenceId;

  EnrollmentRequest({
    required this.firstPreferenceId,
    required this.secondPreferenceId,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_preference_id': firstPreferenceId,
      'second_preference_id': secondPreferenceId,
    };
  }
}

class EnrollmentResponse {
  final String message;

  EnrollmentResponse({required this.message});

  factory EnrollmentResponse.fromJson(Map<String, dynamic> json) {
    return EnrollmentResponse(
      message: json['message'] ?? 'Enrollment successful!',
    );
  }
}
