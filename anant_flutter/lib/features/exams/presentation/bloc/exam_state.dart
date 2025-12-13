import 'package:equatable/equatable.dart';
import '../../domain/entities/exam.dart';

abstract class ExamState extends Equatable {
  const ExamState();
  
  @override
  List<Object> get props => [];
}

class ExamInitial extends ExamState {}

class ExamLoading extends ExamState {}

class ExamLoaded extends ExamState {
  final List<Exam> exams;

  const ExamLoaded(this.exams);

  @override
  List<Object> get props => [exams];
}

class ExamError extends ExamState {
  final String message;

  const ExamError(this.message);

  @override
  List<Object> get props => [message];
}
