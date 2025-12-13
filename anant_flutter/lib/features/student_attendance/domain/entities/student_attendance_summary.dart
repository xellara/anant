import 'package:equatable/equatable.dart';

class AttendanceRecord extends Equatable {
  final String date;
  final String status;
  final String startTime;
  final String endTime;

  const AttendanceRecord({
    required this.date,
    required this.status,
    required this.startTime,
    required this.endTime,
  });

  @override
  List<Object> get props => [date, status, startTime, endTime];
}

class SubjectAttendance extends Equatable {
  final String subjectName;
  final int presentCount;
  final int absentCount;
  final List<AttendanceRecord> records;

  const SubjectAttendance({
    required this.subjectName,
    required this.presentCount,
    required this.absentCount,
    required this.records,
  });

  int get totalClasses => presentCount + absentCount;
  
  double get percentage => totalClasses == 0 ? 0 : (presentCount / totalClasses) * 100;

  @override
  List<Object> get props => [subjectName, presentCount, absentCount, records];
}
