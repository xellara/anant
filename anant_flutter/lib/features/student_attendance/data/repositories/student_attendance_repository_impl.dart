import 'package:anant_client/anant_client.dart';
import 'package:anant_flutter/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/student_attendance_summary.dart';
import '../../domain/repositories/student_attendance_repository.dart';

class StudentAttendanceRepositoryImpl implements StudentAttendanceRepository {
  @override
  Future<List<SubjectAttendance>> getAttendanceSummary({String? studentId}) async {
    try {
      String? targetAnantId = studentId;

      // If no studentId provided, fetch for current logged-in user
      if (targetAnantId == null) {
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getInt('userId');
        if (userId != null) {
          final user = await client.user.me(userId);
          targetAnantId = user?.anantId;
        }
      }

      if (targetAnantId == null || targetAnantId.isEmpty) {
        return [];
      }

      // Fetch from backend
      final attendanceList = await client.attendance.getUserAttendanceRecords(targetAnantId);

      // Group by subject
      final Map<String, List<Attendance>> grouped = {};
      
      for (var record in attendanceList) {
        final subject = record.subjectName ?? 'Unknown Subject';
        if (!grouped.containsKey(subject)) {
          grouped[subject] = [];
        }
        grouped[subject]!.add(record);
      }

      // Convert to domain entities
      return grouped.entries.map((entry) {
        final subjectName = entry.key;
        final records = entry.value;
        
        // Count stats
        final presentCount = records.where((r) => r.status.toLowerCase() == 'present').length;
        final absentCount = records.where((r) => r.status.toLowerCase() == 'absent').length;
        
        // Map records
        final domainRecords = records.map((r) => AttendanceRecord(
          date: r.date,
          status: r.status,
          startTime: r.startTime,
          endTime: r.endTime,
        )).toList();

        // Sort records by date descending (optional but good for UI)
        domainRecords.sort((a, b) => b.date.compareTo(a.date));

        return SubjectAttendance(
          subjectName: subjectName,
          teacherName: 'Faculty', // We don't have teacher name directly in attendance record yet
          presentCount: presentCount,
          absentCount: absentCount,
          records: domainRecords,
        );
      }).toList();

    } catch (e) {
      // Return empty list or rethrow depending on error handling strategy
      // For now, let's log and return empty to avoid crashing UI completely
      // debugPrint('Error fetching attendance: $e'); // debugPrint needs flutter import
      return []; 
    }
  }
}


