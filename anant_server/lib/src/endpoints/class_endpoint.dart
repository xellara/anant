import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';  // imports generated Classes class (e.g., SchoolClass if renamed)

class ClassesEndpoint extends Endpoint {
  /// Create a new Class linked to an Organization
  Future<Classes> createClasses(Session session, Classes cls) async {
    // Ensure cls.organizationId is set to a valid Organization's id before inserting
    return await Classes.db.insertRow(session, cls);
  }

  /// Get a Classes by its id
  Future<Classes?> getClasses(Session session, int id) async {
    return await Classes.db.findById(session, id);
  }

  /// Get all Classeses (optionally, could filter by organizationId if needed)
  Future<List<Classes>> getAllClasseses(Session session) async {
    return await Classes.db.find(session);
  }

  /// Delete a Classes by id
  Future<bool> deleteClasses(Session session, int id) async {
    var cls = await Classes.db.findById(session, id);
    if (cls == null) return false;
    await Classes.db.deleteRow(session, cls);
    return true;
  }
}
