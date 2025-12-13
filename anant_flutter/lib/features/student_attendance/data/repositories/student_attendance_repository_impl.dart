import 'package:anant_client/anant_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/student_attendance_summary.dart';
import '../../domain/repositories/student_attendance_repository.dart';
import '../../../../main.dart';

class StudentAttendanceRepositoryImpl implements StudentAttendanceRepository {
  @override
  Future<List<SubjectAttendance>> getAttendanceSummary() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String anantId = prefs.getString('userName') ?? '';
    
    List<Attendance> records = await client.attendance.getUserAttendanceRecords(anantId);
    
    Map<String, List<Attendance>> grouped = {};
    for (Attendance record in records) {
      if (record.subjectName != null) {
        grouped.putIfAbsent(record.subjectName!, () => []).add(record);
      }
    }

    List<SubjectAttendance> result = [];
    grouped.forEach((subject, recordList) {
      int present = recordList.where((r) => r.status == 'Present').length;
      int absent = recordList.where((r) => r.status == 'Absent').length;
      
      List<AttendanceRecord> domainRecords = recordList.map((r) => AttendanceRecord(
        date: r.date,
        status: r.status,
        startTime: r.startTime,
        endTime: r.endTime,
      )).toList();

      result.add(SubjectAttendance(
        subjectName: subject,
        presentCount: present,
        absentCount: absent,
        records: domainRecords,
      ));
    });
    
    return result;
  }
}
