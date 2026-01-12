
import 'package:test/test.dart';

import 'package:anant_server/src/generated/protocol.dart';
import 'package:anant_server/src/services/user_service.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('UserService Integration Test', (sessionBuilder, endpoints) {
    var session = sessionBuilder.build();
    
    setUp(() async {
      // Clean up before tests
      // Note: Ideally use a test transaction or clean DB. 
      // For now, we assume a fresh-ish test DB or unique IDs.
    });

    test('Create and Fetch User by ID', () async {
      final user = User(
        organizationName: 'Test School',
        fullName: 'Test Student',
        role: UserRole.student,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        // Add other required fields if any non-nullable
        country: 'India',
        isActive: true,
      );
      
      final created = await User.db.insertRow(session, user);
      expect(created.id, isNotNull);

      // Fetch by ID (should hit DB first time)
      final fetched = await UserService.getUserById(session, created.id!);
      expect(fetched?.fullName, equals('Test Student'));

      // Fetch again (should hit Cache ideally, but logic is transparent)
      final fetched2 = await UserService.getUserById(session, created.id!);
      expect(fetched2?.id, equals(created.id));
    });

    test('Filter Users with Pagination', () async {
      // Create users
      await User.db.insertRow(session, User(
        organizationName: 'Filter School',
        className: '10',
        sectionName: 'A',
        role: UserRole.student,
        fullName: 'Student 1',
        country: 'India',
      ));
      await User.db.insertRow(session, User(
        organizationName: 'Filter School',
        className: '10',
        sectionName: 'A',
        role: UserRole.student,
        fullName: 'Student 2',
        country: 'India',
      ));

      // Test Filter
      final users = await UserService.getFilteredUsers(
        session, 'A', '10', 'Filter School', 'student'
      );
      expect(users.length, greaterThanOrEqualTo(2));
      
      // Test Pagination
      final paged = await UserService.getFilteredUsers(
        session, 'A', '10', 'Filter School', 'student',
        limit: 1, offset: 0
      );
      expect(paged.length, equals(1));
    });

    test('Super Admin "Anant" Override', () async {
      // Create a hidden user in a different org
      await User.db.insertRow(session, User(
        organizationName: 'Hidden School',
        fullName: 'Hidden User',
        role: UserRole.student,
        country: 'India',
      ));

      // As Anant role (passing 'Anant' as organizationName bypass)
      // Note: The service uses organizationName argument as a bypass signal for now, 
      // or ideally the caller ensures it. 
      // Verification of the bypass logic in UserService.getFilteredUsers:
      
      final allUsers = await UserService.getFilteredUsers(
        session, '', '', 'Anant', '' // 'Anant' as org triggers override
      );
      
      // Should find the hidden user
      final hiddenFound = allUsers.any((u) => u.organizationName == 'Hidden School');
      expect(hiddenFound, isTrue);
    });
  });
}
