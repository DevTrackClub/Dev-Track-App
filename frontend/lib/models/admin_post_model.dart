class Post {
  final int id;
  final String title;
  final String description;
  final String createdAt;
  final int createdBy;

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.createdBy,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      createdAt: json["created_at"],
      createdBy: json["created_by"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
    };
  }
}

class PostResponse {
  final String message;
  final int postId;
  final String csrfToken;

  PostResponse({
    required this.message,
    required this.postId,
    required this.csrfToken,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      message: json["message"],
      postId: json["post_id"],
      csrfToken: json["csrf_token"],
    );
  }
}
