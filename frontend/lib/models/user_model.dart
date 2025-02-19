class UserModel {
  final String email;
  final String role; // 'admin' or 'user'

  UserModel({required this.email, required this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      role: json['role'],
    );
  }
}
