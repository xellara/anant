import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_timetable.dart';
import 'timetable_event.dart';
import 'timetable_state.dart';

class TimetableBloc extends Bloc<TimetableEvent, TimetableState> {
  final GetTimetable getTimetable;

  TimetableBloc({required this.getTimetable}) : super(TimetableInitial()) {
    on<LoadTimetable>(_onLoadTimetable);
  }

  Future<void> _onLoadTimetable(
    LoadTimetable event,
    Emitter<TimetableState> emit,
  ) async {
    emit(TimetableLoading());
    try {
      final timetable = await getTimetable();
      emit(TimetableLoaded(timetable));
    } catch (e) {
      emit(TimetableError(e.toString()));
    }
  }
}
