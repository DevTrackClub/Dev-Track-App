// user_feed_model.dart

class UserFeedModel {
  final int id;
  final String title;
  final String description;
  final String createdAt;
  final int createdBy;

  UserFeedModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.createdBy,
  });

  factory UserFeedModel.fromJson(Map<String, dynamic> json) {
    return UserFeedModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: json['created_at'],
      createdBy: json['created_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'created_at': createdAt,
      'created_by': createdBy,
    };
  }
}
