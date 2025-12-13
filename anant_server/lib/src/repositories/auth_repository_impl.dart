import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'auth_repository.dart';
import 'package:serverpod_auth_server/module.dart' as auth;
import 'package:serverpod_auth_server/serverpod_auth_server.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<User?> findUserByEmail(Session session, String email) async {
    return await User.db.findFirstRow(
      session,
      where: (t) => t.email.equals(email),
    );
  }

  @override
  Future<User?> findUserByAnantId(Session session, String anantId) async {
    return await User.db.findFirstRow(
      session,
      where: (t) => t.anantId.equals(anantId),
    );
  }

  @override
  Future<User?> findUserByAnantIdCaseInsensitive(Session session, String anantId) async {
    return await User.db.findFirstRow(
      session,
      where: (t) => t.anantId.ilike(anantId),
    );
  }

  @override
  Future<User> createUser(Session session, User user) async {
    final result = await User.db.insert(session, [user]);
    return result.first;
  }

  @override
  Future<void> createCredentials(Session session, UserCredentials credentials) async {
    await UserCredentials.db.insert(session, [credentials]);
  }

  @override
  Future<UserCredentials?> findCredentialsByUserId(Session session, int userId) async {
    return await UserCredentials.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );
  }

  @override
  Future<auth.UserInfo?> findAuthUserByIdentifier(Session session, String identifier) async {
    return await auth.Users.findUserByIdentifier(session, identifier);
  }

  @override
  Future<auth.UserInfo?> createAuthUser(Session session, auth.UserInfo userInfo) async {
    return await auth.Users.createUser(session, userInfo, 'anantId');
  }

  @override
  Future<auth.AuthKey> signInUser(Session session, int userId, String method, {Set<Scope> scopes = const {}}) async {
    return await UserAuthentication.signInUser(session, userId, method, scopes: scopes);
  }
}
