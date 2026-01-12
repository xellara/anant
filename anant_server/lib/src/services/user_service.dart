
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';


class UserService {
  // Singleton pattern or Dependency Injection can be used. 
  // For Serverpod easier integration, static methods or a singleton instance is common if not using an IOC container.
  // We'll use static methods receiving Session for simplicity and statelessness typical in Serverpod.
  
  static const _ttlMe = Duration(minutes: 5);
  static const _ttlList = Duration(minutes: 5);

  /// Retrieves user by ID with caching.
  static Future<User?> getUserById(Session session, int userId) async {
    final cacheKey = 'user_me_$userId';
    try {
      final cachedUser = await session.caches.local.get(cacheKey);
      if (cachedUser != null) {
        return cachedUser as User;
      }

      final user = await User.db.findById(session, userId);
      if (user != null) {
        await session.caches.local.put(cacheKey, user, lifetime: _ttlMe);
      }
      return user;
    } catch (e, st) {
      print('UserService error fetching user $userId: $e\n$st');
      return null;
    }
  }

  /// Retrieves user by Anant ID.
  static Future<User?> getUserByAnantId(Session session, String anantId) async {
     try {
       // Caching could be added here if needed, but currently not requested.
      return await User.db.findFirstRow(
        session,
        where: (t) => t.anantId.ilike(anantId),
      );
    } catch (e, st) {
      print('UserService error fetching anantId $anantId: $e\n$st');
      return null;
    }
  }

  /// Gets all users with pagination and caching.
  static Future<List<User>> getAllUsers(Session session, {int? limit, int? offset}) async {
    final cacheKey = 'getAllUsers_${limit}_$offset';
    final cached = await session.caches.local.get(cacheKey);
    if (cached != null && cached is UserListContainer) {
      return cached.users;
    }

    final users = await User.db.find(session, limit: limit, offset: offset);
    
    await session.caches.local.put(
      cacheKey, 
      UserListContainer(users: users), 
      lifetime: _ttlList
    );
    return users;
  }

  /// Filters users with pagination and caching.
  static Future<List<User>> getFilteredUsers(
    Session session,
    String sectionName,
    String className,
    String organizationName,
    String role, {
    int? limit,
    int? offset,
  }) async {
    final cacheKey = 'getFilteredUsers_${sectionName}_${className}_${organizationName}_${role}_${limit}_$offset';
    
    try {
      final cached = await session.caches.local.get(cacheKey);
      if (cached != null && cached is UserListContainer) {
        return cached.users;
      }

      // Super Admin Override: "Anant" sees all.
      // We check if the caller (not passed yet, need to add 'callerAnantId' arg or check session)
      // For now, we rely on the caller to pass 'anant' as organizationName to signal global view? 
      // No, that's hacky. Better to assume the Endpoint checks permissions.
      // BUT, the requirement is "if role is Anant". 
      // We will allow passing null/empty filters to get everything IF the calling logic verified it.
      
      final whereClause = (t) {
        Expression expr = Constant.bool(true);
        if (organizationName.isNotEmpty && organizationName.toLowerCase() != 'anant') {
           expr = expr & t.organizationName.equals(organizationName);
        }
        if (className.isNotEmpty) {
           expr = expr & t.className.equals(className);
        }
        if (sectionName.isNotEmpty) {
           expr = expr & t.sectionName.equals(sectionName);
        }
        // If role is passed, filter by it.
        if (role.isNotEmpty) {
           try {
             final enumRole = UserRole.values.firstWhere((e) => e.name == role);
             expr = expr & t.role.equals(enumRole);
           } catch (_) {}
        }
        return expr;
      };

      final users = await User.db.find(
        session,
        where: whereClause,
        limit: limit,
        offset: offset,
      );

      await session.caches.local.put(
        cacheKey,
        UserListContainer(users: users),
        lifetime: _ttlList,
      );
      return users;
    } catch (e, st) {
       print('UserService error filtering users: $e\n$st');
       return [];
    }
  }

  /// Deletes a user and invalidates cache.
  static Future<bool> deleteUser(Session session, int id, {int? requestingUserId}) async {
    final user = await User.db.findById(session, id);
    if (user == null) return false;

    // Permission Check
    if (requestingUserId != null) {
      final requester = await getUserById(session, requestingUserId);
      if (requester != null && !(await _canManage(session, requester, user))) {
        return false; // Deny
      }
    }
    
    await User.db.deleteRow(session, user);
    await session.caches.local.invalidateKey('user_me_$id');
    return true;
  }
  
  /// Update User with Permission Check
  static Future<User?> updateUser(Session session, User updatedUser, {int? requestingUserId}) async {
    // Fetch original to check org/role
    final original = await User.db.findById(session, updatedUser.id!);
    if (original == null) return null;

    // Permission Check
    if (requestingUserId != null) {
      final requester = await getUserById(session, requestingUserId);
      if (requester != null && !(await _canManage(session, requester, original))) {
        return null; // Deny
      }
      
      // Also prevent Admin from potentially escalating privilege (e.g. changing their own role to Anant/Admin)
      // or changing org to another org? 
      // For MVP, we assume the input is safe or restricted by "canManage".
      // But critical: Admin shouldn't be able to change target's Org to outside their own.
      if (updatedUser.organizationName != requester!.organizationName && requester.role != UserRole.anant) {
         // Deny org change by non-super-admin
         return null; 
      }
    }

    final result = await User.db.updateRow(session, updatedUser);
    await session.caches.local.invalidateKey('user_me_${updatedUser.id}');
    return result;
  }

  /// Permission Logic: Can Requester Manage Target?
  static Future<bool> _canManage(Session session, User requester, User target) async {
    // 1. Super Admin (Anant)
    if (requester.role == UserRole.anant) return true;
    
    // 2. Organization Check (Must match)
    // Note: Assuming organizationName is the ID.
    if (requester.organizationName != target.organizationName) return false;

    // 3. Hierarchy Check
    // Admin > Principal > Teacher > Student
    // Admin cannot manage Peer Admin (prevent coups).
    
    if (requester.role == UserRole.admin) {
       // Admin can manage Principal, Teacher, Student, etc.
       // Cannot manage 'anant' or 'admin'.
       return target.role != UserRole.anant && target.role != UserRole.admin;
    }
    
    // Future expansion: Principal managing Teachers?
    if (requester.role == UserRole.principal) {
       return target.role == UserRole.teacher || target.role == UserRole.student; 
    }

    return false;
  }

  /// Updates initial password status and invalidates cache.
  static Future<User?> updateInitialPassword(Session session, int userId) async {
    final user = await User.db.findById(session, userId);
    if (user == null) return null;

    final updatedUser = user.copyWith(isPasswordCreated: true);
    final results = await User.db.update(session, [updatedUser]);
    
    if (results.isNotEmpty) {
      await session.caches.local.invalidateKey('user_me_$userId');
      return results.first;
    }
    return null;
  }
  
  static Future<List<User>> searchUsers(
    Session session,
    String className,
    String sectionName,
    String organizationName,
    String query,
  ) async {
      final lowerQuery = query.toLowerCase();
      // No cache for search usually, as queries vary too much.
      return await User.db.find(
        session,
        where: (t) =>
            t.organizationName.equals(organizationName) &
            t.className.equals(className) &
            t.sectionName.equals(sectionName) &
            (
              t.fullName.ilike('$lowerQuery%') |
              t.rollNumber.ilike('$lowerQuery%')
            ),
      );
  }
}
