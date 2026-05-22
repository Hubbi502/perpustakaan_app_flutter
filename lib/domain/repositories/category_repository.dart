import 'package:library_app/domain/entities/category.dart';

/// Abstract category repository interface.
abstract class CategoryRepository {
  Future<List<Category>> getCategories();
  Future<Category> getCategory(int id);
  Future<Category> createCategory({required String name, String? description});
  Future<Category> updateCategory(int id, {String? name, String? description});
  Future<void> deleteCategory(int id);
}
