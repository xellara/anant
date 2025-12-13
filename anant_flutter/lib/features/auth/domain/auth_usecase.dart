import 'package:anant_flutter/common/auth_session.dart';
import 'package:anant_flutter/features/auth/domain/auth_repository.dart';
import 'package:anant_flutter/features/auth/domain/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUseCase {
  final AuthRepository repository;

  AuthUseCase(this.repository);

  Future<UserEntity?> login(String username, String password) {
    return repository.login(username, password);
  }

  Future<UserEntity?> checkSession() {
    return repository.checkSession();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    authSession.userId = null;
    await prefs.remove('userId');
    return repository.logout();
  }
}