import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';  // imports generated Organization class

class OrganizationEndpoint extends Endpoint {
  /// Create a new Organization in the database
  Future<Organization> createOrganization(Session session, Organization org) async {
    // Check for uniqueness of organization name
    final existingOrg = await Organization.db.findFirstRow(
      session,
      where: (t) => t.name.equals(org.name),
    );

    if (existingOrg != null) {
      throw Exception('Organization with name "${org.name}" already exists.');
    }

    return await Organization.db.insertRow(session, org);
  }

  /// Retrieve a single Organization by its name
  Future<Organization?> getOrganization(Session session, String organizationName) async {
    return await Organization.db.findFirstRow(
      session,
      where: (t) => t.name.equals(organizationName),
    );
  }

  /// Retrieve all Organizations
  Future<List<Organization>> getAllOrganizations(Session session) async {
    return await Organization.db.find(session);
  }

  /// Delete an Organization by name
  Future<bool> deleteOrganization(Session session, String organizationName) async {
    var org = await Organization.db.findFirstRow(
      session,
      where: (t) => t.name.equals(organizationName),
    );
    if (org == null) return false;
    await Organization.db.deleteRow(session, org);
    return true;
  }
}
