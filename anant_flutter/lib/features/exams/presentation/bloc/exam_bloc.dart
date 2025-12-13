import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_exam_schedule.dart';
import 'exam_event.dart';
import 'exam_state.dart';

class ExamBloc extends Bloc<ExamEvent, ExamState> {
  final GetExamSchedule getExamSchedule;

  ExamBloc({required this.getExamSchedule}) : super(ExamInitial()) {
    on<LoadExamSchedule>(_onLoadExamSchedule);
  }

  Future<void> _onLoadExamSchedule(
    LoadExamSchedule event,
    Emitter<ExamState> emit,
  ) async {
    emit(ExamLoading());
    try {
      final exams = await getExamSchedule();
      emit(ExamLoaded(exams));
    } catch (e) {
      emit(ExamError(e.toString()));
    }
  }
}
