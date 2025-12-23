import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

// Endpoint for handling timetable operations
class TimetableEndpoint extends Endpoint {
  
  /// Get timetable for a user (student or teacher)
  Future<List<Map<String, dynamic>>> getTimetable(
    Session session,
    String userId,
    String role,
  ) async {
    try {
      // Fetch user to get details
      final user = await User.db.findFirstRow(session, where: (t) => t.anantId.equals(userId));
      if (user == null) return [];

      List<TimetableEntry> entries = [];

      if (role == 'Teacher' || user.role == UserRole.teacher || user.role == UserRole.admin) {
        // Fetch by teacherId (user's id)
        if (user.id != null) {
          entries = await TimetableEntry.db.find(
            session,
            where: (t) => t.teacherId.equals(user.id!),
          );
        }
      } else {
        // Student: Fetch by classId
        if (user.className != null && user.className!.isNotEmpty) {
           final classObj = await Classes.db.findFirstRow(
             session, 
             where: (t) => t.name.equals(user.className!)
           );
           
           if (classObj != null && classObj.id != null) {
             entries = await TimetableEntry.db.find(
               session,
               where: (t) => t.classId.equals(classObj.id!),
             );
           }
        }
      }

      if (entries.isEmpty) return [];

      // Process entries to desired format
      Map<int, List<Map<String, dynamic>>> daySlots = {};
      final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

      for (var entry in entries) {
        // Fetch Subject Name
        final subject = await Subject.db.findById(session, entry.subjectId);
        String subjectName = subject?.name ?? 'Unknown';

        // Fetch Related Name (Faculty for Student, Class for Teacher)
        String relatedName = 'Unknown';
        if (role == 'Teacher') {
           // For teacher, show Class Name
           final cls = await Classes.db.findById(session, entry.classId);
           relatedName = cls?.name ?? 'Unknown Class';
        } else {
           // For student, show Teacher Name
           final teacher = await User.db.findById(session, entry.teacherId);
           relatedName = teacher?.fullName ?? 'Faculty';
        }

        // Format Time
        final start = entry.startTime;
        final end = start.add(Duration(minutes: entry.durationMinutes));
        
        String fmt(DateTime d) => "${d.hour.toString().padLeft(2,'0')}:${d.minute.toString().padLeft(2,'0')}";
        String timeStr = "${fmt(start)} - ${fmt(end)}";

        // Add to map
        if (!daySlots.containsKey(entry.dayOfWeek)) {
          daySlots[entry.dayOfWeek] = [];
        }

        daySlots[entry.dayOfWeek]!.add({
          'time': timeStr,
          'subject': subjectName,
          role == 'Teacher' ? 'class' : 'faculty': relatedName,
        });
      }

      // Convert map to list
      List<Map<String, dynamic>> result = [];
      for (var dayIdx in daySlots.keys) {
        if (dayIdx >= 1 && dayIdx <= 7) {
          // Sort slots by time
          daySlots[dayIdx]!.sort((a, b) => (a['time'] as String).compareTo(b['time']));
          
          result.add({
            'day': days[dayIdx - 1],
            'slots': daySlots[dayIdx],
          });
        }
      }
      
      // Sort result by day order (Monday first)
      result.sort((a, b) {
        return days.indexOf(a['day']).compareTo(days.indexOf(b['day']));
      });

      return result;

    } catch (e) {
      print('Error fetching timetable: $e');
      return [];
    }
  }

  // Helper methods _getTeacherTimetable and _getStudentTimetable can be removed or kept as fallback
  // removing them to clean up

  
  /// Create or update timetable entry
  Future<bool> upsertTimetableEntry(
    Session session,
    Map<String, dynamic> entry,
  ) async {
    // TODO: Insert/Update in time_table_entry table
    
    return true;
  }
  
  /// Delete timetable entry
  Future<bool> deleteTimetableEntry(
    Session session,
    String entryId,
  ) async {
    // TODO: Delete from database
    
    return true;
  }
  
  /// Get timetable for a specific class
  Future<List<Map<String, dynamic>>> getClassTimetable(
    Session session,
    String classId,
  ) async {
    // TODO: Fetch timetable for entire class
    
    return [];
  }
}
