import 'package:equatable/equatable.dart';
import '../../domain/entities/timetable_entry.dart';

abstract class TimetableState extends Equatable {
  const TimetableState();
  
  @override
  List<Object> get props => [];
}

class TimetableInitial extends TimetableState {}

class TimetableLoading extends TimetableState {}

class TimetableLoaded extends TimetableState {
  final List<TimetableSlot> timetable;

  const TimetableLoaded(this.timetable);

  @override
  List<Object> get props => [timetable];
}

class TimetableError extends TimetableState {
  final String message;

  const TimetableError(this.message);

  @override
  List<Object> get props => [message];
}
