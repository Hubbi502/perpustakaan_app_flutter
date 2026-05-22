import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:library_app/core/constants/app_constants.dart';

/// Wrapper around FlutterSecureStorage for encrypted token & user data persistence.
class SecureStorage {
  static SecureStorage? _instance;
  final FlutterSecureStorage _storage;

  SecureStorage._()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
          iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
        );

  static SecureStorage get instance {
    _instance ??= SecureStorage._();
    return _instance!;
  }

  // — Token —
  Future<void> saveToken(String token) async {
    await _storage.write(key: AppConstants.tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: AppConstants.tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: AppConstants.tokenKey);
  }

  // — User Data —
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _storage.write(
      key: AppConstants.userDataKey,
      value: jsonEncode(userData),
    );
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final data = await _storage.read(key: AppConstants.userDataKey);
    if (data == null) return null;
    return jsonDecode(data) as Map<String, dynamic>;
  }

  // — User Role —
  Future<void> saveUserRole(String role) async {
    await _storage.write(key: AppConstants.userRoleKey, value: role);
  }

  Future<String?> getUserRole() async {
    return await _storage.read(key: AppConstants.userRoleKey);
  }

  // — Remember Me —
  Future<void> saveRememberMe(bool value) async {
    await _storage.write(key: AppConstants.rememberMeKey, value: value.toString());
  }

  Future<bool> getRememberMe() async {
    final value = await _storage.read(key: AppConstants.rememberMeKey);
    return value == 'true';
  }

  // — Clear All —
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Clear session data but keep remember me preference.
  Future<void> clearSession() async {
    await _storage.delete(key: AppConstants.tokenKey);
    await _storage.delete(key: AppConstants.userDataKey);
    await _storage.delete(key: AppConstants.userRoleKey);
  }
}
