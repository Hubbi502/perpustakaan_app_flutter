import 'package:library_app/domain/entities/user.dart';

/// Abstract auth repository interface.
abstract class AuthRepository {
  Future<({User user, String token})> login(String email, String password);
  Future<({User user, String token})> register(String name, String email, String password, String passwordConfirmation);
  Future<void> logout();
  Future<User> getUser();
  Future<String?> getSavedToken();
  Future<void> saveSession(String token, User user, bool rememberMe);
  Future<void> clearSession();
  Future<bool> isLoggedIn();
}
