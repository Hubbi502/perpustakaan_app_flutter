import 'package:library_app/core/utils/secure_storage.dart';
import 'package:library_app/data/models/user_model.dart';

/// Local data source for persisting auth session data securely.
class AuthLocalDatasource {
  final SecureStorage _storage;

  AuthLocalDatasource({SecureStorage? storage})
      : _storage = storage ?? SecureStorage.instance;

  Future<void> saveToken(String token) async {
    await _storage.saveToken(token);
  }

  Future<String?> getToken() async {
    return await _storage.getToken();
  }

  Future<void> saveUserData(UserModel user) async {
    await _storage.saveUserData(user.toJson());
  }

  Future<UserModel?> getUserData() async {
    final data = await _storage.getUserData();
    if (data == null) return null;
    return UserModel.fromJson(data);
  }

  Future<void> saveUserRole(String role) async {
    await _storage.saveUserRole(role);
  }

  Future<String?> getUserRole() async {
    return await _storage.getUserRole();
  }

  Future<void> saveRememberMe(bool value) async {
    await _storage.saveRememberMe(value);
  }

  Future<bool> getRememberMe() async {
    return await _storage.getRememberMe();
  }

  Future<void> clearSession() async {
    await _storage.clearSession();
  }

  Future<void> clearAll() async {
    await _storage.clearAll();
  }

  Future<bool> hasValidToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
