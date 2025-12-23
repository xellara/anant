import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_student_attendance.dart';
import 'student_attendance_event.dart';
import 'student_attendance_state.dart';
import 'package:anant_flutter/main.dart'; // for client
import 'package:anant_client/anant_client.dart'; // for types
import 'dart:async';

class StudentAttendanceBloc extends Bloc<StudentAttendanceEvent, StudentAttendanceState> {
  final GetStudentAttendance getStudentAttendance;
  StreamSubscription? _subscription;
  String? _subscribedStudentId;

  StudentAttendanceBloc({required this.getStudentAttendance}) : super(StudentAttendanceInitial()) {
    on<LoadStudentAttendance>(_onLoadStudentAttendance);
  }

  Future<void> _onLoadStudentAttendance(
    LoadStudentAttendance event,
    Emitter<StudentAttendanceState> emit,
  ) async {
    emit(StudentAttendanceLoading());
    
    // Subscribe to real-time updates
    if (event.studentId != null && _subscribedStudentId != event.studentId) {
      await _subscription?.cancel();
      _subscribedStudentId = event.studentId;
      try {
        await client.openStreamingConnection();
        _subscription = client.attendance.receiveAttendanceStream(event.studentId!).listen((_) {
          add(LoadStudentAttendance(studentId: event.studentId));
        });
      } catch (e) {
        // Ignore real-time setup errors
      }
    }

    try {
      final attendance = await getStudentAttendance(studentId: event.studentId);
      emit(StudentAttendanceLoaded(attendance));
    } catch (e) {
      emit(StudentAttendanceError(e.toString()));
    }
  }
  
  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
