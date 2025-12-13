import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Endpoint for managing roles and permissions (RBAC).
class RoleEndpoint extends Endpoint {
  
  /// Create a new role.
  Future<Role?> createRole(
    Session session,
    String name,
    String slug,
    String? description,
    String? organizationName,
    bool isSystemRole,
  ) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }
    
    final userId = authInfo.userId;
    final user = await User.db.findById(session, userId);
    if (user == null) throw Exception('User not found');
    
    // Only admin or principal can create roles
    if (user.role != UserRole.admin && user.role != UserRole.principal) {
      throw Exception('Not authorized');
    }
    
    // Check if role already exists
    final existing = await Role.db.findFirstRow(
      session,
      where: (t) => t.slug.equals(slug) & 
                    (organizationName != null 
                      ? t.organizationName.equals(organizationName)
                      : t.organizationName.equals(null)),
    );
    
    if (existing != null) {
      throw Exception('Role with this slug already exists');
    }
    
    final role = Role(
      name: name,
      slug: slug,
      description: description,
      organizationName: organizationName,
      isSystemRole: isSystemRole,
    );
    
    return await Role.db.insertRow(session, role);
  }
  
  /// Get all roles for an organization.
  Future<List<Role>> getRoles(Session session, {String? organizationName}) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }
    
    if (organizationName != null) {
      return await Role.db.find(
        session,
        where: (t) => t.organizationName.equals(organizationName) | 
                     t.isSystemRole.equals(true),
        orderBy: (t) => t.name,
      );
    } else {
      // Return system roles only
      return await Role.db.find(
        session,
        where: (t) => t.isSystemRole.equals(true),
        orderBy: (t) => t.name,
      );
    }
  }
  
  /// Update a role.
  Future<Role?> updateRole(
    Session session,
    int roleId,
    String? name,
    String? description,
  ) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }
    
    final userId = authInfo.userId;
    final user = await User.db.findById(session, userId);
    if (user == null) throw Exception('User not found');
    
    // Only admin or principal can update roles
    if (user.role != UserRole.admin && user.role != UserRole.principal) {
      throw Exception('Not authorized');
    }
    
    var role = await Role.db.findById(session, roleId);
    if (role == null) throw Exception('Role not found');
    
    // Cannot modify system roles
    if (role.isSystemRole) {
      throw Exception('Cannot modify system roles');
    }
    
    role = role.copyWith(
      name: name ?? role.name,
      description: description ?? role.description,
    );
    
    return await Role.db.updateRow(session, role);
  }
  
  /// Delete a role.
  Future<bool> deleteRole(Session session, int roleId) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }
    
    final userId = authInfo.userId;
    final user = await User.db.findById(session, userId);
    if (user == null) throw Exception('User not found');
    
    // Only admin can delete roles
    if (user.role != UserRole.admin) {
      throw Exception('Not authorized');
    }
    
    final role = await Role.db.findById(session, roleId);
    if (role == null) return false;
    
    // Cannot delete system roles
    if (role.isSystemRole) {
      throw Exception('Cannot delete system roles');
    }
    
    await Role.db.deleteRow(session, role);
    return true;
  }
  
  /// Assign a permission to a role.
  Future<RolePermission?> assignPermission(
    Session session,
    int roleId,
    int permissionId,
  ) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }
    
    final userId = authInfo.userId;
    final user = await User.db.findById(session, userId);
    if (user == null) throw Exception('User not found');
    
    // Only admin or principal can assign permissions
    if (user.role != UserRole.admin && user.role != UserRole.principal) {
      throw Exception('Not authorized');
    }
    
    // Check if assignment already exists
    final existing = await RolePermission.db.findFirstRow(
      session,
      where: (t) => t.role.id.equals(roleId) & 
                   t.permission.id.equals(permissionId),
    );
    
    if (existing != null) {
      return existing;
    }
    
    final role = await Role.db.findById(session, roleId);
    final permission = await Permission.db.findById(session, permissionId);
    
    if (role == null || permission == null) {
      throw Exception('Role or Permission not found');
    }
    
    final rolePermission = RolePermission(
      roleId: roleId,
      role: role,
      permissionId: permissionId,
      permission: permission,
    );
    
    return await RolePermission.db.insertRow(session, rolePermission);
  }
  
  /// Remove a permission from a role.
  Future<bool> removePermission(
    Session session,
    int roleId,
    int permissionId,
  ) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }
    
    final userId = authInfo.userId;
    final user = await User.db.findById(session, userId);
    if (user == null) throw Exception('User not found');
    
    // Only admin or principal can remove permissions
    if (user.role != UserRole.admin && user.role != UserRole.principal) {
      throw Exception('Not authorized');
    }
    
    await RolePermission.db.deleteWhere(
      session,
      where: (t) => t.role.id.equals(roleId) & 
                   t.permission.id.equals(permissionId),
    );
    
    return true;
  }
  
  /// Get all permissions for a role.
  Future<List<Permission>> getPermissionsForRole(
    Session session,
    int roleId,
  ) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }
    
    final rolePermissions = await RolePermission.db.find(
      session,
      where: (t) => t.role.id.equals(roleId),
      include: RolePermission.include(permission: Permission.include()),
    );
    
    return rolePermissions
        .map((rp) => rp.permission!)
        .toList();
  }
}
