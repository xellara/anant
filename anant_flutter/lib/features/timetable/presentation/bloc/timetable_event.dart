import 'package:equatable/equatable.dart';

abstract class TimetableEvent extends Equatable {
  const TimetableEvent();

  @override
  List<Object> get props => [];
}

class LoadTimetable extends TimetableEvent {
  final String? role;

  const LoadTimetable({this.role});

  @override
  List<Object> get props => [role ?? ''];
}
