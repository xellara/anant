import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class ExamEndpoint extends Endpoint {
  
  /// Get exam schedule with subject details
  Future<List<Map<String, dynamic>>> getExamSchedule(Session session, String userId) async {
    try {
      // 1. Get User
      final user = await User.db.findFirstRow(
        session, 
        where: (t) => t.anantId.equals(userId)
      );
      
      if (user == null || user.className == null) return [];
      
      // 2. Get Class ID
      final classObj = await Classes.db.findFirstRow(
        session, 
        where: (t) => t.name.equals(user.className!)
      );
      
      if (classObj == null || classObj.id == null) return [];

      // 3. Get Exams
      final exams = await Exam.db.find(
        session,
        where: (t) => t.classId.equals(classObj.id!),
        orderBy: (t) => t.date,
      );

      // 4. Enrich with Subject Names
      List<Map<String, dynamic>> result = [];
      for (var exam in exams) {
        final subject = await Subject.db.findById(session, exam.subjectId);
        
        result.add({
          'subject': subject?.name ?? 'Unknown Subject',
          'examName': exam.name,
          'date': exam.date.toIso8601String(), // Send full ISO string
        });
      }
      
      return result;
      
    } catch (e) {
      print('Error fetching exams: $e');
      return [];
    }
  }
}
