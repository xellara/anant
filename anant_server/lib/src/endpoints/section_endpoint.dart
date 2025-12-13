import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';  // imports Section class

class SectionEndpoint extends Endpoint {
  /// Create a new Section under an Organization (organizationId must be set)
  Future<Section> createSection(Session session, Section section) async {
    return await Section.db.insertRow(session, section);
  }

  /// Retrieve a Section by id
  Future<Section?> getSection(Session session, int id) async {
    return await Section.db.findById(session, id);
  }

  /// Retrieve all Sections (or use a filter by organizationId if needed)
  Future<List<Section>> getAllSections(Session session) async {
    return await Section.db.find(session);
  }

  /// Delete a Section by id
  Future<bool> deleteSection(Session session, int id) async {
    var section = await Section.db.findById(session, id);
    if (section == null) return false;
    await Section.db.deleteRow(session, section);
    return true;
  }
}
