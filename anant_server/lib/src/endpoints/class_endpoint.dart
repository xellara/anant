import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';


class ClassesEndpoint extends Endpoint {

  /// Create a new Class linked to an Organization
  Future<Classes> createClasses(Session session, Classes cls) async {
    // Ensure cls.organizationId is set to a valid Organization's id before inserting
    final newClass = await Classes.db.insertRow(session, cls);
    // Invalidate getAllClasseses cache so new class appears immediately
    await session.caches.local.invalidateKey('getAllClasseses');
    return newClass;
  }

  /// Get a Classes by its id
  Future<Classes?> getClasses(Session session, int id) async {
    return await Classes.db.findById(session, id);
  }

  /// Get all Classeses (optionally, could filter by organizationId if needed)
  Future<List<Classes>> getAllClasseses(Session session) async {
    final cacheKey = 'getAllClasseses';
    final cached = await session.caches.local.get(cacheKey);
    if (cached != null) {
      if (cached is ClassListContainer) {
        return cached.classes;
      }
    }

    final classes = await Classes.db.find(session);

    await session.caches.local.put(
      cacheKey,
      ClassListContainer(classes: classes),
      lifetime: Duration(minutes: 60),
    );
    return classes;
  }

  /// Delete a Classes by id
  Future<bool> deleteClasses(Session session, int id) async {
    var cls = await Classes.db.findById(session, id);
    if (cls == null) return false;
    await Classes.db.deleteRow(session, cls);
    // Invalidate cache
    await session.caches.local.invalidateKey('getAllClasseses');
    return true;
  }
}
