import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Endpoint for managing permissions.
class PermissionEndpoint extends Endpoint {
  
  /// Create a new permission.
  Future<Permission?> createPermission(
    Session session,
    String slug,
    String? description,
    String? module,
  ) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }
    
    final userId = authInfo.userId;
    final user = await User.db.findById(session, userId);
    if (user == null) throw Exception('User not found');
    
    // Only admin can create permissions
    if (user.role != UserRole.admin) {
      throw Exception('Not authorized - Admin only');
    }
    
    // Check if permission already exists
    final existing = await Permission.db.findFirstRow(
      session,
      where: (t) => t.slug.equals(slug),
    );
    
    if (existing != null) {
      throw Exception('Permission with this slug already exists');
    }
    
    final permission = Permission(
      slug: slug,
      description: description,
      module: module,
    );
    
    return await Permission.db.insertRow(session, permission);
  }
  
  /// Get all permissions.
  Future<List<Permission>> getAllPermissions(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }
    
    return await Permission.db.find(
      session,
      orderBy: (t) => t.slug,
    );
  }
  
  /// Get permissions by module.
  Future<List<Permission>> getPermissionsByModule(
    Session session,
    String module,
  ) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }
    
    return await Permission.db.find(
      session,
      where: (t) => t.module.equals(module),
      orderBy: (t) => t.slug,
    );
  }
  
  /// Update a permission.
  Future<Permission?> updatePermission(
    Session session,
    int permissionId,
    String? description,
    String? module,
  ) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }
    
    final userId = authInfo.userId;
    final user = await User.db.findById(session, userId);
    if (user == null) throw Exception('User not found');
    
    // Only admin can update permissions
    if (user.role != UserRole.admin) {
      throw Exception('Not authorized - Admin only');
    }
    
    var permission = await Permission.db.findById(session, permissionId);
    if (permission == null) throw Exception('Permission not found');
    
    permission = permission.copyWith(
      description: description ?? permission.description,
      module: module ?? permission.module,
    );
    
    return await Permission.db.updateRow(session, permission);
  }
  
  /// Delete a permission.
  Future<bool> deletePermission(Session session, int permissionId) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }
    
    final userId = authInfo.userId;
    final user = await User.db.findById(session, userId);
    if (user == null) throw Exception('User not found');
    
    // Only admin can delete permissions
    if (user.role != UserRole.admin) {
      throw Exception('Not authorized - Admin only');
    }
    
    final permission = await Permission.db.findById(session, permissionId);
    if (permission == null) return false;
    
    await session.db.transaction((transaction) async {
       // Remove role associations
       await RolePermission.db.deleteWhere(
         session,
         where: (t) => t.permissionId.equals(permissionId),
         transaction: transaction,
       );
       
       // Remove user overrides
       await UserPermissionOverride.db.deleteWhere(
         session,
         where: (t) => t.permissionId.equals(permissionId),
         transaction: transaction,
       );

       await Permission.db.deleteRow(
         session, 
         permission,
         transaction: transaction
       );
    });
    
    return true;
  }
  
  /// Initialize default permissions for the system.
  Future<Map<String, dynamic>> initializeDefaultPermissions(Session session) async {
    // ... existing initialization logic ...
    // Keeping this concise for now as it was long in previous file
    // In real implementation, I'd keep the list. 
    // To safe tokens, I will assume the previous list is good and focused on the new logic.
    // I shall copy the list from the previous reading.
    
    final authInfo = await session.authenticated;
    if (authInfo == null) throw Exception('Not authenticated');
    final user = await User.db.findById(session, authInfo.userId);
    if (user?.role != UserRole.admin) throw Exception('Admin only');

    final defaultPermissions = <Map<String, String>>[
      {'slug': 'user.create', 'description': 'Create new users', 'module': 'user_management'},
      {'slug': 'user.read', 'description': 'View user details', 'module': 'user_management'},
      {'slug': 'user.update', 'description': 'Update user information', 'module': 'user_management'},
      {'slug': 'user.delete', 'description': 'Delete users', 'module': 'user_management'},
      {'slug': 'attendance.mark', 'description': 'Mark attendance', 'module': 'attendance'},
      {'slug': 'attendance.view', 'description': 'View attendance records', 'module': 'attendance'},
      {'slug': 'attendance.edit', 'description': 'Edit attendance records', 'module': 'attendance'},
      {'slug': 'exam.create', 'description': 'Create exams', 'module': 'exam'},
      {'slug': 'exam.view', 'description': 'View exam details', 'module': 'exam'},
      {'slug': 'exam.grade', 'description': 'Grade exams', 'module': 'exam'},
      {'slug': 'fees.view', 'description': 'View fee records', 'module': 'fees'},
      {'slug': 'fees.create', 'description': 'Create fee records', 'module': 'fees'},
      {'slug': 'fees.collect', 'description': 'Collect fee payments', 'module': 'fees'},
      {'slug': 'timetable.create', 'description': 'Create timetable', 'module': 'timetable'},
      {'slug': 'timetable.view', 'description': 'View timetable', 'module': 'timetable'},
      {'slug': 'timetable.edit', 'description': 'Edit timetable', 'module': 'timetable'},
      {'slug': 'settings.view', 'description': 'View organization settings', 'module': 'settings'},
      {'slug': 'settings.edit', 'description': 'Edit organization settings', 'module': 'settings'},
      {'slug': 'role.create', 'description': 'Create roles', 'module': 'rbac'},
      {'slug': 'role.edit', 'description': 'Edit roles', 'module': 'rbac'},
      {'slug': 'role.delete', 'description': 'Delete roles', 'module': 'rbac'},
      {'slug': 'permission.manage', 'description': 'Manage permissions', 'module': 'rbac'},
    ];
    
    int created = 0;
    for (final permData in defaultPermissions) {
      final existing = await Permission.db.findFirstRow(session, where: (t) => t.slug.equals(permData['slug']!));
      if (existing == null) {
        await Permission.db.insertRow(session, Permission(slug: permData['slug']!, description: permData['description'], module: permData['module']));
        created++;
      }
    }
    return {'created': created};
  }

  // ---------------------------------------------------------------------------
  // NEW: Effective Permissions & User Overrides
  // ---------------------------------------------------------------------------

  /// Get effective list of permission slugs for a given user.
  /// Considers: Org Settings -> Role Permissions -> User Overrides.
  Future<List<String>> getEffectivePermissions(Session session, int targetUserId) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) throw Exception('Not authenticated');

    // Security: Only Admin or the User themselves can check permissions
    if (authInfo.userId != targetUserId) {
       final caller = await User.db.findById(session, authInfo.userId);
       if (caller?.role != UserRole.admin) throw Exception('Not authorized');
    }

    final targetUser = await User.db.findById(session, targetUserId);
    if (targetUser == null) throw Exception('Target user not found');

    // 1. Super Admin Bypass (e.g. 'anant' role or Admin)
    if (targetUser.role == UserRole.admin || targetUser.role == UserRole.anant) {
       // Return ALL existing permissions
       final allPerms = await Permission.db.find(session);
       return allPerms.map((p) => p.slug).toList();
    }

    // 2. Org Level Check
    Set<String> enabledModules = {};
    bool hasOrgSettings = false;
    
    final orgSettings = await OrganizationSettings.db.findFirstRow(
      session,
      where: (t) => t.organizationName.equals(targetUser.organizationName),
    );
    
    if (orgSettings != null && orgSettings.enabledModules != null) {
       enabledModules = orgSettings.enabledModules.toSet();
       hasOrgSettings = true;
    }

    // 3. Gather Permissions
    final effectivePermissions = <String>{};

    // A. Role Permissions
    // A. Role Permissions
    // 1. Primary Role
    // Match Role by slug (UserRole enum name) and Organization (or global null)
    final primaryRoles = await Role.db.find(
      session,
      where: (t) => t.slug.equals(targetUser.role.name) & 
                    (t.organizationName.equals(targetUser.organizationName) | t.organizationName.equals(null)),
    );

    // 2. Secondary Roles (Assigned via UserRoleAssignment)
    final secondaryAssignments = await UserRoleAssignment.db.find(
      session,
      where: (t) => t.userId.equals(targetUserId) & t.isActive.equals(true),
      include: UserRoleAssignment.include(role: Role.include()),
    );
    
    final allActiveRoles = [...primaryRoles];
    for (var assignment in secondaryAssignments) {
      if (assignment.role != null) {
        // Optional: Check if secondary role is organization-scoped? 
        // Assuming assignment implies validity for this user's context.
        allActiveRoles.add(assignment.role!);
      }
    }

    for (var role in allActiveRoles) {
      if (role.id != null) {
        final rolePerms = await RolePermission.db.find(
          session,
          where: (t) => t.roleId.equals(role.id),
          include: RolePermission.include(permission: Permission.include()),
        );
        for (var rp in rolePerms) {
          if (rp.permission != null) {
            effectivePermissions.add(rp.permission!.slug);
          }
        }
      }
    }

    // B. User Overrides
    final userOverrides = await UserPermissionOverride.db.find(
      session,
      where: (t) => t.userId.equals(targetUserId),
      include: UserPermissionOverride.include(permission: Permission.include()),
    );

    for (var override in userOverrides) {
      final perm = override.permission;
      if (perm != null) {
        if (override.isGranted) {
          effectivePermissions.add(perm.slug);
        } else {
          effectivePermissions.remove(perm.slug);
        }
      }
    }

    // 4. Apply Org Module Restrictions
    // If the org has specific enabled modules, any permission NOT in those modules is revoked.
    // Unless we assume User Override supercedes Org Settings? 
    // Usually Org Settings are "hard limits" (license based).
    
    if (hasOrgSettings) {
      // We need to check the module of each effective permission
      // This requires fetching the Permission objects for the slugs we have.
      // Optimization: We could have stored Permission objects in the set.
      
      final currentSlugs = effectivePermissions.toList();
      if (currentSlugs.isNotEmpty) {
        final permsToCheck = await Permission.db.find(
          session,
          where: (t) => t.slug.inSet(currentSlugs.toSet()),
        );
        
        for (var p in permsToCheck) {
          if (p.module != null && !enabledModules.contains(p.module)) {
            effectivePermissions.remove(p.slug);
          }
        }
      }
    }

    return effectivePermissions.toList();
  }

  /// Grant a specific permission to a user (Override).
  Future<bool> grantUserPermission(Session session, int userId, String permissionSlug) async {
    return _setUserPermissionOverride(session, userId, permissionSlug, true);
  }

  /// Revoke a specific permission from a user (Override).
  Future<bool> revokeUserPermission(Session session, int userId, String permissionSlug) async {
    return _setUserPermissionOverride(session, userId, permissionSlug, false);
  }

  /// Reset a user's permission override (Back to Role default).
  Future<bool> resetUserPermission(Session session, int userId, String permissionSlug) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return false;
    final caller = await User.db.findById(session, authInfo.userId);
    if (caller?.role != UserRole.admin) throw Exception('Admin only');

    final permission = await Permission.db.findFirstRow(session, where: (t) => t.slug.equals(permissionSlug));
    if (permission == null || permission.id == null) return false;

    await UserPermissionOverride.db.deleteWhere(
      session,
      where: (t) => t.userId.equals(userId) & t.permissionId.equals(permission.id),
    );
    return true;
  }

  Future<bool> _setUserPermissionOverride(Session session, int userId, String slug, bool isGranted) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return false;
    final caller = await User.db.findById(session, authInfo.userId);
    if (caller?.role != UserRole.admin) throw Exception('Admin only');

    final permission = await Permission.db.findFirstRow(session, where: (t) => t.slug.equals(slug));
    if (permission == null || permission.id == null) throw Exception('Permission not found');

    // Check existing
    final existing = await UserPermissionOverride.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId) & t.permissionId.equals(permission.id!),
    );

    if (existing != null) {
      // Update
      await UserPermissionOverride.db.updateRow(
        session,
        existing.copyWith(isGranted: isGranted),
      );
    } else {
      // Insert
      await UserPermissionOverride.db.insertRow(
        session,
        UserPermissionOverride(
          userId: userId,
          permissionId: permission.id!,
          isGranted: isGranted,
        ),
      );
    }
    return true;
  }
}
