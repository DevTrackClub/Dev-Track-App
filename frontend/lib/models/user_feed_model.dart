// user_feed_model.dart

class UserFeedModel {
  final int id;
  final String title;
  final String description;
  final DateTime createdAt;
  final int createdById;

  UserFeedModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.createdById,
  });

  factory UserFeedModel.fromJson(Map<String, dynamic> json) {
    return UserFeedModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      createdById: json['created_by'],
    );
  }
}
