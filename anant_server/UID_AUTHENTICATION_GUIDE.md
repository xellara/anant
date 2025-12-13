# UID-Based Authentication Architecture

## Why UID is Better Than Sequential IDs

### Current Issues
```dart
// CURRENT: Using auto-increment integer IDs
User(
  id: 1234,  // Sequential, predictable, not portable
  anantId: "2425SA001.student@school.anant",  // Custom format
)
```

### Problems with Current Approach
1. **Not Portable** - Can't migrate between auth providers
2. **Predictable** - Sequential IDs are security risk
3. **Coupling** - Tied to specific database implementation
4. **No Offline Support** - Can't generate IDs client-side

## Recommended: UID-Based Architecture

### What is a UID?
A **UID (User ID)** is a globally unique identifier, typically a UUID v4:
- Example: `550e8400-e29b-41d4-a716-446655440000`
- 128-bit number, virtually impossible to collide
- Can be generated anywhere (client, server, database)
- Compatible with all major auth providers

### Benefits
✅ **Future-proof** - Works with Firebase, Supabase, Auth0, Clerk, etc.
✅ **Portable** - Can migrate between services
✅ **Secure** - Non-sequential, unpredictable
✅ **Offline-ready** - Generate on client before sync
✅ **Multi-region** - No ID conflicts across databases

## Updated User Model

### Step 1: Update User Model (Serverpod)

```yaml
# lib/src/models/user/user.spy.yaml
class: User
table: users
fields:
  uid: String, unique  # Primary identifier (UUID)
  email: String?, unique
  role: UserRole
  organizationId: String?  # Organization UID
  
  # Profile Information
  fullName: String?
  profileImageUrl: String?
  mobileNumber: String?
  
  # Student/Teacher Specific
  className: String?
  sectionName: String?
  rollNumber: String?
  admissionNumber: String?
  
  # Teacher Specific
  subjectTeaching: List<String>?
  classAndSectionTeaching: List<String>?
  
  # Metadata
  isActive: bool, default=true
  createdAt: DateTime, default(now)
  updatedAt: DateTime, default(now)
  
  # Legacy field (keep for migration)
  anantId: String?  # Deprecated, use uid instead

indexes:
  uid_idx:
    fields: uid
    unique: true
  email_idx:
    fields: email
    unique: true
  org_role_idx:
    fields: organizationId, role
```

### Step 2: Authentication Service with UID

```dart
// lib/src/services/auth_service.dart
import 'package:uuid/uuid.dart';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../repositories/user_repository.dart';
import '../exceptions/authentication_exception.dart';

class AuthService {
  final UserRepository _userRepository;
  final _uuid = const Uuid();

  AuthService(this._userRepository);

  /// Sign up new user with UID
  Future<SignUpResult> signUp(
    Session session, {
    required String email,
    required String password,
    required UserRole role,
    required String organizationId,
    String? fullName,
    Map<String, dynamic>? additionalData,
  }) async {
    // Generate UID (can also accept pre-generated UID from client)
    final uid = _uuid.v4();

    // Validate email is unique
    final existingUser = await _userRepository.findByEmail(session, email);
    if (existingUser != null) {
      throw AuthenticationException('Email already registered');
    }

    // Create user with UID
    final user = User(
      uid: uid,
      email: email,
      role: role,
      organizationId: organizationId,
      fullName: fullName,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Save user
    await _userRepository.createUser(session, user);

    // Create credentials (hashed password)
    await _createCredentials(session, uid, password);

    session.log('User created with UID: $uid');

    return SignUpResult(
      success: true,
      uid: uid,
      message: 'Account created successfully',
    );
  }

  /// Sign in with email/password (works with any auth provider)
  Future<AuthResult> signIn(
    Session session, {
    required String email,
    required String password,
  }) async {
    // Find user by email
    final user = await _userRepository.findByEmail(session, email);
    if (user == null) {
      throw AuthenticationException('Invalid credentials');
    }

    // Verify password
    final isValid = await _verifyPassword(session, user.uid, password);
    if (!isValid) {
      throw AuthenticationException('Invalid credentials');
    }

    // Generate auth token
    final authKey = await UserAuthentication.signInUser(
      session,
      user.uid,  // Using UID as identifier
      'email',
      scopes: {},
    );

    return AuthResult(
      success: true,
      uid: user.uid,
      authKey: authKey.key,
    );
  }

  /// Sign in with external provider (Firebase, Google, etc.)
  Future<AuthResult> signInWithProvider(
    Session session, {
    required String providerUid,  // UID from external provider
    required String provider,     // 'firebase', 'google', 'apple', etc.
    required String email,
    String? displayName,
    String? photoUrl,
  }) async {
    // Check if user exists
    var user = await _userRepository.findByProviderUid(
      session,
      providerUid,
      provider,
    );

    if (user == null) {
      // First time login - create account
      user = await _createUserFromProvider(
        session,
        providerUid: providerUid,
        provider: provider,
        email: email,
        displayName: displayName,
        photoUrl: photoUrl,
      );
    }

    // Generate auth token using our UID
    final authKey = await UserAuthentication.signInUser(
      session,
      user.uid,
      provider,
      scopes: {},
    );

    return AuthResult(
      success: true,
      uid: user.uid,
      authKey: authKey.key,
    );
  }

  /// Migrate from old anantId to UID
  Future<void> migrateToUid(Session session, String anantId) async {
    final user = await _userRepository.findByAnantId(session, anantId);
    if (user == null) {
      throw NotFoundException('User not found: $anantId');
    }

    if (user.uid.isEmpty) {
      // Generate new UID for legacy user
      final newUid = _uuid.v4();
      await _userRepository.updateUid(session, user.id, newUid);
      session.log('Migrated user $anantId to UID: $newUid');
    }
  }

  Future<void> _createCredentials(
    Session session,
    String uid,
    String password,
  ) async {
    final hashedPassword = await _hashPassword(password);
    await UserCredentials.db.insert(session, [
      UserCredentials(
        uid: uid,
        passwordHash: hashedPassword,
      )
    ]);
  }

  Future<bool> _verifyPassword(
    Session session,
    String uid,
    String password,
  ) async {
    final creds = await UserCredentials.db.findFirstRow(
      session,
      where: (t) => t.uid.equals(uid),
    );
    if (creds == null) return false;
    return await BCrypt.checkpw(password, creds.passwordHash);
  }

  Future<String> _hashPassword(String password) async {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  Future<User> _createUserFromProvider(
    Session session, {
    required String providerUid,
    required String provider,
    required String email,
    String? displayName,
    String? photoUrl,
  }) async {
    final uid = _uuid.v4();
    
    final user = User(
      uid: uid,
      email: email,
      fullName: displayName,
      profileImageUrl: photoUrl,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _userRepository.createUser(session, user);

    // Store provider mapping
    await ExternalAuthProvider.db.insert(session, [
      ExternalAuthProvider(
        uid: uid,
        provider: provider,
        providerUid: providerUid,
      )
    ]);

    return user;
  }
}
```

