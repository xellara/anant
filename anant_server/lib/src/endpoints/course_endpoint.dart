import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';  // imports Course class

class CourseEndpoint extends Endpoint {
  /// Create a new Course associated with an Organization
  Future<Course> createCourse(Session session, Course course) async {
    return await Course.db.insertRow(session, course);
  }

  /// Get a Course by its id
  Future<Course?> getCourse(Session session, int id) async {
    return await Course.db.findById(session, id);
  }

  /// Get all Courses
  Future<List<Course>> getAllCourses(Session session) async {
    return await Course.db.find(session);
  }

  /// Delete a Course by id
  Future<bool> deleteCourse(Session session, int id) async {
    var course = await Course.db.findById(session, id);
    if (course == null) return false;
    await Course.db.deleteRow(session, course);
    return true;
  }
}
