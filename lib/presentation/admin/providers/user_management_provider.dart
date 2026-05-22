import 'package:flutter/material.dart';
import 'package:library_app/core/errors/exceptions.dart';
import 'package:library_app/data/repositories/user_repository_impl.dart';
import 'package:library_app/domain/entities/user.dart';
import 'package:library_app/domain/repositories/user_repository.dart';

/// User management provider for admin.
class UserManagementProvider extends ChangeNotifier {
  final UserRepository _repository;

  UserManagementProvider({UserRepository? repository})
      : _repository = repository ?? UserRepositoryImpl();

  List<User> _users = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;

  List<User> get users => _users;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;

  List<User> get petugasList => _users.where((u) => u.isPetugas).toList();
  List<User> get pengunjungList => _users.where((u) => u.isPengunjung).toList();
  List<User> get adminList => _users.where((u) => u.isAdmin).toList();

  Future<void> fetchUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _users = await _repository.getUsers();
    } on AppException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Gagal memuat data pengguna';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<User> createUser({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    _isSaving = true;
    notifyListeners();

    try {
      final user = await _repository.createUser(name: name, email: email, password: password, role: role);
      _users.insert(0, user);
      _isSaving = false;
      notifyListeners();
      return user;
    } catch (e) {
      _isSaving = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<User> updateUser(int id, {String? name, String? email, String? role, String? password}) async {
    _isSaving = true;
    notifyListeners();

    try {
      final user = await _repository.updateUser(id, name: name, email: email, role: role, password: password);
      final index = _users.indexWhere((u) => u.id == id);
      if (index != -1) _users[index] = user;
      _isSaving = false;
      notifyListeners();
      return user;
    } catch (e) {
      _isSaving = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteUser(int id) async {
    await _repository.deleteUser(id);
    _users.removeWhere((u) => u.id == id);
    notifyListeners();
  }
}
