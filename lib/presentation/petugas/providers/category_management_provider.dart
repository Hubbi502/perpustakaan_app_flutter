import 'package:flutter/material.dart';
import 'package:library_app/core/errors/exceptions.dart';
import 'package:library_app/data/repositories/category_repository_impl.dart';
import 'package:library_app/domain/entities/category.dart';
import 'package:library_app/domain/repositories/category_repository.dart';

/// Category management provider for petugas.
class CategoryManagementProvider extends ChangeNotifier {
  final CategoryRepository _repository;

  CategoryManagementProvider({CategoryRepository? repository})
      : _repository = repository ?? CategoryRepositoryImpl();

  List<Category> _categories = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;

  Future<void> fetchCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _categories = await _repository.getCategories();
    } on AppException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Gagal memuat kategori';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Category> createCategory({required String name, String? description}) async {
    _isSaving = true;
    notifyListeners();

    try {
      final category = await _repository.createCategory(name: name, description: description);
      _categories.insert(0, category);
      _isSaving = false;
      notifyListeners();
      return category;
    } catch (e) {
      _isSaving = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<Category> updateCategory(int id, {String? name, String? description}) async {
    _isSaving = true;
    notifyListeners();

    try {
      final category = await _repository.updateCategory(id, name: name, description: description);
      final index = _categories.indexWhere((c) => c.id == id);
      if (index != -1) _categories[index] = category;
      _isSaving = false;
      notifyListeners();
      return category;
    } catch (e) {
      _isSaving = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteCategory(int id) async {
    await _repository.deleteCategory(id);
    _categories.removeWhere((c) => c.id == id);
    notifyListeners();
  }
}
