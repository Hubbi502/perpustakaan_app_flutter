import 'package:library_app/core/constants/api_constants.dart';
import 'package:library_app/core/network/api_client.dart';
import 'package:library_app/data/models/user_model.dart';

/// Remote data source for user management API calls (admin only).
class UserRemoteDatasource {
  final ApiClient _client;

  UserRemoteDatasource({ApiClient? client}) : _client = client ?? ApiClient.instance;

  Future<List<UserModel>> getUsers() async {
    final response = await _client.get(ApiConstants.users);
    return (response['data'] as List)
        .map((e) => UserModel.fromJson(e))
        .toList();
  }

  Future<UserModel> getUser(int id) async {
    final response = await _client.get(ApiConstants.userById(id));
    return UserModel.fromJson(response['data']);
  }

  Future<UserModel> createUser({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await _client.post(
      ApiConstants.users,
      body: {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      },
    );
    return UserModel.fromJson(response['data']);
  }

  Future<UserModel> updateUser(
    int id, {
    String? name,
    String? email,
    String? role,
    String? password,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (email != null) body['email'] = email;
    if (role != null) body['role'] = role;
    if (password != null) body['password'] = password;

    final response = await _client.put(
      ApiConstants.userById(id),
      body: body,
    );
    return UserModel.fromJson(response['data']);
  }

  Future<void> deleteUser(int id) async {
    await _client.delete(ApiConstants.userById(id));
  }
}
