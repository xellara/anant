
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/admin_service.dart';
import '../services/organization_service.dart';

class AdminEndpoint extends Endpoint {
  
  /// Create a new Organization (Super Admin Only)
  Future<Organization> createOrganization(Session session, Organization org) async {
    // Permission check needed here typically. 
    // Assuming for now the client logic handles 'Anant' role check and server trusts it or session has role.
    return await OrganizationService.createOrganization(session, org);
  }

  /// Update Organization details (e.g. Pause service)
  Future<Organization?> updateOrganization(Session session, Organization org) async {
    return await OrganizationService.updateOrganization(session, org);
  }

  /// Get All Organizations (Super Admin View)
  Future<List<Organization>> getAllOrganizations(Session session) async {
    return await OrganizationService.getAllOrganizations(session);
  }

  /// Bulk Import Users from CSV (Pass data as list of Users for now)
  Future<int> bulkImportUsers(Session session, List<User> users) async {
    return await AdminService.bulkImportUsers(session, users);
  }

  /// Reset Password for any user (Super Admin "God Mode")
  Future<bool> resetUserPassword(Session session, int userId, String newPassword) async {
    return await AdminService.resetUserPassword(session, userId, newPassword);
  }

  /// Toggle Organization Status (Pause/Resume)
  Future<Organization?> toggleOrganizationStatus(Session session, int orgId, bool isActive) async {
    return await AdminService.toggleOrganizationStatus(session, orgId, isActive);
  }

  /// Update details of ANY user (Super Admin)
  Future<User?> updateAnyUser(Session session, User user) async {
    return await AdminService.updateAnyUser(session, user);
  }

  /// Delete ANY user (Super Admin)
  Future<bool> deleteAnyUser(Session session, int userId) async {
    return await AdminService.deleteAnyUser(session, userId);
  }
}
