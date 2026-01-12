
import 'package:test/test.dart';

import 'package:anant_server/src/generated/protocol.dart';
import 'package:anant_server/src/services/admin_service.dart';
import 'package:anant_server/src/services/organization_service.dart';
import 'package:anant_server/src/services/user_service.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('AdminService Integration Test', (sessionBuilder, endpoints) {
    var session = sessionBuilder.build();

    test('Super Admin can Create and Pause Organization', () async {
      final org = Organization(
        name: 'New Test Org Full Name',
        organizationName: 'NewTestOrg2',
        type: 'School',
        city: 'Test City',
        state: 'Test State',
        createdAt: DateTime.now(),
      );
      
      final created = await OrganizationService.createOrganization(session, org);
      expect(created.id, isNotNull);

      // Verify active by default (if default is true)
      expect(created.isActive, isTrue);

      // Pause it
      final paused = await AdminService.toggleOrganizationStatus(session, created.id!, false);
      expect(paused?.isActive, isFalse);
      
      // Verify DB persistence
      final fetched = await OrganizationService.getOrganization(session, created.id!);
      expect(fetched?.isActive, isFalse);
    });

    test('Super Admin can Update Any User', () async {
      // Create user
      final user = User(
        organizationName: 'Edit School',
        fullName: 'Original Name',
        role: UserRole.student,
        country: 'India',
        anantId: 'edit_me'
      );
      final created = await User.db.insertRow(session, user);

      // Update name
      final toUpdate = created.copyWith(fullName: 'Updated Name');
      final updated = await AdminService.updateAnyUser(session, toUpdate);
      
      expect(updated?.fullName, equals('Updated Name'));

      // Verify DB
      final fetched = await UserService.getUserById(session, created.id!);
      expect(fetched?.fullName, equals('Updated Name'));
    });

    test('Bulk Import Users (CSV Simulation)', () async {
      final usersToImport = [
        User(organizationName: 'Bulk School', fullName: 'Bulk 1', role: UserRole.student, country: 'India', anantId: 'bulk1'),
        User(organizationName: 'Bulk School', fullName: 'Bulk 2', role: UserRole.student, country: 'India', anantId: 'bulk2'),
      ];

      final count = await AdminService.bulkImportUsers(session, usersToImport);
      expect(count, equals(2));

      // Verify they exist
      final u1 = await UserService.getUserByAnantId(session, 'bulk1');
      expect(u1, isNotNull);
    });

    test('Password Reset (Sudo)', () async {
       final user = User(
        organizationName: 'Reset School',
        fullName: 'Forgot Password',
        role: UserRole.student,
        country: 'India',
        anantId: 'reset_me'
      );
      final created = await User.db.insertRow(session, user);
      
      // Call Reset
      final success = await AdminService.resetUserPassword(session, created.id!, 'newPass123');
      expect(success, isTrue);
    });
  });
}
