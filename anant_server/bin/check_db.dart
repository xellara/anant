import 'package:anant_server/src/generated/protocol.dart';
import 'package:anant_server/src/generated/endpoints.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart' as auth;

void main(List<String> args) async {
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  var session = await pod.createSession(enableLogging: true);
  
  print('\n--- CHECKING DATABASE ---');

  try {
    // 1. Check Users
    print('\n[User Table]');
    var users = await User.db.find(session, limit: 100);
    print('Count: ${users.length}');
    for (var user in users) {
      print(' - ID: ${user.id}, AnantID: ${user.anantId}, Email: ${user.email}, Role: ${user.role}');
    }

    // 2. Check Auth UserInfo
    print('\n[Auth.UserInfo Table]');
    var authUsers = await auth.UserInfo.db.find(session, limit: 100);
    print('Count: ${authUsers.length}');
    for (var u in authUsers) {
      print(' - ID: ${u.id}, Identifier: ${u.userIdentifier}, UserName: ${u.userName}');
    }

    // 3. Check UserCredentials
    print('\n[UserCredentials Table]');
    var creds = await UserCredentials.db.find(session, limit: 100);
    print('Count: ${creds.length}');

    // 4. Check Organization
    print('\n[Organization Table]');
    var orgs = await Organization.db.find(session);
    print('Count: ${orgs.length}');
    if (orgs.isNotEmpty) print(' - Name: ${orgs.first.name}');

    // 5. Check Classes
    print('\n[Classes Table]');
    var classes = await Classes.db.find(session);
    print('Count: ${classes.length}');
    if (classes.isNotEmpty) print(' - Class: ${classes.first.name}');

    // 6. Check Subjects
    print('\n[Subject Table]');
    var subjects = await Subject.db.find(session);
    print('Count: ${subjects.length}');

    // 7. Check Timetable
    print('\n[TimetableEntry Table]');
    var timetable = await TimetableEntry.db.find(session);
    print('Count: ${timetable.length}');

    // 8. Check Exams
    print('\n[Exam Table]');
    var exams = await Exam.db.find(session);
    print('Count: ${exams.length}');

    // 9. Check Attendance
    print('\n[Attendance Table]');
    var attendance = await Attendance.db.find(session);
    print('Count: ${attendance.length}');

    // 10. Check FeeRecord
    print('\n[FeeRecord Table]');
    var fees = await FeeRecord.db.find(session);
    print('Count: ${fees.length}');

  } catch (e, stack) {
    print('Error: $e');
    print(stack);
  }
  
  await session.close();
  // Do not shutdown pod here as it might hang if we want to reuse connection, but for a script it is fine.
  // await pod.shutdown(); 
}
