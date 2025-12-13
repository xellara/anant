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
    
    // First remove all role-permission associations
    await RolePermission.db.deleteWhere(
      session,
      where: (t) => t.permission.id.equals(permissionId),
    );
    
    await Permission.db.deleteRow(session, permission);
    return true;
  }
  
  /// Initialize default permissions for the system.
  Future<Map<String, dynamic>> initializeDefaultPermissions(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }
    
    final userId = authInfo.userId;
    final user = await User.db.findById(session, userId);
    if (user == null) throw Exception('User not found');
    
    // Only admin can initialize permissions
    if (user.role != UserRole.admin) {
      throw Exception('Not authorized - Admin only');
    }
    
    final defaultPermissions = <Map<String, String>>[
      // User Management
      {'slug': 'user.create', 'description': 'Create new users', 'module': 'user_management'},
      {'slug': 'user.read', 'description': 'View user details', 'module': 'user_management'},
      {'slug': 'user.update', 'description': 'Update user information', 'module': 'user_management'},
      {'slug': 'user.delete', 'description': 'Delete users', 'module': 'user_management'},
      
      // Attendance
      {'slug': 'attendance.mark', 'description': 'Mark attendance', 'module': 'attendance'},
      {'slug': 'attendance.view', 'description': 'View attendance records', 'module': 'attendance'},
      {'slug': 'attendance.edit', 'description': 'Edit attendance records', 'module': 'attendance'},
      
      // Exam & Grades
      {'slug': 'exam.create', 'description': 'Create exams', 'module': 'exam'},
      {'slug': 'exam.view', 'description': 'View exam details', 'module': 'exam'},
      {'slug': 'exam.grade', 'description': 'Grade exams', 'module': 'exam'},
      
      // Fees
      {'slug': 'fees.view', 'description': 'View fee records', 'module': 'fees'},
      {'slug': 'fees.create', 'description': 'Create fee records', 'module': 'fees'},
      {'slug': 'fees.collect', 'description': 'Collect fee payments', 'module': 'fees'},
      
      // Timetable
      {'slug': 'timetable.create', 'description': 'Create timetable', 'module': 'timetable'},
      {'slug': 'timetable.view', 'description': 'View timetable', 'module': 'timetable'},
      {'slug': 'timetable.edit', 'description': 'Edit timetable', 'module': 'timetable'},
      
      // Settings
      {'slug': 'settings.view', 'description': 'View organization settings', 'module': 'settings'},
      {'slug': 'settings.edit', 'description': 'Edit organization settings', 'module': 'settings'},
      
      // Roles & Permissions
      {'slug': 'role.create', 'description': 'Create roles', 'module': 'rbac'},
      {'slug': 'role.edit', 'description': 'Edit roles', 'module': 'rbac'},
      {'slug': 'role.delete', 'description': 'Delete roles', 'module': 'rbac'},
      {'slug': 'permission.manage', 'description': 'Manage permissions', 'module': 'rbac'},
    ];
    
    int created = 0;
    int skipped = 0;
    
    for (final permData in defaultPermissions) {
      final slug = permData['slug']!;
      final description = permData['description'];
      final module = permData['module'];
      
      final existing = await Permission.db.findFirstRow(
        session,
        where: (t) => t.slug.equals(slug),
      );
      
      if (existing == null) {
        await Permission.db.insertRow(
          session,
          Permission(
            slug: slug,
            description: description,
            module: module,
          ),
        );
        created++;
      } else {
        skipped++;
      }
    }
    
    return {
      'created': created,
      'skipped': skipped,
      'total': defaultPermissions.length,
    };
  }
}
