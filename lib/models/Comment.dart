class Comment {
  final int id ;
  final int post_id ;
  final int user_id ;
  final String content ;
  final int order ;

  Comment({required this.id, required this.post_id, required this.user_id, required this.content, required this.order});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'post_id': int post_id,
      'user_id': int user_id,
      'content': String content,
      'order': int order
      } =>
          Comment(
              id: id,
              post_id: post_id,
              user_id: user_id,
              content: content,
              order: order
          ),
      _ => throw const FormatException('Failed to load Country.'),
    };
  }

}