### Step 3: External Auth Provider Mapping

```yaml
# lib/src/models/auth/external_auth_provider.spy.yaml
class: ExternalAuthProvider
table: external_auth_providers
fields:
  uid: String  # Our internal UID
  provider: String  # 'firebase', 'google', 'apple', 'auth0', etc.
  providerUid: String  # UID from external provider
  createdAt: DateTime, default(now)
  metadata: String?  # JSON for provider-specific data

indexes:
  provider_uid_idx:
    fields: provider, providerUid
    unique: true
  uid_idx:
    fields: uid
```

### Step 4: Flutter Client Implementation

```dart
// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:anant_client/anant_client.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Client serverClient;
  final firebase.FirebaseAuth firebaseAuth;

  AuthRepositoryImpl({
    required this.serverClient,
    required this.firebaseAuth,
  });

  @override
  Future<AuthUser> signInWithEmail(String email, String password) async {
    // Option 1: Use Serverpod auth
    final result = await serverClient.auth.signIn(
      email: email,
      password: password,
    );

    return AuthUser(
      uid: result.uid,
      email: email,
      authToken: result.authKey,
    );
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    // Sign in with Firebase
    final firebaseUser = await _signInWithFirebase();

    // Send Firebase UID to backend
    final result = await serverClient.auth.signInWithProvider(
      providerUid: firebaseUser.uid,  // Firebase UID
      provider: 'firebase',
      email: firebaseUser.email!,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
    );

    // Backend returns OUR uid, not Firebase's
    return AuthUser(
      uid: result.uid,  // Our internal UID
      email: firebaseUser.email!,
      authToken: result.authKey,
    );
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
    await serverClient.auth.signOut();
  }

  Future<firebase.User> _signInWithFirebase() async {
    final googleProvider = firebase.GoogleAuthProvider();
    final userCredential = await firebaseAuth.signInWithProvider(googleProvider);
    return userCredential.user!;
  }
}
```

## Benefits of This Architecture

### 1. Multiple Auth Providers Simultaneously
```dart
// User can sign in with:
- Email/Password (Serverpod auth)
- Google (Firebase or Google Sign-In)
- Apple Sign-In
- Phone Number (Firebase or Twilio)
- Magic Link
- Biometric

// All map to same internal UID
User(uid: "550e8400-...")
```

### 2. Easy Migration Between Providers

