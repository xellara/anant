# Role-Based Access Control (RBAC) System Design

## Overview
This document describes the RBAC implementation for the Anant School Management System, which provides a flexible and future-proof authorization system.

## Database Schema

### Tables

#### 1. `permission` Table
Stores all available permissions in the system.

| Column | Type | Description |
|--------|------|-------------|
| id | int | Primary key |
| slug | String | Unique permission identifier (e.g., "user.create") |
| description | String? | Human-readable description |
| module | String? | Module grouping (e.g., "attendance", "fees") |

**Indexes:**
- `permission_slug_idx` (UNIQUE) on `slug`

#### 2. `role` Table
Stores custom and system roles.

| Column | Type | Description |
|--------|------|-------------|
| id | int | Primary key |
| name | String | Display name (e.g., "Teacher") |
| slug | String | Unique role identifier (e.g., "teacher") |
| description | String? | Human-readable description |
| organizationName | String? | NULL for system roles, organization-specific otherwise |
| isSystemRole | bool | True for built-in system roles |

**Indexes:**
- `role_slug_org_idx` (UNIQUE) on `slug, organizationName`

#### 3. `role_permission` Table
Maps permissions to roles (many-to-many relationship).

| Column | Type | Description |
|--------|------|-------------|
| id | int | Primary key |
| role | Role | Relation to role table |
| permission | Permission | Relation to permission table |

**Indexes:**
- `role_perm_idx` (UNIQUE) on `roleId, permissionId`

#### 4. `user` Table (Existing)
Enhanced with dual role support for backward compatibility and future flexibility.

| Column | Type | Description |
|--------|------|-------------|
| role | UserRole (enum) | Legacy role enum (admin, teacher, student, etc.) |

**Note:** The `user` table currently uses the `UserRole` enum for backward compatibility. Future enhancement can add a `userRoleId` field to link to the `role` table for custom roles.

## Permission Naming Convention

Permissions follow the pattern: `<module>.<action>`

### Examples:
- `user.create` - Create new users
- `user.read` - View user details
- `user.update` - Modify user information
- `user.delete` - Delete users
- `attendance.mark` - Mark attendance
- `attendance.view` - View attendance records
- `exam.create` - Create exams
- `fees.collect` - Collect fee payments
- `settings.edit` - Modify organization settings

## Default Permissions by Module

### User Management
- `user.create`
- `user.read`
- `user.update`
- `user.delete`

### Attendance
- `attendance.mark`
- `attendance.view`
- `attendance.edit`

### Exam & Grades
- `exam.create`
- `exam.view`
- `exam.grade`

### Fees
- `fees.view`
- `fees.create`
- `fees.collect`

### Timetable
- `timetable.create`
- `timetable.view`
- `timetable.edit`

### Settings
- `settings.view`
- `settings.edit`

### RBAC
- `role.create`
- `role.edit`
- `role.delete`
- `permission.manage`

## System Roles vs Custom Roles

### System Roles
- **isSystemRole = true**
- Cannot be modified or deleted
- Available to all organizations
- Used for basic role types (admin, teacher, student, etc.)
- Currently mapped 1:1 with UserRole enum for backward compatibility

### Custom Roles
- **isSystemRole = false**
- Organization-specific
- Can be created, modified, and deleted by admins
- Inherit from system roles and can have custom permissions
- Example: "Department Head", "Sports Teacher", "Lab Assistant"

## Migration Strategy

### Phase 1: Dual System (Current)
- Existing `UserRole` enum remains active
- New RBAC tables created alongside
- Both systems work in parallel
- Permissions can be checked using either system

### Phase 2: Gradual Migration (Future)
- Add `userRoleId` field to `user` table
- Populate default role mappings (admin → Admin Role, teacher → Teacher Role)
- Update endpoints to check both systems
- Migrate organization-specific customizations to custom roles

### Phase 3: Full Migration (Future)
- Deprecate `UserRole` enum
- All authorization checks use RBAC system
- Remove legacy role field (optional)

## API Endpoints

### RoleEndpoint
- `createRole(name, slug, description, organizationName, isSystemRole)` - Create a new role
- `getRoles(organizationName?)` - Get all roles for an organization
- `updateRole(roleId, name?, description?)` - Update role details
- `deleteRole(roleId)` - Delete a custom role
- `assignPermission(roleId, permissionId)` - Assign permission to role
- `removePermission(roleId, permissionId)` - Remove permission from role
- `getPermissionsForRole(roleId)` - Get all permissions for a role

