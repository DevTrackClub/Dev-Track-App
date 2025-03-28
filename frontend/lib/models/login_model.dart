class LoginModel {
  final String message;
  final String role;
  final String csrfToken;

  LoginModel(
      {required this.message, required this.role, required this.csrfToken});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      message: json['message'],
      role: json['role'],
      csrfToken: json['csrf_token'],
    );
  }
}
