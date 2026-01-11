import 'dart:io';
import 'package:anant_server/src/repositories/auth_service.dart';
import 'package:serverpod/serverpod.dart';
import 'package:anant_server/src/generated/protocol.dart';
import 'package:anant_server/src/generated/endpoints.dart';
import 'package:anant_server/src/repositories/auth_repository_impl.dart';

/// Seeds only ESSENTIAL data required for the application to function properly
/// This includes: Organization, Settings, Roles, Permissions, Fee Structure
/// Does NOT include: Dummy users, attendance, exam data, etc.
void main(List<String> args) async {
  final serverpod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  final session = await serverpod.createSession(enableLogging: true);
  final authService = AuthService(AuthRepositoryImpl());

  try {
    print('🌱 Starting Essential Data Seeding...');
    print('This will seed ONLY required data: Organization, Settings, Roles, Permissions, Fee Structure\n');

    // --- 1. CREATE ORGANIZATION ---
    print('🏢 Creating Organization...');
    final org = Organization(
      name: 'Anant School',
      organizationName: 'AnantSchool',
      code: 'ANANT',
      type: 'School',
      address: '123 Education Lane',
      city: 'Tech City',
      state: 'Innovation State',
      country: 'India',
      createdAt: DateTime.now(),
      isActive: true,
      // Fee structure - 12 months
      monthlyFees: {
        'April': 5000.0,
        'May': 5000.0,
        'June': 5000.0,
        'July': 5000.0,
        'August': 5000.0,
        'September': 5000.0,
        'October': 5000.0,
        'November': 5000.0,
        'December': 5000.0,
        'January': 5000.0,
        'February': 5000.0,
        'March': 5000.0,
      },
      feeStartAndEndMonth: {
        'start': 'April',
        'end': 'March',
      },
      admissionFee: 10000.0,
    );
    final createdOrg = await Organization.db.insertRow(session, org);
    final orgId = createdOrg.id!;
    final orgName = createdOrg.organizationName;
    print('✅ Organization created: ${createdOrg.name} (ID: $orgId)');

    // --- 2. CREATE ORGANIZATION SETTINGS ---
    print('⚙️  Creating Organization Settings...');
    final settings = OrganizationSettings(
      organizationName: orgName,
      enabledModules: [
        'Attendance',
        'Fees',
        'Academics',
        'Exams',
        'Timetable',
        'Transport',
        'Library',
        'Hostel',
        'Communication',
        'Announcements',
        'Notifications',
      ],
    );
    await OrganizationSettings.db.insertRow(session, settings);
    print('✅ Organization Settings created with ${(settings.enabledModules as List).length} enabled modules.');

    // --- 3. CREATE PERMISSIONS ---
    print('🔐 Creating Permissions...');
    final permissionSlugs = [
      {'slug': 'attendance.view', 'description': 'View Attendance Records', 'module': 'Attendance'},
      {'slug': 'attendance.mark', 'description': 'Mark Attendance', 'module': 'Attendance'},
      {'slug': 'attendance.edit', 'description': 'Edit Attendance Records', 'module': 'Attendance'},
      {'slug': 'fees.view', 'description': 'View Fee Records', 'module': 'Fees'},
      {'slug': 'fees.collect', 'description': 'Collect Fees', 'module': 'Fees'},
      {'slug': 'fees.edit', 'description': 'Edit Fee Records', 'module': 'Fees'},
      {'slug': 'users.view', 'description': 'View Users', 'module': 'Admin'},
      {'slug': 'users.create', 'description': 'Create Users', 'module': 'Admin'},
      {'slug': 'users.edit', 'description': 'Edit Users', 'module': 'Admin'},
      {'slug': 'users.delete', 'description': 'Delete Users', 'module': 'Admin'},
      {'slug': 'exams.view', 'description': 'View Exams', 'module': 'Academics'},
      {'slug': 'exams.create', 'description': 'Create Exams', 'module': 'Academics'},
      {'slug': 'exams.edit', 'description': 'Edit Exams', 'module': 'Academics'},
      {'slug': 'exams.delete', 'description': 'Delete Exams', 'module': 'Academics'},
      {'slug': 'announcements.view', 'description': 'View Announcements', 'module': 'Communication'},
      {'slug': 'announcements.create', 'description': 'Create Announcements', 'module': 'Communication'},
      {'slug': 'announcements.edit', 'description': 'Edit Announcements', 'module': 'Communication'},
      {'slug': 'announcements.delete', 'description': 'Delete Announcements', 'module': 'Communication'},
      {'slug': 'timetable.view', 'description': 'View Timetable', 'module': 'Timetable'},
      {'slug': 'timetable.create', 'description': 'Create Timetable', 'module': 'Timetable'},
      {'slug': 'timetable.edit', 'description': 'Edit Timetable', 'module': 'Timetable'},
      {'slug': 'classes.view', 'description': 'View Classes', 'module': 'Admin'},
      {'slug': 'classes.create', 'description': 'Create Classes', 'module': 'Admin'},
      {'slug': 'classes.edit', 'description': 'Edit Classes', 'module': 'Admin'},
      {'slug': 'reports.view', 'description': 'View Reports', 'module': 'Reports'},
      {'slug': 'reports.generate', 'description': 'Generate Reports', 'module': 'Reports'},
    ];
    
    final createdPermissions = <Permission>[];
    for (var permData in permissionSlugs) {
      final permission = Permission(
        slug: permData['slug'] as String,
        description: permData['description'] as String,
        module: permData['module'] as String,
      );
      createdPermissions.add(await Permission.db.insertRow(session, permission));
    }
    print('✅ ${createdPermissions.length} Permissions created.');

    // --- 4. CREATE ROLES ---
    print('👑 Creating Roles for all user types...');
    final createdRoles = <Role>[];
    for (var roleEnum in UserRole.values) {
      final role = Role(
        name: roleEnum.name[0].toUpperCase() + roleEnum.name.substring(1),
        slug: roleEnum.name,
        description: 'System role for ${roleEnum.name}',
        organizationName: orgName,
        isSystemRole: true,
      );
      createdRoles.add(await Role.db.insertRow(session, role));
    }
    print('✅ ${createdRoles.length} Roles created.');

    // --- 5. CREATE ROLE-PERMISSION MAPPINGS ---
    print('🔗 Mapping Permissions to Roles...');
    int rolePermissionCount = 0;
    
    for (var role in createdRoles) {
      // Anant (Super Admin) - All permissions
      if (role.slug == 'anant') {
        for (var permission in createdPermissions) {
          await RolePermission.db.insertRow(session, RolePermission(
            roleId: role.id!,
            permissionId: permission.id!,
          ));
          rolePermissionCount++;
        }
      }
      // Admin - All permissions except some restricted ones
      else if (role.slug == 'admin') {
        for (var permission in createdPermissions) {
          await RolePermission.db.insertRow(session, RolePermission(
            roleId: role.id!,
            permissionId: permission.id!,
          ));
          rolePermissionCount++;
        }
      }
      // Principal - View all, edit most
      else if (role.slug == 'principal') {
        for (var permission in createdPermissions) {
          if (!permission.slug.endsWith('.delete')) {
            await RolePermission.db.insertRow(session, RolePermission(
              roleId: role.id!,
              permissionId: permission.id!,
            ));
            rolePermissionCount++;
          }
        }
      }
      // Teacher - Attendance, exams, timetable, announcements
      else if (role.slug == 'teacher') {
        for (var permission in createdPermissions) {
          if (permission.slug.startsWith('attendance.') ||
              permission.slug.startsWith('exams.') ||
              permission.slug.startsWith('timetable.view') ||
              permission.slug.startsWith('announcements.view') ||
              permission.slug.startsWith('classes.view')) {
            await RolePermission.db.insertRow(session, RolePermission(
              roleId: role.id!,
              permissionId: permission.id!,
            ));
            rolePermissionCount++;
          }
        }
      }
      // Accountant - Fee management
      else if (role.slug == 'accountant') {
        for (var permission in createdPermissions) {
          if (permission.slug.startsWith('fees.') ||
              permission.slug.startsWith('users.view') ||
              permission.slug.startsWith('reports.')) {
            await RolePermission.db.insertRow(session, RolePermission(
              roleId: role.id!,
              permissionId: permission.id!,
            ));
            rolePermissionCount++;
          }
        }
      }
      // Clerk - View and basic edit
      else if (role.slug == 'clerk') {
        for (var permission in createdPermissions) {
          if (permission.slug.contains('.view') ||
              permission.slug == 'users.create' ||
              permission.slug == 'users.edit') {
            await RolePermission.db.insertRow(session, RolePermission(
              roleId: role.id!,
              permissionId: permission.id!,
            ));
            rolePermissionCount++;
          }
        }
      }
      // Student - View only
      else if (role.slug == 'student') {
        for (var permission in createdPermissions) {
          if (permission.slug.contains('.view') &&
              !permission.slug.startsWith('users.') &&
              !permission.slug.startsWith('reports.')) {
            await RolePermission.db.insertRow(session, RolePermission(
              roleId: role.id!,
              permissionId: permission.id!,
            ));
            rolePermissionCount++;
          }
        }
      }
      // Parent - View student-related data
      else if (role.slug == 'parent') {
        for (var permission in createdPermissions) {
          if ((permission.slug.contains('.view') &&
              (permission.slug.startsWith('attendance.') ||
               permission.slug.startsWith('fees.') ||
               permission.slug.startsWith('exams.') ||
               permission.slug.startsWith('announcements.')))) {
            await RolePermission.db.insertRow(session, RolePermission(
              roleId: role.id!,
              permissionId: permission.id!,
            ));
            rolePermissionCount++;
          }
        }
      }
    }
    print('✅ $rolePermissionCount Role-Permission mappings created.');

    // --- 6. CREATE SUPER ADMIN USER ---
    print('👤 Creating Super Admin user...');
    final superAdminUser = User(
      uid: '',
      organizationName: orgName,
      anantId: 'superadmin@$orgName.anant',
      email: 'superadmin@anant.com',
      role: UserRole.anant,
      fullName: 'Super Administrator',
      isActive: true,
      isPasswordCreated: true,
      country: 'India',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    final createdSuperAdmin = await authService.signUp(session, superAdminUser, 'Admin@123');
    print('✅ Super Admin created:');
    print('   Anant ID: ${createdSuperAdmin.anantId}');
    print('   Password: Admin@123');

    // Assign role to super admin
    final superAdminRole = createdRoles.firstWhere((r) => r.slug == 'anant');
    await UserRoleAssignment.db.insertRow(session, UserRoleAssignment(
      userId: createdSuperAdmin.id!,
      roleId: superAdminRole.id!,
      assignedAt: DateTime.now(),
      isActive: true,
    ));

    print('\n✨ ESSENTIAL SEEDING COMPLETE! ✨');
    print('Created:');
    print(' - 1 Organization with fee structure (12 months)');
    print(' - 1 Organization Settings (${(settings.enabledModules as List).length} modules)');
    print(' - ${createdPermissions.length} Permissions');
    print(' - ${createdRoles.length} Roles');
    print(' - $rolePermissionCount Role-Permission Mappings');
    print(' - 1 Super Admin user');
    print('\n🔑 Super Admin Credentials:');
    print(' - Anant ID: superadmin@$orgName.anant');
    print(' - Password: Admin@123');
    print('\nYou can now run seed_data.dart to add dummy test data if needed.');

  } catch (e, stack) {
    print('❌ Error seeding essential data: $e');
    print(stack);
  } finally {
    await session.close();
    await serverpod.shutdown();
  }
}
