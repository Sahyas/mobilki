import 'dynamic_metadata.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String? description;
  final String? coverUrl;
  final String? fileUrl;
  final String? format;
  final List<DynamicMetadata> dynamicMetadata;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.description,
    this.coverUrl,
    this.fileUrl,
    this.format,
    this.dynamicMetadata = const [],
  });

  factory Book.fromFirestore(Map<String, dynamic> data, String id) {
    return Book(
      id: id,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      description: data['description'],
      coverUrl: data['coverUrl'],
      fileUrl: data['fileUrl'],
      format: data['format'],
      dynamicMetadata: (data['dynamicMetadata'] as List<dynamic>?)
          ?.map((e) => DynamicMetadata.fromMap(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'coverUrl': coverUrl,
      'fileUrl': fileUrl,
      'format': format,
      'dynamicMetadata': dynamicMetadata.map((e) => e.toMap()).toList(),
    };
  }
}
