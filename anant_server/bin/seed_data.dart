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

    // --- 1. CLEAR DATABASE ---
    print('🗑️ Clearing existing data...');
    // Delete children first to avoid foreign key constraints
    await Notification.db.deleteWhere(session, where: (t) => Constant.bool(true));
    await Announcement.db.deleteWhere(session, where: (t) => Constant.bool(true));
    await FeeRecord.db.deleteWhere(session, where: (t) => Constant.bool(true));
    await Attendance.db.deleteWhere(session, where: (t) => Constant.bool(true));
    await Exam.db.deleteWhere(session, where: (t) => Constant.bool(true));
    await TimetableEntry.db.deleteWhere(session, where: (t) => Constant.bool(true));
    await Subject.db.deleteWhere(session, where: (t) => Constant.bool(true));
    await Classes.db.deleteWhere(session, where: (t) => Constant.bool(true));
    await UserCredentials.db.deleteWhere(session, where: (t) => Constant.bool(true));
    await User.db.deleteWhere(session, where: (t) => Constant.bool(true));
    await auth.UserInfo.db.deleteWhere(session, where: (t) => Constant.bool(true));
    await Organization.db.deleteWhere(session, where: (t) => Constant.bool(true));
    print('✅ Database cleared.');

    // --- 2. CREATE ORGANIZATION ---
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
    );
    final createdOrg = await Organization.db.insertRow(session, org);
    final orgId = createdOrg.id!;
    print('✅ Organization created: ${createdOrg.name} (ID: $orgId)');

    // --- 3. CREATE CLASS ---
    print('🏫 Creating Class...');
    final schoolClass = Classes(
      organizationId: orgId,
      name: '10',
      academicYear: '2025-2026',
      isActive: true,
    );
    final createdClass = await Classes.db.insertRow(session, schoolClass);
    final classId = createdClass.id!;
    print('✅ Class created: ${createdClass.name} (ID: $classId)');

    // --- 4. CREATE SUBJECTS ---
    print('📚 Creating Subjects...');
    final subjectNames = ['Mathematics', 'Science', 'English', 'History', 'Physics'];
    final subjects = <Subject>[];
    for (var name in subjectNames) {
      final subject = Subject(
        organizationId: orgId,
        name: name,
        description: 'Subject: $name',
      );
      subjects.add(await Subject.db.insertRow(session, subject));
    }
    print('✅ ${subjects.length} Subjects created.');

    // --- 5. CREATE USERS (ALL ROLES) ---
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

    // --- 11. CREATE ANNOUNCEMENTS ---
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
    print(' - Timetable, Exams, Attendance, Fees populated.');

  } catch (e, stack) {
    print('❌ Error seeding data: $e');
    print(stack);
  } finally {
    await session.close();
    await serverpod.shutdown();
  }
}
