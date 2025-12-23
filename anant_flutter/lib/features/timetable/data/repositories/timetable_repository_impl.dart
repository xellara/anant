import 'package:anant_flutter/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/timetable_entry.dart';
import '../../domain/repositories/timetable_repository.dart';

class TimetableRepositoryImpl implements TimetableRepository {
  @override
  Future<List<TimetableSlot>> getTimetable({String? role}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      
      if (userId == null) {
        // If no user logged in, return empty or retry?
        return [];
      }

      final userData = await client.user.me(userId);
      final anantId = userData?.anantId;
      
      if (anantId == null || anantId.isEmpty) {
        return [];
      }

      final fetchedRole = role ?? 'Student';
      
      // Fetch from backend
      // Note: Serverpod returns List<Map<String, dynamic>>
      final List<dynamic> serverResponse = await client.timetable.getTimetable(anantId, fetchedRole);

      // Transform "Day->Slots" to "Time->Days" (Pivot)
      Set<String> timeStrings = {};
      Map<String, Map<String, _SlotInfo>> pivotedData = {};

      for (var dayItem in serverResponse) {
        if (dayItem is! Map) continue;
        final dayName = dayItem['day'] as String;
        final slots = dayItem['slots'] as List;

        for (var slot in slots) {
          if (slot is! Map) continue;
          final time = slot['time'] as String;
          final subject = slot['subject'] as String;
          // For student it is 'faculty', for teacher it is 'class'
          final related = (slot['faculty'] ?? slot['class'] ?? '') as String;

          timeStrings.add(time);

          if (!pivotedData.containsKey(time)) {
            pivotedData[time] = {};
          }
          pivotedData[time]![dayName] = _SlotInfo(subject, related);
        }
      }

      // Sort times
      final sortedTimes = timeStrings.toList()..sort();

      return sortedTimes.map((timeStr) {
        final parts = timeStr.split(' - ');
        final start = parts.isNotEmpty ? parts[0] : '';
        final end = parts.length > 1 ? parts[1] : '';

        final dayMap = pivotedData[timeStr] ?? {};
        Map<String, ClassSession> weekSchedule = {};

        for (var day in dayMap.keys) {
          final info = dayMap[day]!;
          weekSchedule[day] = ClassSession(
            subject: info.subject,
            faculty: info.relatedInfo,
          );
        }

        return TimetableSlot(
          startTime: start,
          endTime: end,
          showTeacher: fetchedRole != 'Teacher',
          weekSchedule: weekSchedule,
        );
      }).toList();

    } catch (e) {
      // In case of error, return empty list or handle gracefully
      // debugPrint('Timetable fetch error: $e');
      return [];
    }
  }
}

class _SlotInfo {
  final String subject;
  final String relatedInfo;
  _SlotInfo(this.subject, this.relatedInfo);
}

