
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class OrganizationService {
  /// Create a new Organization
  static Future<Organization> createOrganization(Session session, Organization org) async {
    return await Organization.db.insertRow(session, org);
  }

  /// Get Organization by ID
  static Future<Organization?> getOrganization(Session session, int id) async {
    return await Organization.db.findById(session, id);
  }

  /// Get All Organizations (Super Admin View)
  static Future<List<Organization>> getAllOrganizations(Session session) async {
    return await Organization.db.find(session);
  }

  /// Update Organization (e.g. Pause service, update details)
  static Future<Organization?> updateOrganization(Session session, Organization org) async {
    return await Organization.db.updateRow(session, org);
  }

  /// Delete Organization
  static Future<bool> deleteOrganization(Session session, int id) async {
    final org = await Organization.db.findById(session, id);
    if (org == null) return false;
    await Organization.db.deleteRow(session, org);
    return true;
  }
}
