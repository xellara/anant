import 'package:anant_server/src/repositories/auth_service.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:serverpod/serverpod.dart';
import 'package:anant_server/src/generated/protocol.dart';
import 'package:anant_server/src/repositories/auth_repository.dart';
import 'package:serverpod_auth_server/module.dart' as auth;
import 'package:bcrypt/bcrypt.dart';

@GenerateMocks([AuthRepository, Session])
import 'auth_service_test.mocks.dart';

void main() {
  late AuthService authService;
  late MockAuthRepository mockAuthRepository;
  late MockSession mockSession;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockSession = MockSession();
    authService = AuthService(mockAuthRepository);
  });

  group('AuthService', () {
    test('signUp creates user and credentials when user does not exist', () async {
      // Arrange
      final user = User(
        uid: 'test-uid',
        anantId: 'test-anant-id',
        email: 'test@example.com',
        role: UserRole.student,
        organizationName: 'Test Org',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final password = 'password123';
      final authUser = auth.UserInfo(
        id: 123,
        userIdentifier: user.anantId!,
        userName: user.anantId!,
        created: DateTime.now(),
        scopeNames: [],
        blocked: false,
      );

      when(mockAuthRepository.findAuthUserByIdentifier(mockSession, user.anantId!))
          .thenAnswer((_) async => null);
      when(mockAuthRepository.createAuthUser(mockSession, any))
          .thenAnswer((_) async => authUser);
      when(mockAuthRepository.createUser(mockSession, any))
          .thenAnswer((invocation) async => invocation.positionalArguments[1] as User);
      when(mockAuthRepository.createCredentials(mockSession, any))
          .thenAnswer((_) async {});

      // Act
      final result = await authService.signUp(mockSession, user, password);

      // Assert
      expect(result.anantId, equals(user.anantId));
      expect(result.id, equals(authUser.id)); // Should have linked ID
      verify(mockAuthRepository.createAuthUser(mockSession, any)).called(1);
      verify(mockAuthRepository.createUser(mockSession, any)).called(1);
      verify(mockAuthRepository.createCredentials(mockSession, any)).called(1);
    });

    test('signUp throws exception when user already exists', () async {
      // Arrange
      final user = User(
        uid: 'test-uid',
        anantId: 'test-anant-id',
        email: 'test@example.com',
        role: UserRole.student,
        organizationName: 'Test Org',
      );
      final password = 'password123';
      final authUser = auth.UserInfo(
        id: 123,
        userIdentifier: user.anantId!,
        userName: user.anantId!,
        created: DateTime.now(),
        scopeNames: [],
        blocked: false,
      );

      when(mockAuthRepository.findAuthUserByIdentifier(mockSession, user.anantId!))
          .thenAnswer((_) async => authUser);

      // Act & Assert
      expect(
        () => authService.signUp(mockSession, user, password),
        throwsException,
      );
      verifyNever(mockAuthRepository.createAuthUser(mockSession, any));
    });

    test('signIn succeeds with case-insensitive anantId', () async {
      // Arrange
      final anantIdInput = '25a003.student@anantschool.anant'; // Lowercase input
      final correctAnantId = '25A003.student@AnantSchool.anant'; // Stored ID
      final password = 'password123';
      final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
      
      final user = User(
        uid: 'uid',
        anantId: correctAnantId,
        email: 'test@example.com',
        role: UserRole.student,
        organizationName: 'AnantSchool',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      final authUser = auth.UserInfo(
        id: 123,
        userIdentifier: correctAnantId,
        userName: correctAnantId,
        created: DateTime.now(),
        scopeNames: [],
        blocked: false,
      );
      
      final credentials = UserCredentials(
        uid: 'uid',
        userId: 123,
        passwordHash: hashedPassword,
        anantId: correctAnantId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      final authKey = auth.AuthKey(
        id: 123,
        userId: 123,
        key: 'key',
        hash: 'hash',
        scopeNames: [],
        method: 'myAuth',
      );

      when(mockAuthRepository.findUserByAnantIdCaseInsensitive(mockSession, anantIdInput))
          .thenAnswer((_) async => user);
      when(mockAuthRepository.findAuthUserByIdentifier(mockSession, correctAnantId))
          .thenAnswer((_) async => authUser);
      when(mockAuthRepository.findCredentialsByUserId(mockSession, 123))
          .thenAnswer((_) async => credentials);
      when(mockAuthRepository.signInUser(mockSession, 123, 'myAuth'))
          .thenAnswer((_) async => authKey);

      // Act
      final result = await authService.signIn(mockSession, anantIdInput, password);

      // Assert
      expect(result, equals(authKey));
      verify(mockAuthRepository.findUserByAnantIdCaseInsensitive(mockSession, anantIdInput)).called(1);
      verify(mockAuthRepository.findAuthUserByIdentifier(mockSession, correctAnantId)).called(1);
    });
  });
}
