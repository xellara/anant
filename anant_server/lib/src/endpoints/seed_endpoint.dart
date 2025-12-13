import 'package:serverpod/serverpod.dart';
import 'package:anant_server/src/generated/protocol.dart';
import 'package:anant_server/src/repositories/auth_service.dart';
import 'package:anant_server/src/repositories/auth_repository_impl.dart';
import 'dart:math';

class SeedEndpoint extends Endpoint {
  
  Future<Map<String, dynamic>> seedDatabase(Session session) async {
    try {
      print('🌱 Starting database seed...');
      
      // 1. Clear existing data
      await _clearDatabase(session);
      
      // 2. Create Organization
      final org = await _createOrganization(session);
      
      // 3. Create Users
      final authService = AuthService(AuthRepositoryImpl());
      final users = await _createUsers(session, authService, org.organizationName);
      
      // 4. Create Classes and Sections
      await _createClassesAndSections(session, org.id!, org.organizationName);
      
      // 5. Create Courses
      await _createCourses(session, org.id!);
      
      // 6. Create Organization Settings
      await _createOrganizationSettings(session, org.organizationName);

      // 7. Create Roles and Permissions
      await _createRolesAndPermissions(session, org.organizationName);

      // 8. Create Attendance and Fees
      await _createAttendanceAndFees(session, users['student'] ?? [], org.organizationName);
      
      print('✅ Seeding completed!');
      
      return {
        "success": true,
        "message": "Database seeded successfully",
        "organization": org.organizationName,
        "users": users.map((k, v) => MapEntry(k, v.length)),
      };
    } catch (e, st) {
      print('❌ Error seeding database: $e\n$st');
      return {
        "success": false,
        "error": e.toString(),
      };
    }
  }

  Future<void> _clearDatabase(Session session) async {
    print('Cleaning up tables...');
    try {
      await Attendance.db.deleteWhere(session, where: (_) => Constant.bool(true));
      await MonthlyFeeTransaction.db.deleteWhere(session, where: (_) => Constant.bool(true));
      await UserCredentials.db.deleteWhere(session, where: (_) => Constant.bool(true));
      await User.db.deleteWhere(session, where: (_) => Constant.bool(true));
      
      // Clear auth tables via SQL
      await session.db.unsafeQuery("DELETE FROM serverpod_user_info");
      
      await OrganizationSettings.db.deleteWhere(session, where: (_) => Constant.bool(true));
      await Section.db.deleteWhere(session, where: (_) => Constant.bool(true));
      await Classes.db.deleteWhere(session, where: (_) => Constant.bool(true));
      await Course.db.deleteWhere(session, where: (_) => Constant.bool(true));
      await Organization.db.deleteWhere(session, where: (_) => Constant.bool(true));
      await RolePermission.db.deleteWhere(session, where: (_) => Constant.bool(true));
      await Permission.db.deleteWhere(session, where: (_) => Constant.bool(true));
      await Role.db.deleteWhere(session, where: (_) => Constant.bool(true));
      await PermissionAudit.db.deleteWhere(session, where: (_) => Constant.bool(true));
    } catch (e) {
      print('Error clearing tables (might be empty or foreign key issues): $e');
    }
  }

  Future<Organization> _createOrganization(Session session) async {
    print('Creating organization...');
    final org = Organization(
      name: 'TestSchool',
      organizationName: 'TestSchool',
      type: 'School',
      address: '123 Education Street, Knowledge City',
      city: 'Knowledge City',
      state: 'Education State',
      country: 'India',
      pincode: '123456',
      contactNumber: '+91-9876543210',
      email: 'admin@testschool.edu',
      createdAt: DateTime.now(),
      isActive: true,
    );
    return (await Organization.db.insert(session, [org])).first;
  }

  Future<void> _createOrganizationSettings(Session session, String orgName) async {
    print('Creating organization settings...');
    final settings = OrganizationSettings(
      organizationName: orgName,
      enabledModules: ['Attendance', 'Fees', 'Academics', 'Transport', 'Library', 'Hostel', 'Communication'],
    );
    await OrganizationSettings.db.insert(session, [settings]);
  }

  Future<void> _createRolesAndPermissions(Session session, String orgName) async {
    print('Creating roles and permissions...');
    
    // Create Permissions
    final permissions = [
      Permission(slug: 'attendance.view', description: 'View Attendance', module: 'Attendance'),
      Permission(slug: 'attendance.mark', description: 'Mark Attendance', module: 'Attendance'),
      Permission(slug: 'fees.view', description: 'View Fees', module: 'Fees'),
      Permission(slug: 'fees.collect', description: 'Collect Fees', module: 'Fees'),
      Permission(slug: 'users.manage', description: 'Manage Users', module: 'Admin'),
    ];
    
    for (var p in permissions) {
       await Permission.db.insert(session, [p]);
    }

    // Create Roles
    for (var roleEnum in UserRole.values) {
      final role = Role(
        name: roleEnum.name[0].toUpperCase() + roleEnum.name.substring(1),
        slug: roleEnum.name,
        description: 'System role for ${roleEnum.name}',
        organizationName: orgName,
        isSystemRole: true,
      );
      await Role.db.insert(session, [role]);
    }
  }

