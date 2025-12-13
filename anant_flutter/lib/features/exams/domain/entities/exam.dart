import 'package:equatable/equatable.dart';

class Exam extends Equatable {
  final String subject;
  final String date;
  final String time;

  const Exam({
    required this.subject,
    required this.date,
    required this.time,
  });

  @override
  List<Object> get props => [subject, date, time];
}
