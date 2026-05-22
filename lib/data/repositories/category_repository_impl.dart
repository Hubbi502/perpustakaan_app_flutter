import 'package:library_app/data/datasources/category_remote_datasource.dart';
import 'package:library_app/domain/entities/category.dart';
import 'package:library_app/domain/repositories/category_repository.dart';

/// Concrete implementation of [CategoryRepository].
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDatasource _remote;

  CategoryRepositoryImpl({CategoryRemoteDatasource? remote})
      : _remote = remote ?? CategoryRemoteDatasource();

  @override
  Future<List<Category>> getCategories() async {
    final result = await _remote.getCategories();
    return result.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Category> getCategory(int id) async {
    final result = await _remote.getCategory(id);
    return result.toEntity();
  }

  @override
  Future<Category> createCategory({required String name, String? description}) async {
    final result = await _remote.createCategory(name: name, description: description);
    return result.toEntity();
  }

  @override
  Future<Category> updateCategory(int id, {String? name, String? description}) async {
    final result = await _remote.updateCategory(id, name: name, description: description);
    return result.toEntity();
  }

  @override
  Future<void> deleteCategory(int id) async {
    await _remote.deleteCategory(id);
  }
}
