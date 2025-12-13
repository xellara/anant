import 'package:anant_flutter/features/auth/domain/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> login(String username, String password);
  Future<UserEntity?> checkSession();
  Future<void> logout();
}