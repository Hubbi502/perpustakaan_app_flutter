import 'package:library_app/data/datasources/user_remote_datasource.dart';
import 'package:library_app/domain/entities/user.dart';
import 'package:library_app/domain/repositories/user_repository.dart';

/// Concrete implementation of [UserRepository] (admin only).
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource _remote;

  UserRepositoryImpl({UserRemoteDatasource? remote})
      : _remote = remote ?? UserRemoteDatasource();

  @override
  Future<List<User>> getUsers() async {
    final result = await _remote.getUsers();
    return result.map((m) => m.toEntity()).toList();
  }

  @override
  Future<User> getUser(int id) async {
    final result = await _remote.getUser(id);
    return result.toEntity();
  }

  @override
  Future<User> createUser({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final result = await _remote.createUser(
      name: name,
      email: email,
      password: password,
      role: role,
    );
    return result.toEntity();
  }

  @override
  Future<User> updateUser(int id, {String? name, String? email, String? role, String? password}) async {
    final result = await _remote.updateUser(id, name: name, email: email, role: role, password: password);
    return result.toEntity();
  }

  @override
  Future<void> deleteUser(int id) async {
    await _remote.deleteUser(id);
  }
}
