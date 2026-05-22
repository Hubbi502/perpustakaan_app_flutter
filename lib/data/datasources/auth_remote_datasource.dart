import 'package:library_app/core/constants/api_constants.dart';
import 'package:library_app/core/network/api_client.dart';
import 'package:library_app/data/models/user_model.dart';

/// Remote data source for authentication API calls.
class AuthRemoteDatasource {
  final ApiClient _client;

  AuthRemoteDatasource({ApiClient? client}) : _client = client ?? ApiClient.instance;

  Future<({UserModel user, String token, String tokenType})> login(
    String email,
    String password,
  ) async {
    final response = await _client.post(
      ApiConstants.login,
      body: {'email': email, 'password': password},
      requireAuth: false,
    );

    final data = response['data'];
    return (
      user: UserModel.fromJson(data['user']),
      token: data['token'] as String,
      tokenType: data['token_type'] as String,
    );
  }

  Future<({UserModel user, String token, String tokenType})> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    final response = await _client.post(
      ApiConstants.register,
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
      requireAuth: false,
    );

    final data = response['data'];
    return (
      user: UserModel.fromJson(data['user']),
      token: data['token'] as String,
      tokenType: data['token_type'] as String,
    );
  }

  Future<void> logout() async {
    await _client.post(ApiConstants.logout);
  }

  Future<UserModel> getUser() async {
    final response = await _client.get(ApiConstants.user);
    return UserModel.fromJson(response['data']);
  }
}
