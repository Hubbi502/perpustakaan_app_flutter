import 'package:library_app/core/constants/api_constants.dart';
import 'package:library_app/core/network/api_client.dart';
import 'package:library_app/data/models/category_model.dart';

/// Remote data source for category API calls.
class CategoryRemoteDatasource {
  final ApiClient _client;

  CategoryRemoteDatasource({ApiClient? client}) : _client = client ?? ApiClient.instance;

  Future<List<CategoryModel>> getCategories() async {
    final response = await _client.get(ApiConstants.categories);
    return (response['data'] as List)
        .map((e) => CategoryModel.fromJson(e))
        .toList();
  }

  Future<CategoryModel> getCategory(int id) async {
    final response = await _client.get(ApiConstants.categoryById(id));
    return CategoryModel.fromJson(response['data']);
  }

  Future<CategoryModel> createCategory({
    required String name,
    String? description,
  }) async {
    final body = <String, dynamic>{'name': name};
    if (description != null) body['description'] = description;

    final response = await _client.post(ApiConstants.categories, body: body);
    return CategoryModel.fromJson(response['data']);
  }

  Future<CategoryModel> updateCategory(
    int id, {
    String? name,
    String? description,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (description != null) body['description'] = description;

    final response = await _client.put(
      ApiConstants.categoryById(id),
      body: body,
    );
    return CategoryModel.fromJson(response['data']);
  }

  Future<void> deleteCategory(int id) async {
    await _client.delete(ApiConstants.categoryById(id));
  }
}
