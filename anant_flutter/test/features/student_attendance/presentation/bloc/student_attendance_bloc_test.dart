import 'package:anant_flutter/features/student_attendance/domain/entities/student_attendance_summary.dart';
import 'package:anant_flutter/features/student_attendance/domain/usecases/get_student_attendance.dart';
import 'package:anant_flutter/features/student_attendance/presentation/bloc/student_attendance_bloc.dart';
import 'package:anant_flutter/features/student_attendance/presentation/bloc/student_attendance_event.dart';
import 'package:anant_flutter/features/student_attendance/presentation/bloc/student_attendance_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetStudentAttendance extends Mock implements GetStudentAttendance {}

void main() {
  late StudentAttendanceBloc studentAttendanceBloc;
  late MockGetStudentAttendance mockGetStudentAttendance;

  setUp(() {
    mockGetStudentAttendance = MockGetStudentAttendance();
    studentAttendanceBloc = StudentAttendanceBloc(getStudentAttendance: mockGetStudentAttendance);
  });

  tearDown(() {
    studentAttendanceBloc.close();
  });

  final tAttendance = [
    const SubjectAttendance(
      subjectName: 'Math',
      presentCount: 10,
      absentCount: 2,
      records: [],
    ),
  ];

  test('initial state should be StudentAttendanceInitial', () {
    expect(studentAttendanceBloc.state, equals(StudentAttendanceInitial()));
  });

  blocTest<StudentAttendanceBloc, StudentAttendanceState>(
    'emits [StudentAttendanceLoading, StudentAttendanceLoaded] when data is gotten successfully',
    build: () {
      when(() => mockGetStudentAttendance()).thenAnswer((_) async => tAttendance);
      return studentAttendanceBloc;
    },
    act: (bloc) => bloc.add(LoadStudentAttendance()),
    expect: () => [
      StudentAttendanceLoading(),
      StudentAttendanceLoaded(tAttendance),
    ],
    verify: (_) {
      verify(() => mockGetStudentAttendance()).called(1);
    },
  );

  blocTest<StudentAttendanceBloc, StudentAttendanceState>(
    'emits [StudentAttendanceLoading, StudentAttendanceError] when getting data fails',
    build: () {
      when(() => mockGetStudentAttendance()).thenThrow(Exception('Failed to load'));
      return studentAttendanceBloc;
    },
    act: (bloc) => bloc.add(LoadStudentAttendance()),
    expect: () => [
      StudentAttendanceLoading(),
      const StudentAttendanceError('Exception: Failed to load'),
    ],
  );
}
