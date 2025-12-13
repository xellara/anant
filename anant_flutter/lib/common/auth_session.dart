class AuthSession {
  static final AuthSession _instance = AuthSession._internal();
  factory AuthSession() => _instance;
  AuthSession._internal();

  int? userId;
}

final authSession = AuthSession();
