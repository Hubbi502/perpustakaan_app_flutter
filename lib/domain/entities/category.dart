import 'package:library_app/domain/entities/book.dart';

/// Category entity — domain layer representation.
class Category {
  final int id;
  final String name;
  final String? description;
  final int? booksCount;
  final List<Book>? books;
  final String? createdAt;
  final String? updatedAt;

  const Category({
    required this.id,
    required this.name,
    this.description,
    this.booksCount,
    this.books,
    this.createdAt,
    this.updatedAt,
  });

  Category copyWith({
    int? id,
    String? name,
    String? description,
    int? booksCount,
    List<Book>? books,
    String? createdAt,
    String? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      booksCount: booksCount ?? this.booksCount,
      books: books ?? this.books,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
