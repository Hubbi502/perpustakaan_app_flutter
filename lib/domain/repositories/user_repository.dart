import 'package:library_app/domain/entities/user.dart';

/// Abstract user management repository interface (admin only).
abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<User> getUser(int id);
  Future<User> createUser({
    required String name,
    required String email,
    required String password,
    required String role,
  });
  Future<User> updateUser(int id, {String? name, String? email, String? role, String? password});
  Future<void> deleteUser(int id);
}
