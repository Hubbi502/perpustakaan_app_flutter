import 'package:flutter/material.dart';
import 'package:library_app/core/errors/exceptions.dart';
import 'package:library_app/data/repositories/auth_repository_impl.dart';
import 'package:library_app/domain/entities/user.dart';
import 'package:library_app/domain/repositories/auth_repository.dart';

/// Auth state management provider.
class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  AuthProvider({AuthRepository? repository})
      : _repository = repository ?? AuthRepositoryImpl();

  User? _user;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;
  String get userRole => _user?.role ?? '';

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Check if user has a saved session (for splash screen).
  Future<bool> checkAuthStatus() async {
    try {
      final isLoggedIn = await _repository.isLoggedIn();
      if (isLoggedIn) {
        // Validate token by fetching user
        final user = await _repository.getUser();
        _user = user;
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
    } catch (e) {
      // Token expired or invalid — clear session
      await _repository.clearSession();
    }
    _isAuthenticated = false;
    notifyListeners();
    return false;
  }

  /// Login with email and password.
  Future<User> login(String email, String password, {bool rememberMe = false}) async {
    _setLoading(true);
    _error = null;

    try {
      final result = await _repository.login(email, password);
      _user = result.user;
      _isAuthenticated = true;

      await _repository.saveSession(result.token, result.user, rememberMe);

      _setLoading(false);
      return result.user;
    } on AppException catch (e) {
      _error = e.message;
      _setLoading(false);
      rethrow;
    } catch (e) {
      _error = 'Terjadi kesalahan yang tidak terduga';
      _setLoading(false);
      rethrow;
    }
  }

  /// Register new user.
  Future<User> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    _setLoading(true);
    _error = null;

    try {
      final result = await _repository.register(name, email, password, passwordConfirmation);
      _user = result.user;
      _isAuthenticated = true;

      await _repository.saveSession(result.token, result.user, false);

      _setLoading(false);
      return result.user;
    } on AppException catch (e) {
      _error = e.message;
      _setLoading(false);
      rethrow;
    } catch (e) {
      _error = 'Terjadi kesalahan yang tidak terduga';
      _setLoading(false);
      rethrow;
    }
  }

  /// Logout and clear session.
  Future<void> logout() async {
    _setLoading(true);
    try {
      await _repository.logout();
    } catch (_) {}
    _user = null;
    _isAuthenticated = false;
    _error = null;
    _setLoading(false);
  }

  /// Refresh user data from server.
  Future<void> refreshUser() async {
    try {
      final user = await _repository.getUser();
      _user = user;
      notifyListeners();
    } catch (_) {}
  }
}