  Future<Map<String, List<User>>> _createUsers(Session session, AuthService authService, String orgName) async {
    print('Creating users...');
    final Map<String, List<User>> createdUsers = {};
    
    // Helper to create users
    Future<void> create(UserRole role, int count, String prefix) async {
      createdUsers[role.name] = [];
      for (var i = 1; i <= count; i++) {
        final numStr = i.toString().padLeft(3, '0');
        final username = '$prefix$numStr';
        final password = '${prefix[0].toUpperCase()}${prefix.substring(1)}@123'; // e.g., Admin@123
        
        // For students, assign class and section
        String? className;
        String? sectionName;
        String? admissionNumber;
        String? anantId;

        if (role == UserRole.student) {
          className = 'Class ${(i % 12) + 1}';
          sectionName = ['A', 'B', 'C'][i % 3];
          admissionNumber = 'ADM$numStr';
          
          // Generate anantId using system format: YYSecAdm.role@org.anant
          int currentYear = DateTime.now().year;
          String lastTwoDigits = currentYear.toString().substring(currentYear.toString().length - 2);
          anantId = "$lastTwoDigits$sectionName$admissionNumber.$role@$orgName.anant";
        } else {
          anantId = '$username@$orgName.anant';
        }

        final user = User(
          uid: '', // Generated by service
          organizationName: orgName,
          anantId: anantId,
          email: '$username@testschool.edu',
          role: role,
          fullName: '$prefix User $i',
          isActive: true,
          isPasswordCreated: true,
          country: 'India',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          className: className,
          sectionName: sectionName,
          rollNumber: role == UserRole.student ? numStr : null,
          admissionNumber: admissionNumber,
        );
        
        try {
          final created = await authService.signUp(session, user, password);
          createdUsers[role.name]!.add(created);
        } catch (e) {
          print('Error creating user $username: $e');
        }
      }
    }

    await create(UserRole.admin, 2, 'admin');
    await create(UserRole.principal, 2, 'principal');
    await create(UserRole.teacher, 10, 'teacher');
    await create(UserRole.student, 35, 'student');
    await create(UserRole.accountant, 2, 'accountant');
    await create(UserRole.clerk, 2, 'clerk');
    await create(UserRole.librarian, 2, 'librarian');
    await create(UserRole.transport, 2, 'transport');
    await create(UserRole.hostel, 2, 'hostel');
    await create(UserRole.parent, 2, 'parent');
    
    return createdUsers;
  }

  Future<void> _createClassesAndSections(Session session, int orgId, String orgName) async {
    print('Creating classes and sections...');
    for (var i = 1; i <= 12; i++) {
      final className = 'Class $i';
      final cls = Classes(
        organizationId: orgId,
        name: className,
        academicYear: '2024-2025',
        isActive: true,
      );
      await Classes.db.insert(session, [cls]);
      
      for (var section in ['A', 'B', 'C']) {
        final sec = Section(
          organizationId: orgId,
          className: className,
          name: section,
          isActive: true,
        );
        await Section.db.insert(session, [sec]);
      }
    }
  }

  Future<void> _createCourses(Session session, int orgId) async {
    print('Creating courses...');
    final subjects = ['Mathematics', 'Science', 'English', 'History', 'Geography', 'Physics', 'Chemistry', 'Biology', 'Computer Science', 'Art', 'Music', 'Physical Education', 'Economics', 'Business Studies', 'Accountancy'];
    for (var subject in subjects) {
      final course = Course(
        organizationId: orgId,
        name: subject,
        code: subject.substring(0, 3).toUpperCase(),
        isActive: true,
      );
      await Course.db.insert(session, [course]);
    }
  }

  Future<void> _createAttendanceAndFees(Session session, List<User> students, String orgName) async {
    print('Creating attendance and fees for ${students.length} students...');
    final random = Random();
    
    for (var student in students) {
      if (student.anantId == null) continue;

      // Attendance: Last 30 days
      for (var i = 0; i < 30; i++) {
        final date = DateTime.now().subtract(Duration(days: i));
        final isPresent = random.nextDouble() > 0.1; // 90% attendance
        
        // Skip Sundays
        if (date.weekday == 7) continue;
        
        final attendance = Attendance(
          organizationName: orgName,
          className: student.className ?? '',
          sectionName: student.sectionName ?? '',
          studentAnantId: student.anantId!,
          startTime: '08:00',
          endTime: '14:00',
          date: date.toIso8601String().split('T')[0],
          markedByAnantId: 'teacher001@$orgName.anant',
          status: isPresent ? 'Present' : 'Absent',
          isSubmitted: true,
        );
        await Attendance.db.insert(session, [attendance]);
      }
      
      // Fees: 8 months
      for (var i = 0; i < 8; i++) {
        final month = ['April', 'May', 'June', 'July', 'August', 'September', 'October', 'November'][i];
        final fee = MonthlyFeeTransaction(
          anantId: student.anantId!,
          organizationName: orgName,
          month: month,
          feeAmount: 5000.0 + random.nextInt(45) * 100,
          discount: 0,
          fine: 0,
          transactionDate: DateTime.now().subtract(Duration(days: 30 * (8 - i))),
          transactionGateway: 'Cash',
          transactionRef: 'REF-${random.nextInt(100000)}',
          transactionId: 'TXN-${random.nextInt(100000)}',
          transactionStatus: 'Success',
          transactionType: 'Cash',
          markedByAnantId: 'accountant001@$orgName.anant',
        );
        await MonthlyFeeTransaction.db.insert(session, [fee]);
      }
    }
  }
}
