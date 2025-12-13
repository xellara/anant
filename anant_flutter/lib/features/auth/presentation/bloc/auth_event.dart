abstract class AuthEvent {}

class AuthCheckSession extends AuthEvent {}
class AuthLoginOrSignUp extends AuthEvent {
  final String username;
  final String password;
  final bool hasReferral;

  AuthLoginOrSignUp({required this.username, required this.password, required this.hasReferral});
}
class AuthLogoutRequested extends AuthEvent {}
class AuthClearError extends AuthEvent {}
class AuthReset extends AuthEvent {}