import 'package:equatable/equatable.dart';

class ClassSession extends Equatable {
  final String subject;
  final String faculty;

  const ClassSession({required this.subject, required this.faculty});

  @override
  List<Object?> get props => [subject, faculty];
}

class TimetableSlot extends Equatable {
  final String startTime;
  final String endTime;
  final bool showTeacher;
  final Map<String, ClassSession> weekSchedule;

  const TimetableSlot({
    required this.startTime,
    required this.endTime,
    required this.showTeacher,
    required this.weekSchedule,
  });

  @override
  List<Object?> get props => [startTime, endTime, showTeacher, weekSchedule];
}
