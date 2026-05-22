import 'package:flutter/material.dart';
import 'package:library_app/core/errors/exceptions.dart';
import 'package:library_app/data/repositories/book_repository_impl.dart';
import 'package:library_app/data/repositories/category_repository_impl.dart';
import 'package:library_app/domain/entities/book.dart';
import 'package:library_app/domain/entities/category.dart';
import 'package:library_app/domain/repositories/book_repository.dart';
import 'package:library_app/domain/repositories/category_repository.dart';

/// Book provider for pengunjung — handles browsing, pagination, and search.
class BookProvider extends ChangeNotifier {
  final BookRepository _bookRepo;
  final CategoryRepository _categoryRepo;

  BookProvider({BookRepository? bookRepo, CategoryRepository? categoryRepo})
      : _bookRepo = bookRepo ?? BookRepositoryImpl(),
        _categoryRepo = categoryRepo ?? CategoryRepositoryImpl();

  List<Book> _books = [];
  List<Category> _categories = [];
  Book? _selectedBook;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  int _currentPage = 1;
  int _lastPage = 1;
  int _total = 0;

  List<Book> get books => _books;
  List<Category> get categories => _categories;
  Book? get selectedBook => _selectedBook;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  int get currentPage => _currentPage;
  int get lastPage => _lastPage;
  int get total => _total;
  bool get hasMore => _currentPage < _lastPage;

  /// Fetch books (first page).
  Future<void> fetchBooks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _bookRepo.getBooks(page: 1);
      _books = result.books;
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

  /// Load more books (next page).
  Future<void> loadMore() async {
    if (_isLoadingMore || !hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final result = await _bookRepo.getBooks(page: _currentPage + 1);
      _books.addAll(result.books);
      _currentPage = result.currentPage;
      _lastPage = result.lastPage;
      _total = result.total;
    } catch (_) {}

    _isLoadingMore = false;
    notifyListeners();
  }

  /// Fetch single book detail.
  Future<void> fetchBookDetail(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedBook = await _bookRepo.getBook(id);
    } on AppException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Gagal memuat detail buku';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Fetch categories.
  Future<void> fetchCategories() async {
    try {
      _categories = await _categoryRepo.getCategories();
      notifyListeners();
    } catch (_) {}
  }

  void clearSelectedBook() {
    _selectedBook = null;
  }
}
