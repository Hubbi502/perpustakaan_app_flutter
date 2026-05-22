import 'package:library_app/data/models/category_model.dart';
import 'package:library_app/domain/entities/book.dart';

/// Book data model — maps API JSON to domain entity.
class BookModel {
  final int id;
  final String title;
  final String? description;
  final String author;
  final String? coverImageUrl;
  final CategoryModel? category;
  final int? categoryId;
  final String? createdAt;
  final String? updatedAt;

  const BookModel({
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

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      author: json['author'] ?? '',
      coverImageUrl: json['cover_image_url'],
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
      categoryId: json['category_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'author': author,
      'cover_image_url': coverImageUrl,
      'category_id': categoryId ?? category?.id,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  Book toEntity() {
    return Book(
      id: id,
      title: title,
      description: description,
      author: author,
      coverImageUrl: coverImageUrl,
      category: category?.toEntity(),
      categoryId: categoryId ?? category?.id,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
