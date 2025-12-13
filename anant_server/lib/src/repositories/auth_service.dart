import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../repositories/auth_repository.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:serverpod_auth_server/module.dart' as auth;

class AuthService {
  final AuthRepository _authRepository;
  final _uuid = const Uuid();

  AuthService(this._authRepository);

  Future<User> signUp(Session session, User user, String password) async {
    // 1. Check if user exists
    final existingUser = await _authRepository.findAuthUserByIdentifier(session, user.anantId ?? '');
    if (existingUser != null) {
      throw Exception("User already exists");
    }

    // 2. Generate UID
    final uid = _uuid.v4();
    
    // 3. Create Auth User
    var userInfo = auth.UserInfo(
      userIdentifier: user.anantId ?? '',
      userName: user.anantId ?? '',
      email: user.email,
      blocked: false,
      created: DateTime.now().toUtc(),
      scopeNames: [],
    );
    
    final createdAuthUser = await _authRepository.createAuthUser(session, userInfo);
    if (createdAuthUser == null) {
        throw Exception("Failed to create auth user");
    }

    // 4. Hash Password
    final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

    // 5. Create User
    final newUser = user.copyWith(
      uid: uid,
      id: createdAuthUser.id, // Link ID
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    final createdUser = await _authRepository.createUser(session, newUser);

    // 6. Create Credentials
    final credentials = UserCredentials(
      uid: uid,
      userId: createdAuthUser.id!,
      passwordHash: hashedPassword,
      anantId: user.anantId ?? '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    await _authRepository.createCredentials(session, credentials);

    return createdUser;
  }

  Future<auth.AuthKey> signIn(Session session, String anantId, String password) async {
    print('Attempting login for anantId: $anantId');
    // 1. Find user in custom table case-insensitively to handle case variations
    final user = await _authRepository.findUserByAnantIdCaseInsensitive(session, anantId);
    print('Found user in custom table: ${user?.toJson()}');
    final correctAnantId = user?.anantId ?? anantId;
    print('Using correctAnantId: $correctAnantId');

    // 2. Find auth user
    final userInfo = await _authRepository.findAuthUserByIdentifier(session, correctAnantId);
    print('Found userInfo: ${userInfo?.id}');
    if (userInfo == null) {
      print('User not found for identifier: $correctAnantId');
      throw Exception("User not found");
    }

    // 3. Find credentials
    final credentials = await _authRepository.findCredentialsByUserId(session, userInfo.id!);
    print('Found credentials: ${credentials != null}');
    if (credentials == null) {
      print('Credentials not found for userId: ${userInfo.id}');
      throw Exception("Credentials not found");
    }

    // 4. Verify password
    if (!BCrypt.checkpw(password, credentials.passwordHash)) {
      print('Invalid password for user: $correctAnantId');
      throw Exception("Invalid password");
    }

    // 5. Sign in
    print('Login successful for user: $correctAnantId');
    return await _authRepository.signInUser(session, userInfo.id!, 'myAuth');
  }
}
