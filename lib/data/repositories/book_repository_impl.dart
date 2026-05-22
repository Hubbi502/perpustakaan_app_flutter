import 'dart:io';
import 'package:library_app/data/datasources/book_remote_datasource.dart';
import 'package:library_app/domain/entities/book.dart';
import 'package:library_app/domain/repositories/book_repository.dart';

/// Concrete implementation of [BookRepository].
class BookRepositoryImpl implements BookRepository {
  final BookRemoteDatasource _remote;

  BookRepositoryImpl({BookRemoteDatasource? remote})
      : _remote = remote ?? BookRemoteDatasource();

  @override
  Future<({List<Book> books, int currentPage, int lastPage, int total})> getBooks({
    int page = 1,
  }) async {
    final result = await _remote.getBooks(page: page);
    return (
      books: result.books.map((m) => m.toEntity()).toList(),
      currentPage: result.currentPage,
      lastPage: result.lastPage,
      total: result.total,
    );
  }

  @override
  Future<Book> getBook(int id) async {
    final result = await _remote.getBook(id);
    return result.toEntity();
  }

  @override
  Future<Book> createBook({
    required String title,
    required String description,
    required String author,
    required int categoryId,
    File? coverImage,
  }) async {
    final result = await _remote.createBook(
      title: title,
      description: description,
      author: author,
      categoryId: categoryId,
      coverImage: coverImage,
    );
    return result.toEntity();
  }

  @override
  Future<Book> updateBook(
    int id, {
    String? title,
    String? description,
    String? author,
    int? categoryId,
    File? coverImage,
  }) async {
    final result = await _remote.updateBook(
      id,
      title: title,
      description: description,
      author: author,
      categoryId: categoryId,
      coverImage: coverImage,
    );
    return result.toEntity();
  }

  @override
  Future<void> deleteBook(int id) async {
    await _remote.deleteBook(id);
  }
}
