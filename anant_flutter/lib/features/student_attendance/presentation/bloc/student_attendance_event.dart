import 'package:equatable/equatable.dart';

abstract class StudentAttendanceEvent extends Equatable {
  const StudentAttendanceEvent();

  @override
  List<Object> get props => [];
}

class LoadStudentAttendance extends StudentAttendanceEvent {}