```dart
// Switch from Firebase to Supabase?
// No problem! UID stays the same.

// BEFORE:
ExternalAuthProvider(
  uid: "550e8400-...",
  provider: "firebase",
  providerUid: "firebase-xyz123"
)

// AFTER:
ExternalAuthProvider(
  uid: "550e8400-...",  // Same UID!
  provider: "supabase",
  providerUid: "supabase-abc789"
)
```

### 3. Multi-Tenancy Support

```dart
// Same user, multiple organizations
User(
  uid: "550e8400-...",
  organizationId: "org-school-1"
)

User(
  uid: "550e8400-...",
  organizationId: "org-school-2"
)

// Or link via junction table
UserOrganization(
  uid: "550e8400-...",
  organizationId: "org-school-1",
  role: UserRole.teacher
)
```

## Migration Strategy

### Phase 1: Add UID Column (Non-Breaking)

```sql
-- Add UID column (nullable initially)
ALTER TABLE users ADD COLUMN uid VARCHAR(36);

-- Generate UIDs for existing users
UPDATE users 
SET uid = gen_random_uuid()::text 
WHERE uid IS NULL;

-- Make UID unique and non-null
ALTER TABLE users ALTER COLUMN uid SET NOT NULL;
ALTER TABLE users ADD CONSTRAINT users_uid_unique UNIQUE (uid);

-- Create index
CREATE INDEX idx_users_uid ON users(uid);
```

### Phase 2: Update Application Code

```dart
// Gradually update code to use UID instead of ID
// Both work during transition:

// OLD (still works):
final user = await User.db.findById(session, 1234);

// NEW (preferred):
final user = await User.db.findFirstRow(
  session,
  where: (t) => t.uid.equals("550e8400-..."),
);
```

### Phase 3: Update API Endpoints

```dart
// BEFORE:
Future<User?> getUser(Session session, int userId) async {
  return await User.db.findById(session, userId);
}

// AFTER:
Future<User?> getUser(Session session, String uid) async {
  return await User.db.findFirstRow(
    session,
    where: (t) => t.uid.equals(uid),
  );
}
```

### Phase 4: Deprecate Old IDs

```dart
// Keep old anantId for reference
User(
  uid: "550e8400-...",  // Primary identifier
  anantId: "2425SA001.student@school.anant",  // @deprecated
)
```

## Flutter Client Usage

```dart
// Store UID in SharedPreferences
SharedPreferences prefs = await SharedPreferences.getInstance();
await prefs.setString('uid', authResult.uid);

// Use UID for all API calls
final uid = prefs.getString('uid');
final attendance = await client.attendance.getUserAttendance(uid);
```

## Best Practices

### 1. Always Use UID for API Calls
```dart
// ✅ GOOD
Future<List<Attendance>> getUserAttendance(Session session, String uid)

// ❌ BAD
Future<List<Attendance>> getUserAttendance(Session session, int userId)
```

### 2. Generate UID Server-Side for Security
```dart
// ✅ GOOD - Server generates UID
final uid = Uuid().v4();
final user = User(uid: uid, ...);

// ❌ BAD - Client sends UID (can be manipulated)
// Never trust client-generated UIDs for security
```

### 3. Index UID Column
```yaml
indexes:
  uid_idx:
    fields: uid
    unique: true  # Fast lookups, enforce uniqueness
```

### 4. Use UID in All Relationships
```yaml
# Attendance references user by UID
class: Attendance
fields:
  userUid: String  # Not userId!
  # ... other fields
```

## Comparison: Auth Provider Support

| Provider | UID Format | Compatible? |
|----------|-----------|-------------|
| Firebase | 28-char string | ✅ Yes |
| Supabase | UUID v4 | ✅ Yes |
| Auth0 | Custom string | ✅ Yes |
| Clerk | Custom string | ✅ Yes |
| Custom (Serverpod) | UUID v4 | ✅ Yes |

## Example: Complete Auth Flow

```dart
// 1. User signs up with email
final result = await authService.signUp(
  session,
  email: 'student@school.com',
  password: 'SecurePass123!',
  role: UserRole.student,
);
// Backend generates: uid = "550e8400-..."

// 2. User adds Google sign-in
await authService.signInWithProvider(
  session,
  providerUid: 'firebase-xyz123',  // From Firebase
  provider: 'firebase',
  email: 'student@school.com',
);
// Links to existing uid = "550e8400-..."

// 3. User can sign in with either method
// Both return same UID!
```

## Summary

✅ **Use UID (UUID v4) as primary identifier**
✅ **Store provider mappings in separate table**
✅ **Keep legacy anantId for transition**
✅ **Index UID column for performance**
✅ **Generate UIDs server-side for security**
✅ **Use UID in all API calls and relationships**

This architecture gives you maximum flexibility to switch auth providers, support multiple auth methods, and scale globally without any breaking changes!

---

**Last Updated**: December 2, 2025
**Recommended**: ✅ Essential for production
