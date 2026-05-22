import 'dart:io';
import 'package:library_app/domain/entities/book.dart';

/// Abstract book repository interface.
abstract class BookRepository {
  Future<({List<Book> books, int currentPage, int lastPage, int total})> getBooks({int page = 1});
  Future<Book> getBook(int id);
  Future<Book> createBook({
    required String title,
    required String description,
    required String author,
    required int categoryId,
    File? coverImage,
  });
  Future<Book> updateBook(
    int id, {
    String? title,
    String? description,
    String? author,
    int? categoryId,
    File? coverImage,
  });
  Future<void> deleteBook(int id);
}
