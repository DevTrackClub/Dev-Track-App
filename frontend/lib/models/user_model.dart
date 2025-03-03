class UserModel {
  final String message;
  final String role;
  final String csrfToken;

  UserModel(
      {required this.message, required this.role, required this.csrfToken});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      message: json['message'],
      role: json['role'],
      csrfToken: json['csrf_token'],
    );
  }
}
