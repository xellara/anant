import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class SettingsEndpoint extends Endpoint {
  
  /// Get settings for the user's organization.
  Future<OrganizationSettings?> getSettings(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      return null;
    }
    final userId = authInfo.userId;

    // Fetch the full User record to get the organizationName
    final fullUser = await User.db.findById(session, userId);
    if (fullUser == null) return null;

    final settings = await OrganizationSettings.db.findFirstRow(
      session,
      where: (t) => t.organizationName.equals(fullUser.organizationName),
    );
    
    return settings;
  }

  /// Update settings (Admin/Principal only)
  Future<void> updateSettings(Session session, List<String> enabledModules) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }
    final userId = authInfo.userId;
    
    final fullUser = await User.db.findById(session, userId);
    if (fullUser == null) throw Exception('User not found');

    // Check if admin or principal
    if (fullUser.role != UserRole.admin && fullUser.role != UserRole.principal) {
       throw Exception('Not authorized');
    }

    var settings = await OrganizationSettings.db.findFirstRow(
      session,
      where: (t) => t.organizationName.equals(fullUser.organizationName),
    );

    if (settings == null) {
      settings = OrganizationSettings(
        organizationName: fullUser.organizationName,
        enabledModules: enabledModules,
      );
      await OrganizationSettings.db.insertRow(session, settings);
    } else {
      settings.enabledModules = enabledModules;
      await OrganizationSettings.db.updateRow(session, settings);
    }
  }
}
