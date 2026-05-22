import 'dart:io';
import 'package:flutter/material.dart';
import 'package:library_app/core/errors/exceptions.dart';
import 'package:library_app/data/repositories/book_repository_impl.dart';
import 'package:library_app/domain/entities/book.dart';
import 'package:library_app/domain/repositories/book_repository.dart';

/// Book management provider for petugas — handles CRUD operations.
class BookManagementProvider extends ChangeNotifier {
  final BookRepository _repository;

  BookManagementProvider({BookRepository? repository})
      : _repository = repository ?? BookRepositoryImpl();

  List<Book> _books = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;
  int _currentPage = 1;
  int _lastPage = 1;
  int _total = 0;

  List<Book> get books => _books;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;
  int get total => _total;
  bool get hasMore => _currentPage < _lastPage;

  Future<void> fetchBooks({int page = 1}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.getBooks(page: page);
      if (page == 1) {
        _books = result.books;
      } else {
        _books.addAll(result.books);
      }
      _currentPage = result.currentPage;
      _lastPage = result.lastPage;
      _total = result.total;
    } on AppException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Gagal memuat buku';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Book> createBook({
    required String title,
    required String description,
    required String author,
    required int categoryId,
    File? coverImage,
  }) async {
    _isSaving = true;
    notifyListeners();

    try {
      final book = await _repository.createBook(
        title: title,
        description: description,
        author: author,
        categoryId: categoryId,
        coverImage: coverImage,
      );
      _books.insert(0, book);
      _total++;
      _isSaving = false;
      notifyListeners();
      return book;
    } catch (e) {
      _isSaving = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<Book> updateBook(int id, {
    String? title,
    String? description,
    String? author,
    int? categoryId,
    File? coverImage,
  }) async {
    _isSaving = true;
    notifyListeners();

    try {
      final book = await _repository.updateBook(
        id, title: title, description: description,
        author: author, categoryId: categoryId, coverImage: coverImage,
      );
      final index = _books.indexWhere((b) => b.id == id);
      if (index != -1) _books[index] = book;
      _isSaving = false;
      notifyListeners();
      return book;
    } catch (e) {
      _isSaving = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteBook(int id) async {
    await _repository.deleteBook(id);
    _books.removeWhere((b) => b.id == id);
    _total--;
    notifyListeners();
  }
}
