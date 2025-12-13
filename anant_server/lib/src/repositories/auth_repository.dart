import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

import 'package:serverpod_auth_server/module.dart' as auth;

abstract class AuthRepository {
  Future<User?> findUserByEmail(Session session, String email);
  Future<User?> findUserByAnantId(Session session, String anantId);
  Future<User?> findUserByAnantIdCaseInsensitive(Session session, String anantId);
  Future<User> createUser(Session session, User user);
  Future<void> createCredentials(Session session, UserCredentials credentials);
  Future<UserCredentials?> findCredentialsByUserId(Session session, int userId);
  
  // Serverpod Auth User methods
  Future<auth.UserInfo?> findAuthUserByIdentifier(Session session, String identifier);
  Future<auth.UserInfo?> createAuthUser(Session session, auth.UserInfo userInfo);
  Future<auth.AuthKey> signInUser(Session session, int userId, String method, {Set<Scope> scopes = const {}});
}
