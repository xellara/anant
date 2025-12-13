import '../entities/student_attendance_summary.dart';
import '../repositories/student_attendance_repository.dart';

class GetStudentAttendance {
  final StudentAttendanceRepository repository;

  GetStudentAttendance(this.repository);

  Future<List<SubjectAttendance>> call() async {
    return await repository.getAttendanceSummary();
  }
}
