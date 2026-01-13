import 'dart:io';
import 'dart:math';
import 'package:anant_server/src/repositories/auth_service.dart';
import 'package:serverpod/serverpod.dart';
import 'package:anant_server/src/generated/protocol.dart';
import 'package:anant_server/src/generated/endpoints.dart';
import 'package:anant_server/src/repositories/auth_repository_impl.dart';
import 'package:serverpod_auth_server/module.dart' as auth;

void main(List<String> args) async {
  final serverpod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  final session = await serverpod.createSession(enableLogging: true);
  final authService = AuthService(AuthRepositoryImpl());
  final random = Random();

  try {
    print('🌱 Starting Comprehensive Seeding (Full Coverage)...');

    // --- 1. ASK FOR CONFIRMATION TO CLEAR DATABASE ---
    print('\n⚠️  WARNING: Do you want to DELETE all existing data before seeding?');
    print('If you select "no", the script will only add missing data without clearing existing data.');
    print('Clear database before seeding? (yes/no): ');
    
    // For automated runs, check if we want to skip input
    String? response;
    try {
      response = stdin.readLineSync()?.trim().toLowerCase();
    } catch (_) {
      // Handle cases where stdin is not available (e.g. piped input)
      print('Stdin error or end of input. Assuming "yes" for automated run.');
      response = 'yes';
    }
    
    bool shouldClear = (response == 'yes' || response == 'y');

    if (shouldClear) {
      print('🗑️ Clearing existing data (reverse dependency order)...');
      // Delete children first to avoid foreign key constraints
      await Notification.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await Announcement.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await PermissionAudit.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await UserPermissionOverride.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await ResourcePermission.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await UserRoleAssignment.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await RolePermission.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await StudentCourseEnrollment.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await Enrollment.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await MonthlyFeeTransaction.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await FeeRecord.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await Attendance.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await Exam.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await TimetableEntry.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await Course.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await Section.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await Subject.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await Classes.db.deleteWhere(session, where: (t) => Constant.bool(true));
      
      // Auth tables
      await UserCredentials.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await ExternalAuthProvider.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await User.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await auth.UserInfo.db.deleteWhere(session, where: (t) => Constant.bool(true));
      
      await Permission.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await Role.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await OrganizationSettings.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await Organization.db.deleteWhere(session, where: (t) => Constant.bool(true));
      
      print('✅ Database cleared.');
    } else {
      print('ℹ️  Skipping database clear. Will only create missing data...');
    }

    // --- 2. CREATE ORGANIZATION & SETTINGS ---
    print('🏢 Checking for Organization...');
    final existingOrgs = await Organization.db.find(
      session,
      where: (t) => t.organizationName.equals('AnantSchool'),
      limit: 1,
    );
    
    Organization createdOrg;
    String orgName = 'AnantSchool';
    int orgId;

    if (existingOrgs.isNotEmpty) {
      createdOrg = existingOrgs.first;
      orgId = createdOrg.id!;
      print('✅ Organization already exists: ${createdOrg.name} (ID: $orgId)');
    } else {
      print('   Creating Organization...');
      final org = Organization(
        name: 'Anant School',
        organizationName: orgName,
        code: 'ANANT',
        type: 'School',
        address: '123 Education Lane',
        city: 'Tech City',
        state: 'Innovation State',
        country: 'India',
        createdAt: DateTime.now(),
        isActive: true,
        monthlyFees: {
          'April': 5000.0, 'May': 5000.0, 'June': 5000.0, 'July': 5000.0,
          'August': 5000.0, 'September': 5000.0, 'October': 5000.0, 'November': 5000.0,
          'December': 5000.0, 'January': 5000.0, 'February': 5000.0, 'March': 5000.0,
        },
        feeStartAndEndMonth: {'start': 'April', 'end': 'March'},
        admissionFee: 10000.0,
      );
      createdOrg = await Organization.db.insertRow(session, org);
      orgId = createdOrg.id!;
      print('✅ Organization created: ${createdOrg.name}');
    }

    // Organization Settings
    final existingSettings = await OrganizationSettings.db.findFirstRow(
      session, 
      where: (t) => t.organizationName.equals(orgName)
    );
    if (existingSettings == null) {
      final settings = OrganizationSettings(
        organizationName: orgName,
        enabledModules: [
          'Attendance', 'Fees', 'Academics', 'Exams', 'Timetable', 
          'Transport', 'Library', 'Hostel', 'Communication', 
          'Announcements', 'Notifications'
        ],
      );
      await OrganizationSettings.db.insertRow(session, settings);
      print('✅ Organization Settings created.');
    }

    // --- 3. CREATE METADATA (Roles, Permissions) ---
    print('🔐 Creating Metadata (Roles, Permissions)...');
    
    // Permissions
    final permissionSlugs = [
      {'slug': 'attendance.view', 'desc': 'View Attendance', 'mod': 'Attendance'},
      {'slug': 'attendance.mark', 'desc': 'Mark Attendance', 'mod': 'Attendance'},
      {'slug': 'fees.view', 'desc': 'View Fees', 'mod': 'Fees'},
      {'slug': 'fees.collect', 'desc': 'Collect Fees', 'mod': 'Fees'},
      {'slug': 'users.manage', 'desc': 'Manage Users', 'mod': 'Admin'},
      {'slug': 'exams.create', 'desc': 'Create Exams', 'mod': 'Academics'},
      {'slug': 'exams.view', 'desc': 'View Exams', 'mod': 'Academics'},
      {'slug': 'announcements.view', 'desc': 'View Announcements', 'mod': 'Communication'},
      {'slug': 'reports.view', 'desc': 'View Reports', 'mod': 'Reports'},
    ];
    
    final createdPermissions = <Permission>[];
    for (var p in permissionSlugs) {
      // Check exist
      final exist = await Permission.db.findFirstRow(session, where: (t) => t.slug.equals(p['slug']));
      if (exist != null) {
        createdPermissions.add(exist);
      } else {
        createdPermissions.add(await Permission.db.insertRow(session, Permission(
          slug: p['slug']!,
          description: p['desc'],
          module: p['mod'],
        )));
      }
    }
    print('✅ ${createdPermissions.length} Permissions ready.');

    // Roles
    final createdRoles = <Role>[];
    for (var roleEnum in UserRole.values) {
      final slug = roleEnum.name;
      final exist = await Role.db.findFirstRow(session, where: (t) => t.slug.equals(slug));
      if (exist != null) {
        createdRoles.add(exist);
      } else {
        createdRoles.add(await Role.db.insertRow(session, Role(
          name: slug[0].toUpperCase() + slug.substring(1),
          slug: slug,
          description: 'Role for $slug',
          organizationName: orgName,
          isSystemRole: true,
        )));
      }
    }
    print('✅ ${createdRoles.length} Roles ready.');

    // Role-Permissions
    int rpCount = 0;
    for (var role in createdRoles) {
      if (role.slug == 'anant' || role.slug == 'admin') {
        // Admin gets all
        for (var perm in createdPermissions) {
           // check dup? assuming clear was run or logic handles
           final exist = await RolePermission.db.findFirstRow(session, where: (t) => t.roleId.equals(role.id!) & t.permissionId.equals(perm.id!));
           if (exist == null) {
             await RolePermission.db.insertRow(session, RolePermission(roleId: role.id!, permissionId: perm.id!));
             rpCount++;
           }
        }
      } else if (role.slug == 'student') {
        for (var perm in createdPermissions) {
          if (perm.slug.contains('.view')) {
             final exist = await RolePermission.db.findFirstRow(session, where: (t) => t.roleId.equals(role.id!) & t.permissionId.equals(perm.id!));
             if (exist == null) {
               await RolePermission.db.insertRow(session, RolePermission(roleId: role.id!, permissionId: perm.id!));
               rpCount++;
             }
          }
        }
      }
      // Simplified logic for others just to have data
    }
    print('✅ $rpCount RolePermission mappings.');


    // --- 4. CREATE ACADEMIC STRUCTURE (Classes, Sections, Subjects, Courses) ---
    print('🏫 Creating Academic Structure...');
    
    // Classes & Sections
    Classes? class10;
    for (var i = 1; i <= 12; i++) {
        final className = i.toString();
        // Check exist
        var cls = await Classes.db.findFirstRow(session, where: (t) => t.organizationId.equals(orgId) & t.name.equals(className));
        if (cls == null) {
          cls = await Classes.db.insertRow(session, Classes(
            organizationId: orgId,
            name: className,
            academicYear: '2025-2026',
            isActive: true,
          ));
        }
        if (i == 10) class10 = cls;

        // Sections A, B, C for each class
        for (var secName in ['A', 'B', 'C']) {
           final secExist = await Section.db.findFirstRow(session, where: (t) => t.organizationId.equals(orgId) & t.className.equals(className) & t.name.equals(secName));
           if (secExist == null) {
             await Section.db.insertRow(session, Section(
               organizationId: orgId,
               className: className,
               name: secName,
               isActive: true,
             ));
           }
        }
    }
    print('✅ Classes 1-12 and Sections A-C created.');

    // Subjects & Courses
    final subjectNames = ['Mathematics', 'Science', 'English', 'History', 'Physics'];
    final subjects = <Subject>[];
    final courses = <Course>[];

    for (var name in subjectNames) {
      // Subject
      var subj = await Subject.db.findFirstRow(session, where: (t) => t.organizationId.equals(orgId) & t.name.equals(name));
      if (subj == null) {
        subj = await Subject.db.insertRow(session, Subject(
          organizationId: orgId,
          name: name,
          description: 'Subject: $name',
        ));
      }
      subjects.add(subj);

      // Course (Mirroring subject)
      var course = await Course.db.findFirstRow(session, where: (t) => t.organizationId.equals(orgId) & t.name.equals(name));
      if (course == null) {
        course = await Course.db.insertRow(session, Course(
          organizationId: orgId,
          name: name,
          code: name.substring(0, 3).toUpperCase(),
          isActive: true,
        ));
      }
      courses.add(course);
    }
    print('✅ Subjects and Courses created.');


    // --- 5. CREATE USERS ---
    print('👥 Creating Users...');
    final Map<String, List<User>> createdUsers = {};
    
    Future<void> createUsersForRole(UserRole role, int count, String prefix) async {
      createdUsers[role.name] = [];
      for (var i = 1; i <= count; i++) {
        final numStr = i.toString().padLeft(3, '0');
        final username = '$prefix$numStr';
        final password = '${prefix[0].toUpperCase()}${prefix.substring(1)}@123';
        
        String? className;
        String? sectionName;
        String? anantId;

        if (role == UserRole.student) {
          className = '10';
          sectionName = ['A', 'B', 'C'][i % 3];
          String lastTwoDigits = DateTime.now().year.toString().substring(2);
          anantId = "$lastTwoDigits$sectionName$numStr.${role.name}@$orgName.anant";
        } else {
          anantId = '$username@$orgName.anant';
        }

        final user = User(
          uid: '',
          organizationName: orgName,
          anantId: anantId,
          email: '$username@testschool.edu',
          role: role,
          fullName: '$prefix User $i',
          isActive: true,
          isPasswordCreated: true, // This flag might be used by client
          country: 'India',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          className: className,
          sectionName: sectionName,
        );
        
        try {
          // authService.signUp creates UserCredentials and User
          final created = await authService.signUp(session, user, password);
          createdUsers[role.name]!.add(created);
          
          // Add UserRoleAssignment
          final roleObj = createdRoles.firstWhere((r) => r.slug == role.name);
           await UserRoleAssignment.db.insertRow(session, UserRoleAssignment(
             userId: created.id!,
             roleId: roleObj.id!,
             assignedAt: DateTime.now(),
             isActive: true,
           ));
           
           // Seed ExternalAuthProvider (Dummy for first user of each role)
           if (i == 1) {
             await ExternalAuthProvider.db.insertRow(session, ExternalAuthProvider(
               uid: created.uid!, // Using internal UID as reference
               provider: 'google',
               providerUid: 'google_uid_${created.id}',
               providerEmail: user.email,
               createdAt: DateTime.now(),
             ));
           }

        } catch (e) {
          print('    ⚠️ Failed/Skipped $anantId');
        }
      }
    }

    await createUsersForRole(UserRole.anant, 1, 'anant');
    await createUsersForRole(UserRole.admin, 1, 'admin'); 
    await createUsersForRole(UserRole.teacher, 2, 'teacher');
    await createUsersForRole(UserRole.student, 10, 'student'); // Reduced count for speed
    await createUsersForRole(UserRole.parent, 2, 'parent');
    
    // Seed one user for other roles just to fill tables
    await createUsersForRole(UserRole.accountant, 1, 'accountant');
    await createUsersForRole(UserRole.clerk, 1, 'clerk');

    print('✅ Users, Credentials, RoleAssignments, ExternalAuth populated.');

    final students = createdUsers['student'] ?? [];
    final teachers = createdUsers['teacher'] ?? [];
    final class10Id = class10!.id!;

    // --- 6. OPERATIONAL DATA (Enrollments, Timetable, Exams, Attendance, Fees) ---
    print('📝 Creating Operational Data...');

    // Enrollments
    for (var student in students) {
      await Enrollment.db.insertRow(session, Enrollment(
        organizationId: orgId,
        classId: class10Id,
        studentId: student.id!,
      ));

      // Student Course Enrollment
      for (var j = 0; j < 3; j++) {
         await StudentCourseEnrollment.db.insertRow(session, StudentCourseEnrollment(
           studentAnantId: student.anantId!,
           courseName: courses[j].name,
           organizationId: orgId,
           enrolledOn: DateTime.now(),
         ));
      }
    }
    print('✅ Enrollments.');

    // Timetable
    if (teachers.isNotEmpty) {
      for (var day = 1; day <= 5; day++) {
        await TimetableEntry.db.insertRow(session, TimetableEntry(
          organizationId: orgId,
          classId: class10Id,
          subjectId: subjects.first.id!,
          teacherId: teachers.first.id!,
          dayOfWeek: day,
          startTime: DateTime(2025, 1, 1, 9, 0),
          durationMinutes: 45,
        ));
      }
    }
    print('✅ Timetable.');

    // Exams
    await Exam.db.insertRow(session, Exam(
      organizationId: orgId,
      classId: class10Id,
      subjectId: subjects.first.id!,
      name: 'Midterm Physics',
      date: DateTime.now().add(Duration(days: 15)),
      totalMarks: 100,
    ));
    print('✅ Exams.');

    // Attendance
    for (var student in students) {
       await Attendance.db.insertRow(session, Attendance(
         organizationName: orgName,
         className: '10',
         sectionName: 'A',
         studentAnantId: student.anantId!,
         startTime: '09:00',
         endTime: '15:00',
         date: DateTime.now().toIso8601String().split('T')[0],
         markedByAnantId: teachers.first.anantId!,
         status: 'Present',
         isSubmitted: true,
       ));
    }
    print('✅ Attendance.');

    // Fees & Transactions
    for (var student in students) {
      // Fee Record
      final fee = await FeeRecord.db.insertRow(session, FeeRecord(
        organizationId: orgId,
        studentId: student.id!,
        amount: 5000.0,
        dueDate: DateTime.now().add(Duration(days: 30)),
        paidDate: DateTime.now(),
        description: 'Term 1 Fee',
      ));
      
      // Monthly Fee Transaction
      await MonthlyFeeTransaction.db.insertRow(session, MonthlyFeeTransaction(
        anantId: student.anantId!,
        organizationName: orgName,
        month: 'April',
        feeAmount: 5000.0,
        discount: 0,
        fine: 0,
        transactionDate: DateTime.now(),
        transactionGateway: 'Cash',
        transactionRef: 'REF-${random.nextInt(99999)}',
        transactionId: 'TXN-${random.nextInt(99999)}',
        transactionStatus: 'Success',
        transactionType: 'Cash',
        markedByAnantId: 'admin@$orgName.anant',
      ));
    }
    print('✅ Fees & Transactions.');

    // --- 7. COMMUNICATION & AUDIT (Announcements, Notifications, Audit, etc) ---
    print('📢 Creating Communication & Audits...');

    // Announcements
    await Announcement.db.insertRow(session, Announcement(
      organizationId: orgId,
      title: 'Welcome!',
      content: 'Welcome to the new session.',
      priority: 'High',
      targetAudience: 'All',
      createdBy: 'system',
      createdAt: DateTime.now(),
      isActive: true,
    ));

    // Notifications
    if (students.isNotEmpty) {
      await Notification.db.insertRow(session, Notification(
        organizationId: orgId,
        userId: students.first.anantId!,
        title: 'Fee Paid',
        message: 'Your fee has been received.',
        type: 'fee',
        timestamp: DateTime.now(),
        isRead: false,
      ));
    }

    // PermissionAudit (Dummy)
    if (teachers.isNotEmpty) {
      await PermissionAudit.db.insertRow(session, PermissionAudit(
        userId: teachers.first.id!,
        permissionSlug: 'attendance.mark',
        action: 'check',
        success: true,
        timestamp: DateTime.now(),
        organizationName: orgName,
      ));
    }

    // UserPermissionOverride (Dummy)
    if (students.isNotEmpty) {
       // Grant specific permission to one student
       final perm = createdPermissions.first;
       await UserPermissionOverride.db.insertRow(session, UserPermissionOverride(
         userId: students.first.id!,
         permissionId: perm.id!,
         isGranted: true,
       ));
    }

    // ResourcePermission (Dummy)
    final role = createdRoles.first;
    final perm = createdPermissions.first;
    await ResourcePermission.db.insertRow(session, ResourcePermission(
      roleId: role.id!,
      permissionId: perm.id!,
      resourceType: 'Document',
      resourceId: 'doc_123',
      organizationName: orgName,
      createdAt: DateTime.now(),
    ));

    print('✅ Announcements, Notifications, Audits populated.');

    print('\n✨ SEEDING COMPLETE! ✨');
    print('All tables have been populated with at least one record.');

  } catch (e, stack) {
    print('❌ Error seeding data: $e');
    print(stack);
  } finally {
    await session.close();
    await serverpod.shutdown();
  }
}
