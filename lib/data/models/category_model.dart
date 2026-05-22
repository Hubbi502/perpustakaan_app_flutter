import 'package:library_app/data/models/book_model.dart';
import 'package:library_app/domain/entities/category.dart';

/// Category data model — maps API JSON to domain entity.
class CategoryModel {
  final int id;
  final String name;
  final String? description;
  final int? booksCount;
  final List<BookModel>? books;
  final String? createdAt;
  final String? updatedAt;

  const CategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.booksCount,
    this.books,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      booksCount: json['books_count'],
      books: json['books'] != null
          ? (json['books'] as List)
              .map((e) => BookModel.fromJson(e))
              .toList()
          : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'books_count': booksCount,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  Category toEntity() {
    return Category(
      id: id,
      name: name,
      description: description,
      booksCount: booksCount,
      books: books?.map((b) => b.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
