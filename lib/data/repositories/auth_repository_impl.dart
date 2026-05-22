import 'package:library_app/data/datasources/auth_local_datasource.dart';
import 'package:library_app/data/datasources/auth_remote_datasource.dart';
import 'package:library_app/data/models/user_model.dart';
import 'package:library_app/domain/entities/user.dart';
import 'package:library_app/domain/repositories/auth_repository.dart';

/// Concrete implementation of [AuthRepository].
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remote;
  final AuthLocalDatasource _local;

  AuthRepositoryImpl({
    AuthRemoteDatasource? remote,
    AuthLocalDatasource? local,
  })  : _remote = remote ?? AuthRemoteDatasource(),
        _local = local ?? AuthLocalDatasource();

  @override
  Future<({User user, String token})> login(String email, String password) async {
    final result = await _remote.login(email, password);
    return (user: result.user.toEntity(), token: result.token);
  }

  @override
  Future<({User user, String token})> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    final result = await _remote.register(name, email, password, passwordConfirmation);
    return (user: result.user.toEntity(), token: result.token);
  }

  @override
  Future<void> logout() async {
    try {
      await _remote.logout();
    } catch (_) {
      // If logout API fails (e.g., token already expired), still clear local session.
    }
    await _local.clearSession();
  }

  @override
  Future<User> getUser() async {
    final user = await _remote.getUser();
    return user.toEntity();
  }

  @override
  Future<String?> getSavedToken() async {
    return await _local.getToken();
  }

  @override
  Future<void> saveSession(String token, User user, bool rememberMe) async {
    await _local.saveToken(token);
    await _local.saveUserData(UserModel.fromEntity(user));
    await _local.saveUserRole(user.role);
    await _local.saveRememberMe(rememberMe);
  }

  @override
  Future<void> clearSession() async {
    await _local.clearSession();
  }

  @override
  Future<bool> isLoggedIn() async {
    return await _local.hasValidToken();
  }
}
