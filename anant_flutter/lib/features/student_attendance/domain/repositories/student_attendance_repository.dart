import '../entities/student_attendance_summary.dart';

abstract class StudentAttendanceRepository {
  Future<List<SubjectAttendance>> getAttendanceSummary({String? studentId});
}
