class DynamicMetadata {
  final String userId;
  final String type;
  final String content;
  final DateTime createdAt;

  DynamicMetadata({
    required this.userId,
    required this.type,
    required this.content,
    required this.createdAt,
  });

  factory DynamicMetadata.fromMap(Map<String, dynamic> data) {
    return DynamicMetadata(
      userId: data['userId'] ?? '',
      type: data['type'] ?? '',
      content: data['content'] ?? '',
      createdAt: DateTime.parse(data['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
