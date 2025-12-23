import 'package:equatable/equatable.dart';

abstract class StudentAttendanceEvent extends Equatable {
  const StudentAttendanceEvent();

  @override
  List<Object> get props => [];
}

class LoadStudentAttendance extends StudentAttendanceEvent {
  final String? studentId;

  const LoadStudentAttendance({this.studentId});

  @override
  List<Object> get props => [studentId ?? ''];
}
