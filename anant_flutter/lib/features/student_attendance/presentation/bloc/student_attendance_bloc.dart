import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_student_attendance.dart';
import 'student_attendance_event.dart';
import 'student_attendance_state.dart';

class StudentAttendanceBloc extends Bloc<StudentAttendanceEvent, StudentAttendanceState> {
  final GetStudentAttendance getStudentAttendance;

  StudentAttendanceBloc({required this.getStudentAttendance}) : super(StudentAttendanceInitial()) {
    on<LoadStudentAttendance>(_onLoadStudentAttendance);
  }

  Future<void> _onLoadStudentAttendance(
    LoadStudentAttendance event,
    Emitter<StudentAttendanceState> emit,
  ) async {
    emit(StudentAttendanceLoading());
    try {
      final attendance = await getStudentAttendance();
      emit(StudentAttendanceLoaded(attendance));
    } catch (e) {
      emit(StudentAttendanceError(e.toString()));
    }
  }
}
