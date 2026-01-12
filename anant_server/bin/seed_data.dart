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
    print('🌱 Starting Comprehensive Seeding...');

    // --- 1. ASK FOR CONFIRMATION TO CLEAR DATABASE ---
    print('\n⚠️  WARNING: Do you want to DELETE all existing data before seeding?');
    print('If you select "no", the script will only add missing data without clearing existing data.');
    print('Clear database before seeding? (yes/no): ');
    
    final response = stdin.readLineSync()?.trim().toLowerCase();
    
    bool shouldClear = (response == 'yes' || response == 'y');

    if (shouldClear) {
      // --- 2. CLEAR DATABASE ---
      print('🗑️ Clearing existing data...');
      // Delete children first to avoid foreign key constraints
      await Notification.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await Announcement.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await UserRoleAssignment.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await RolePermission.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await StudentCourseEnrollment.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await Enrollment.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await FeeRecord.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await Attendance.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await Exam.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await TimetableEntry.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await Course.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await Section.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await Subject.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await Classes.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await UserCredentials.db.deleteWhere(session, where: (t) => Constant.bool(true));
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

    // --- 3. CHECK/CREATE ORGANIZATION ---
    print('🏢 Checking for Organization...');
    final existingOrgs = await Organization.db.find(
      session,
      where: (t) => t.organizationName.equals('AnantSchool'),
      limit: 1,
    );
    
    Organization createdOrg;
    if (existingOrgs.isNotEmpty) {
      createdOrg = existingOrgs.first;
      print('✅ Organization already exists: ${createdOrg.name} (ID: ${createdOrg.id})');
    } else {
      print('   Creating Organization...');
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
      );
      createdOrg = await Organization.db.insertRow(session, org);
      print('✅ Organization created: ${createdOrg.name} (ID: ${createdOrg.id})');
    }
    final orgId = createdOrg.id!;
    print('✅ Organization created: ${createdOrg.name} (ID: $orgId)');

    // --- 4. CHECK/CREATE CLASS ---
    print('🏫 Checking for Class...');
    final existingClasses = await Classes.db.find(
      session,
      where: (t) => t.organizationId.equals(orgId) & t.name.equals('10'),
      limit: 1,
    );
    
    Classes createdClass;
    if (existingClasses.isNotEmpty) {
      createdClass = existingClasses.first;
      print('✅ Class already exists: ${createdClass.name} (ID: ${createdClass.id})');
    } else {
      print('   Creating Class...');
      final schoolClass = Classes(
        organizationId: orgId,
        name: '10',
        academicYear: '2025-2026',
        isActive: true,
      );
      createdClass = await Classes.db.insertRow(session, schoolClass);
      print('✅ Class created: ${createdClass.name} (ID: ${createdClass.id})');
    }
    final classId = createdClass.id!;

    // --- 5. CHECK/CREATE SUBJECTS ---
    print('📚 Checking for Subjects...');
    final subjectNames = ['Mathematics', 'Science', 'English', 'History', 'Physics'];
    final subjects = <Subject>[];
    
    for (var name in subjectNames) {
      // Check if subject already exists
      final existingSubjects = await Subject.db.find(
        session,
        where: (t) => t.organizationId.equals(orgId) & t.name.equals(name),
        limit: 1,
      );
      
      if (existingSubjects.isNotEmpty) {
        subjects.add(existingSubjects.first);
      } else {
        final subject = Subject(
          organizationId: orgId,
          name: name,
          description: 'Subject: $name',
        );
        subjects.add(await Subject.db.insertRow(session, subject));
      }
    }
    print('✅ ${subjects.length} Subjects ready (existing or newly created).');

    // --- 6. CREATE USERS (ALL ROLES) ---
    print('👥 Creating Users for all roles...');
    
    final Map<String, List<User>> createdUsers = {};
    
    print('\n🔑 User Credentials:');
    print('--------------------------------------------------------------------------------------------------');
    print('| Role           | Anant ID                                           | Password           |');
    print('--------------------------------------------------------------------------------------------------');

    Future<void> createUsersForRole(UserRole role, int count, String prefix) async {
      createdUsers[role.name] = [];
      // print('  - Creating $count ${role.name}s...'); // Moved to summary or keep if needed, but table is better
      
      for (var i = 1; i <= count; i++) {
        final numStr = i.toString().padLeft(3, '0');
        final username = '$prefix$numStr';
        final password = '${prefix[0].toUpperCase()}${prefix.substring(1)}@123'; // e.g., Admin@123
        
        String? className;
        String? sectionName;
        String? admissionNumber;
        String? anantId;
        String orgName = 'AnantSchool';

        if (role == UserRole.student) {
          className = '10'; // Using the class created above
          sectionName = ['A', 'B', 'C'][i % 3];
          admissionNumber = 'ADM$numStr';
          
          // Generate anantId using system format: YYSecAdm.role@org.anant
          int currentYear = DateTime.now().year;
          String lastTwoDigits = currentYear.toString().substring(currentYear.toString().length - 2);
          anantId = "$lastTwoDigits$sectionName$admissionNumber.${role.name}@$orgName.anant";
        } else {
          anantId = '$username@$orgName.anant';
          sectionName = 'Staff';
          admissionNumber = 'STF$numStr';
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
          parentMobileNumber: role == UserRole.student ? '987654321$i' : null,
          subjectTeaching: role == UserRole.teacher ? ['Mathematics', 'Science', 'English'] : null,
          classAndSectionTeaching: role == UserRole.teacher ? ['10A', '10B', '10C'] : null,
        );
        
        try {
          final created = await authService.signUp(session, user, password);
          createdUsers[role.name]!.add(created);
          print('| ${role.name.padRight(14)} | ${anantId.padRight(50)} | ${password.padRight(18)} |');
        } catch (e) {
          print('    ⚠️ Failed to create $anantId: $e');
        }
      }
    }

    // Execute creation for all roles
    await createUsersForRole(UserRole.anant, 1, 'anant'); // System Super Admin
    await createUsersForRole(UserRole.admin, 2, 'admin');
    await createUsersForRole(UserRole.principal, 2, 'principal');
    await createUsersForRole(UserRole.teacher, 2, 'teacher'); // Request said 2 members of each role (except student)
    await createUsersForRole(UserRole.student, 35, 'student');
    await createUsersForRole(UserRole.accountant, 2, 'accountant');
    await createUsersForRole(UserRole.clerk, 2, 'clerk');
    await createUsersForRole(UserRole.librarian, 2, 'librarian');
    await createUsersForRole(UserRole.transport, 2, 'transport');
    await createUsersForRole(UserRole.hostel, 2, 'hostel');
    await createUsersForRole(UserRole.parent, 2, 'parent');
    
    final teachers = createdUsers['teacher'] ?? [];
    final students = createdUsers['student'] ?? [];
    
    print('✅ Users created:');
    createdUsers.forEach((role, users) {
      print('  - $role: ${users.length}');
    });

    // --- 7. CREATE TIMETABLE ---
    print('📅 Creating Timetable...');
    if (teachers.isNotEmpty) {
      for (var day = 1; day <= 5; day++) { // Mon-Fri
        for (var period = 0; period < 5; period++) {
          final subject = subjects[random.nextInt(subjects.length)];
          final teacher = teachers[random.nextInt(teachers.length)];
          
          final entry = TimetableEntry(
            organizationId: orgId,
            classId: classId,
            subjectId: subject.id!,
            teacherId: teacher.id!,
            dayOfWeek: day,
            startTime: DateTime(2025, 1, 1, 9 + period, 0), // 9:00, 10:00, etc.
            durationMinutes: 45,
          );
          await TimetableEntry.db.insertRow(session, entry);
        }
      }
      print('✅ Timetable created for Class 10.');
    }

    // --- 8. CREATE EXAMS ---
    print('📝 Creating Exams...');
    final examNames = ['Midterm Exam', 'Final Exam'];
    for (var examName in examNames) {
      for (var subject in subjects) {
        final exam = Exam(
          organizationId: orgId,
          classId: classId,
          subjectId: subject.id!,
          name: '$examName - ${subject.name}',
          date: DateTime.now().add(Duration(days: 10 + random.nextInt(20))),
          totalMarks: 100,
        );
        await Exam.db.insertRow(session, exam);
      }
    }
    print('✅ Exams created.');

    // --- 9. CREATE ATTENDANCE ---
    print('🙋 Creating Attendance...');
    final today = DateTime.now();
    if (teachers.isNotEmpty) {
      for (var i = 0; i < 5; i++) { // Last 5 days
        final date = today.subtract(Duration(days: i));
        final dateStr = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
        
        for (var student in students) {
          final isPresent = random.nextDouble() > 0.2; // 80% attendance
          final attendance = Attendance(
            organizationName: 'AnantSchool',
            className: '10',
            sectionName: 'A',
            studentAnantId: student.anantId!,
            startTime: '09:00',
            endTime: '15:00',
            date: dateStr,
            markedByAnantId: teachers.first.anantId!,
            status: isPresent ? 'Present' : 'Absent',
            isSubmitted: true,
            remarks: isPresent ? null : 'Sick leave',
          );
          await Attendance.db.insertRow(session, attendance);
        }
      }
      print('✅ Attendance records created.');
    }

    // --- 10. CREATE FEE RECORDS ---
    print('💰 Creating Fee Records...');
    for (var student in students) {
      final fee = FeeRecord(
        organizationId: orgId,
        studentId: student.id!,
        amount: 5000.0,
        dueDate: DateTime.now().add(Duration(days: 30)),
        paidDate: random.nextBool() ? DateTime.now() : null, // 50% paid
        description: 'Tuition Fee - Term 1',
      );
      await FeeRecord.db.insertRow(session, fee);
    }
    print('✅ Fee records created.');

    // --- 11. CREATE ENROLLMENTS ---
    print('📝 Creating Enrollments...');
    int enrollmentCount = 0;
    for (var student in students) {
      final enrollment = Enrollment(
        organizationId: orgId,
        classId: classId,
        studentId: student.id!,
      );
      await Enrollment.db.insertRow(session, enrollment);
      enrollmentCount++;
    }
    print('✅ Enrollments created ($enrollmentCount).');

    // --- 12. CREATE STUDENT COURSE ENROLLMENTS ---
    print('📚 Creating Student Course Enrollments...');
    int courseEnrollmentCount = 0;
    for (var student in students) {
      if (student.anantId == null) continue;
      // Enroll each student in 3-5 random subjects
      final numCourses = 3 + random.nextInt(3);
      final enrolledSubjects = <int>{};
      
      while (enrolledSubjects.length < numCourses && enrolledSubjects.length < subjects.length) {
        final subject = subjects[random.nextInt(subjects.length)];
        if (!enrolledSubjects.contains(subject.id)) {
          enrolledSubjects.add(subject.id!);
          final courseEnrollment = StudentCourseEnrollment(
            studentAnantId: student.anantId!,
            courseName: subject.name,
            organizationId: orgId,
            enrolledOn: DateTime.now().subtract(Duration(days: random.nextInt(180))),
          );
          await StudentCourseEnrollment.db.insertRow(session, courseEnrollment);
          courseEnrollmentCount++;
        }
      }
    }
    print('✅ Student Course Enrollments created ($courseEnrollmentCount).');

    // --- 13. CREATE ROLE PERMISSIONS ---
    print('🔐 Creating Role Permissions...');
    // First, create permissions
    final permissionSlugs = [
      {'slug': 'attendance.view', 'description': 'View Attendance', 'module': 'Attendance'},
      {'slug': 'attendance.mark', 'description': 'Mark Attendance', 'module': 'Attendance'},
      {'slug': 'fees.view', 'description': 'View Fees', 'module': 'Fees'},
      {'slug': 'fees.collect', 'description': 'Collect Fees', 'module': 'Fees'},
      {'slug': 'users.manage', 'description': 'Manage Users', 'module': 'Admin'},
      {'slug': 'exams.create', 'description': 'Create Exams', 'module': 'Academics'},
      {'slug': 'exams.view', 'description': 'View Exams', 'module': 'Academics'},
      {'slug': 'announcements.create', 'description': 'Create Announcements', 'module': 'Communication'},
      {'slug': 'announcements.view', 'description': 'View Announcements', 'module': 'Communication'},
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

    // Create roles for each UserRole
    final createdRoles = <Role>[];
    for (var roleEnum in UserRole.values) {
      final role = Role(
        name: roleEnum.name[0].toUpperCase() + roleEnum.name.substring(1),
        slug: roleEnum.name,
        description: 'System role for ${roleEnum.name}',
        organizationName: 'AnantSchool',
        isSystemRole: true,
      );
      createdRoles.add(await Role.db.insertRow(session, role));
    }

    // Map permissions to roles
    int rolePermissionCount = 0;
    for (var role in createdRoles) {
      // Admin and Anant get all permissions
      if (role.slug == 'admin' || role.slug == 'anant') {
        for (var permission in createdPermissions) {
          final rolePermission = RolePermission(
            roleId: role.id!,
            permissionId: permission.id!,
          );
          await RolePermission.db.insertRow(session, rolePermission);
          rolePermissionCount++;
        }
      }
      // Teacher gets exam and attendance permissions
      else if (role.slug == 'teacher') {
        for (var permission in createdPermissions) {
          if (permission.slug.startsWith('attendance.') || 
              permission.slug.startsWith('exams.') || 
              permission.slug.startsWith('announcements.view')) {
            final rolePermission = RolePermission(
              roleId: role.id!,
              permissionId: permission.id!,
            );
            await RolePermission.db.insertRow(session, rolePermission);
            rolePermissionCount++;
          }
        }
      }
      // Accountant gets fee permissions
      else if (role.slug == 'accountant') {
        for (var permission in createdPermissions) {
          if (permission.slug.startsWith('fees.')) {
            final rolePermission = RolePermission(
              roleId: role.id!,
              permissionId: permission.id!,
            );
            await RolePermission.db.insertRow(session, rolePermission);
            rolePermissionCount++;
          }
        }
      }
      // Students get view-only permissions
      else if (role.slug == 'student') {
        for (var permission in createdPermissions) {
          if (permission.slug.contains('.view')) {
            final rolePermission = RolePermission(
              roleId: role.id!,
              permissionId: permission.id!,
            );
            await RolePermission.db.insertRow(session, rolePermission);
            rolePermissionCount++;
          }
        }
      }
    }
    print('✅ Role Permissions created ($rolePermissionCount).');

    // --- 14. CREATE USER ROLE ASSIGNMENTS ---
    print('👤 Creating User Role Assignments...');
    int roleAssignmentCount = 0;
    for (var roleKey in createdUsers.keys) {
      final usersInRole = createdUsers[roleKey]!;
      final matchingRole = createdRoles.firstWhere((r) => r.slug == roleKey);
      
      for (var user in usersInRole) {
        final assignment = UserRoleAssignment(
          userId: user.id!,
          roleId: matchingRole.id!,
          assignedAt: DateTime.now().subtract(Duration(days: random.nextInt(30))),
          isActive: true,
        );
        await UserRoleAssignment.db.insertRow(session, assignment);
        roleAssignmentCount++;
      }
    }
    print('✅ User Role Assignments created ($roleAssignmentCount).');

    // --- 15. CREATE ANNOUNCEMENTS ---
    print('📢 Creating Announcements...');
    final announcements = [
      {
        'title': 'School Annual Day',
        'content': 'The Annual Day celebration will be held on December 24th from 5 PM onwards in the main auditorium. All students and parents are cordially invited.',
        'priority': 'High',
        'targetAudience': 'All',
      },
      {
        'title': 'Winter Vacation Notice',
        'content': 'The school will remain closed for winter vacation starting from Dec 25th. Classes will resume on Jan 6th.',
        'priority': 'Normal',
        'targetAudience': 'All',
      },
      {
        'title': 'Parent-Teacher Meeting',
        'content': 'Parent-Teacher meeting for Class 10 will be held on Dec 20th at 4 PM.',
        'priority': 'High',
        'targetAudience': 'Parents',
      },
      {
        'title': 'Staff Meeting',
        'content': 'All teaching staff are requested to attend the monthly meeting on Dec 22nd at 10 AM.',
        'priority': 'Normal',
        'targetAudience': 'Teachers',
      },
    ];
    
    for (var announcementData in announcements) {
      final announcement = Announcement(
        organizationId: orgId,
        title: announcementData['title'] as String,
        content: announcementData['content'] as String,
        priority: announcementData['priority'] as String,
        targetAudience: announcementData['targetAudience'] as String,
        createdBy: teachers.isNotEmpty ? teachers.first.anantId! : 'system',
        createdAt: DateTime.now().subtract(Duration(days: random.nextInt(5))),
        isActive: true,
      );
      await Announcement.db.insertRow(session, announcement);
    }
    print('✅ Announcements created (${announcements.length}).');

    // --- 12. CREATE NOTIFICATIONS ---
    print('🔔 Creating Notifications...');
    int notificationCount = 0;
    
    // Create fee due notifications for students with pending fees
    for (var student in students) {
      final pendingFees = await FeeRecord.db.find(
        session,
        where: (t) => t.studentId.equals(student.id!) & t.paidDate.equals(null),
      );
      
      if (pendingFees.isNotEmpty) {
        final notification = Notification(
          organizationId: orgId,
          userId: student.anantId!,
          title: 'Fee Payment Due',
          message: 'Your fee of ₹${pendingFees.first.amount} is due on ${pendingFees.first.dueDate?.toString().split(' ')[0]}',
          type: 'fee',
          relatedId: pendingFees.first.id.toString(),
          timestamp: DateTime.now().subtract(Duration(hours: random.nextInt(48))),
          isRead: random.nextBool(),
        );
        await Notification.db.insertRow(session, notification);
        notificationCount++;
      }
    }
    
    // Create announcement notifications for all users
    for (var user in [...students, ...teachers, ...createdUsers['admin']!]) {
      final notification = Notification(
        organizationId: orgId,
        userId: user.anantId!,
        title: 'School Annual Day',
        message: 'The Annual Day celebration will be held on December 24th from 5 PM onwards.',
        type: 'announcement',
        timestamp: DateTime.now().subtract(Duration(hours: 5)),
        isRead: random.nextBool(),
      );
      await Notification.db.insertRow(session, notification);
      notificationCount++;
    }
    print('✅ Notifications created ($notificationCount).');

    print('\n✨ SEEDING COMPLETE! ✨');
    print('Created:');
    print(' - 1 Organization');
    print(' - 1 Class');
    print(' - ${subjects.length} Subjects');
    createdUsers.forEach((role, users) {
      print(' - ${users.length} ${role}s');
    });
    print(' - $enrollmentCount Enrollments');
    print(' - $courseEnrollmentCount Student Course Enrollments');
    print(' - ${createdPermissions.length} Permissions');
    print(' - ${createdRoles.length} Roles');
    print(' - $rolePermissionCount Role-Permission Mappings');
    print(' - $roleAssignmentCount User-Role Assignments');
    print(' - Timetable, Exams, Attendance, Fees, Announcements, Notifications populated.');

  } catch (e, stack) {
    print('❌ Error seeding data: $e');
    print(stack);
  } finally {
    await session.close();
    await serverpod.shutdown();
  }
}
