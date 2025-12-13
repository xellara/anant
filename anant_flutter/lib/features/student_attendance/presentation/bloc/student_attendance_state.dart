import 'package:equatable/equatable.dart';
import '../../domain/entities/student_attendance_summary.dart';

abstract class StudentAttendanceState extends Equatable {
  const StudentAttendanceState();
  
  @override
  List<Object> get props => [];
}

class StudentAttendanceInitial extends StudentAttendanceState {}

class StudentAttendanceLoading extends StudentAttendanceState {}

class StudentAttendanceLoaded extends StudentAttendanceState {
  final List<SubjectAttendance> attendance;

  const StudentAttendanceLoaded(this.attendance);

  @override
  List<Object> get props => [attendance];
}

class StudentAttendanceError extends StudentAttendanceState {
  final String message;

  const StudentAttendanceError(this.message);

  @override
  List<Object> get props => [message];
}
