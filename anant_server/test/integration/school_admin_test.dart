
import 'package:test/test.dart';
import 'package:anant_server/src/generated/protocol.dart';
import 'package:anant_server/src/services/user_service.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('School Admin Permissions Test', (sessionBuilder, endpoints) {
    var session = sessionBuilder.build();

    test('School Admin Update Logic (Hierarchy)', () async {
      // Setup: Create 1 Admin, 1 Teacher, 1 Student in Org A
      final org = 'School A';
      
      final admin = await User.db.insertRow(session, User(
        organizationName: org, fullName: 'Admin User', role: UserRole.admin, country: 'India'
      ));
      
      final teacher = await User.db.insertRow(session, User(
        organizationName: org, fullName: 'Teacher User', role: UserRole.teacher, country: 'India'
      ));

      final peerAdmin = await User.db.insertRow(session, User(
        organizationName: org, fullName: 'Peer Admin', role: UserRole.admin, country: 'India'
      ));

      // Test 1: Admin updates Teacher -> Should Succeed
      // We simulate "Requesting User" by passing ID manually to service method
      final updateTeacher = teacher.copyWith(fullName: 'Updated Teacher');
      final success1 = await UserService.updateUser(session, updateTeacher, requestingUserId: admin.id);
      expect(success1, isNotNull);
      expect(success1?.fullName, equals('Updated Teacher'));

      // Test 2: Admin updates Peer Admin -> Should Fail (Hierarchy)
      final updatePeer = peerAdmin.copyWith(fullName: 'Hacked Peer');
      final success2 = await UserService.updateUser(session, updatePeer, requestingUserId: admin.id);
      expect(success2, isNull); // Should be denied
    });

    test('School Admin Cross-Org Isolation', () async {
       final adminA = await User.db.insertRow(session, User(
        organizationName: 'Org A', fullName: 'Admin A', role: UserRole.admin, country: 'India'
      ));
      
      final studentB = await User.db.insertRow(session, User(
        organizationName: 'Org B', fullName: 'Student B', role: UserRole.student, country: 'India'
      ));

      // Test: Admin A tries to delete Student B -> Should Fail
      final success = await UserService.deleteUser(session, studentB.id!, requestingUserId: adminA.id);
      expect(success, isFalse);
    });
  });
}
