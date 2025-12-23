import 'package:anant_flutter/main.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/exam.dart';
import '../../domain/repositories/exam_repository.dart';

class ExamRepositoryImpl implements ExamRepository {
  @override
  Future<List<Exam>> getExamSchedule() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      
      if (userId == null) {
        return [];
      }

      final userData = await client.user.me(userId);
      final anantId = userData?.anantId;
      
      if (anantId == null || anantId.isEmpty) {
        return [];
      }
      
      // Fetch from backend
      // Returns List<Map<String, dynamic>>
      final List<dynamic> serverResponse = await client.exam.getExamSchedule(anantId);
      
      return serverResponse.map((data) {
        if (data is! Map) return null;
        
        // Parse date
        final dtStr = data['date'] as String;
        final dt = DateTime.parse(dtStr);
        final subject = data['subject'] as String;
        
        // Format for UI
        // Domain Exam expects String date "YYYY-MM-DD" and time "HH:mm AM/PM"
        final dateStr = DateFormat('yyyy-MM-dd').format(dt);
        final timeStr = DateFormat('hh:mm a').format(dt);
        
        return Exam(
          subject: subject,
          date: dateStr,
          time: timeStr,
        );
      }).whereType<Exam>().toList(); // Filter out nulls
      
    } catch (e) {
      // In case of error (e.g. endpoint not ready, parsing error)
      // debugPrint('Error fetching exam schedule: $e');
      return [];
    }
  }
}