### PermissionEndpoint
- `createPermission(slug, description, module)` - Create a new permission
- `getAllPermissions()` - Get all permissions
- `getPermissionsByModule(module)` - Get permissions for a specific module
- `updatePermission(permissionId, description?, module?)` - Update permission
- `deletePermission(permissionId)` - Delete permission
- `initializeDefaultPermissions()` - Set up default permissions (one-time setup)

## Usage Examples

### Initialize System
```dart
// 1. Initialize default permissions (run once)
await client.permission.initializeDefaultPermissions();

// 2. Create system roles with appropriate permissions
final teacherRole = await client.role.createRole(
  'Teacher',
  'teacher',
  'School Teacher',
  null, // System role
  true,
);

// 3. Assign permissions to roles
await client.role.assignPermission(teacherRole.id, attendanceMarkPermId);
await client.role.assignPermission(teacherRole.id, attendanceViewPermId);
```

### Check Permissions (Current Implementation)
```dart
// Using legacy enum system
if (user.role == UserRole.admin || user.role == UserRole.principal) {
  // Allow action
}

// Future: Using RBAC system
final permissions = await client.role.getPermissionsForRole(user.userRoleId);
if (permissions.any((p) => p.slug == 'user.create')) {
  // Allow action
}
```

### Create Custom Role
```dart
// Organization creates a custom role
final customRole = await client.role.createRole(
  'Department Head',
  'dept_head',
  'Head of Department with additional permissions',
  'school123', // Organization-specific
  false, // Not a system role
);

// Assign specific permissions
await client.role.assignPermission(customRole.id, userReadPermId);
await client.role.assignPermission(customRole.id, attendanceViewPermId);
await client.role.assignPermission(customRole.id, examViewPermId);
```

## Future Enhancements

### 1. User-Role Assignment Table
```yaml
class: UserRole
table: user_role
fields:
  user: User?, relation
  role: Role?, relation
  assignedAt: DateTime
  assignedBy: int? # userId of admin who assigned
```
This allows users to have multiple roles.

### 2. Permission Inheritance
Add a `parentRoleId` field to roles for hierarchical permission inheritance:
```yaml
fields:
  parentRole: Role?, relation
```

### 3. Conditional Permissions
Add context-based permissions:
```yaml
class: ConditionalPermission
fields:
  permission: Permission?, relation
  role: Role?, relation
  conditions: Map<String, dynamic>? # e.g., {"classId": "5A", "subjectId": "Math"}
```

### 4. Permission Audit Log
Track permission usage:
```yaml
class: PermissionAudit
fields:
  user: User?, relation
  permission: Permission?, relation
  action: String
  resourceId: String?
  timestamp: DateTime
  success: bool
```

### 5. Time-Based Permissions
Add temporary permissions:
```yaml
fields:
  validFrom: DateTime?
  validUntil: DateTime?
```

## Security Considerations

1. **Admin-Only Operations**: Only users with `UserRole.admin` can:
   - Create/modify/delete permissions
   - Create/modify/delete system roles
   - Initialize default permissions

2. **Organization Isolation**: Custom roles are organization-specific and cannot be accessed across organizations.

3. **System Role Protection**: System roles cannot be modified or deleted to maintain system integrity.

4. **Permission Validation**: Always validate permissions server-side, never rely on client-side checks alone.

5. **Audit Trail**: Consider implementing audit logs for all permission-related operations.

## Best Practices

1. **Permission Granularity**: Define permissions at the action level, not feature level.
2. **Least Privilege**: Assign minimal permissions required for each role.
3. **Regular Review**: Periodically review and audit role-permission assignments.
4. **Documentation**: Document each custom role's purpose and permissions.
5. **Testing**: Always test permission changes in a staging environment first.

## DB Migration Commands

When ready to deploy, create the tables using:
```bash
serverpod create-migration
serverpod generate
```

Then initialize the system:
1. Run the server
2. Authenticate as admin
3. Call `initializeDefaultPermissions()`
4. Create and configure system roles
5. Assign permissions to roles
