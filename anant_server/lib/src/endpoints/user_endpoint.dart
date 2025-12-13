import 'package:serverpod/serverpod.dart';
import 'package:anant_server/src/generated/protocol.dart';

class UserEndpoint extends Endpoint {
  /// Retrieves all the data about a user given their user ID.
  Future<User?> me(Session session, int userId) async {
    try {
      // Retrieve the custom User record from the database.
      final user = await User.db.findById(session, userId);
      if (user == null) {
        print('No user found with id: $userId');
      }
      return user;
    } catch (e, st) {
      print('Error retrieving user data for id $userId: $e\n$st');
      return null;
    }
  }

  /// Retrieves user data by anantId (case-insensitive).
  Future<User?> getByAnantId(Session session, String anantId) async {
    try {
      final user = await User.db.findFirstRow(
        session,
        where: (t) => t.anantId.ilike(anantId),
      );
      if (user == null) {
        print('No user found with anantId: $anantId');
      }
      return user;
    } catch (e, st) {
      print('Error retrieving user data for anantId $anantId: $e\n$st');
      return null;
    }
  }

  /// Get all Users without filtering.
  Future<List<User>> getAllUsers(Session session) async {
    return await User.db.find(session);
  }

  /// Get all Users filtered by sectionName, className, and organizationName.
  Future<List<User>> getFilteredUsers(
    Session session,
    String sectionName,
    String className,
    String organizationName,
    String role,
  ) async {
    try {
      final users = await User.db.find(
        session,
        where: (t) =>
            t.sectionName.equals(sectionName) &
            t.className.equals(className) &
            t.organizationName.equals(organizationName) &
            t.role.equals(UserRole.values.firstWhere((e) => e.name == role)),
      );
      return users;
    } catch (e, st) {
      print('Error filtering users: $e\n$st');
      return [];
    }
  }

  /// Delete a user by id.
  Future<bool> deleteUser(Session session, int id) async {
    var user = await User.db.findById(session, id);
    if (user == null) return false;
    await User.db.deleteRow(session, user);
    return true;
  }

  /// Marks the user's password as created by setting isPasswordCreated to true.
/// This method retrieves the user record for the given [userId] and updates
/// the isPasswordCreated flag without altering the existing password.
Future<User?> updateInitialPassword(Session session, int userId) async {
  try {
    // Retrieve the user record by ID.
    final user = await User.db.findById(session, userId);
    if (user == null) {
      print('No user found with id: $userId');
      return null;
    }
    
    // Update only the isPasswordCreated flag to true.
    final updatedUser = user.copyWith(
      isPasswordCreated: true,
    );
    
    // Save the updated user record.
    final updatedUsers = await User.db.update(session, [updatedUser]);
    return updatedUsers.isNotEmpty ? updatedUsers.first : null;
  } catch (e, st) {
    print('Error updating isPasswordCreated for user $userId: $e\n$st');
    return null;
  }
}

Future<List<User>> searchUsers(
  Session session,
  String className,
  String sectionName,
  String organizationName,
  String query,
) async {
  try {
    final lowerQuery = query.toLowerCase();
    final users = await User.db.find(
      session,
      where: (t) =>
          t.organizationName.equals(organizationName) &
          t.className.equals(className) &
          t.sectionName.equals(sectionName) &
          (
            t.fullName.ilike('%$lowerQuery%') |
            t.rollNumber.ilike('%$lowerQuery%')
          ),
    );
    return users;
  } catch (e, st) {
    print('Error searching users with query "$query": $e\n$st');
    return [];
  }
}

}
