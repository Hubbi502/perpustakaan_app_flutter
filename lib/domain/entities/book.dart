import 'package:library_app/domain/entities/category.dart';

/// Book entity — domain layer representation.
class Book {
  final int id;
  final String title;
  final String? description;
  final String author;
  final String? coverImageUrl;
  final Category? category;
  final int? categoryId;
  final String? createdAt;
  final String? updatedAt;

  const Book({
    required this.id,
    required this.title,
    this.description,
    required this.author,
    this.coverImageUrl,
    this.category,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
  });

  Book copyWith({
    int? id,
    String? title,
    String? description,
    String? author,
    String? coverImageUrl,
    Category? category,
    int? categoryId,
    String? createdAt,
    String? updatedAt,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      author: author ?? this.author,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      category: category ?? this.category,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
