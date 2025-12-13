import 'package:anant_flutter/features/auth/domain/user_entity.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final UserEntity user;
  const AuthAuthenticated(this.user);
}
class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}