import 'package:anant_flutter/features/exams/domain/entities/exam.dart';
import 'package:anant_flutter/features/exams/domain/usecases/get_exam_schedule.dart';
import 'package:anant_flutter/features/exams/presentation/bloc/exam_bloc.dart';
import 'package:anant_flutter/features/exams/presentation/bloc/exam_event.dart';
import 'package:anant_flutter/features/exams/presentation/bloc/exam_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetExamSchedule extends Mock implements GetExamSchedule {}

void main() {
  late ExamBloc examBloc;
  late MockGetExamSchedule mockGetExamSchedule;

  setUp(() {
    mockGetExamSchedule = MockGetExamSchedule();
    examBloc = ExamBloc(getExamSchedule: mockGetExamSchedule);
  });

  tearDown(() {
    examBloc.close();
  });

  final tExams = [
    const Exam(subject: 'Mathematics', date: '2025-04-01', time: '09:00 AM'),
  ];

  test('initial state should be ExamInitial', () {
    expect(examBloc.state, equals(ExamInitial()));
  });

  blocTest<ExamBloc, ExamState>(
    'emits [ExamLoading, ExamLoaded] when data is gotten successfully',
    build: () {
      when(() => mockGetExamSchedule()).thenAnswer((_) async => tExams);
      return examBloc;
    },
    act: (bloc) => bloc.add(LoadExamSchedule()),
    expect: () => [
      ExamLoading(),
      ExamLoaded(tExams),
    ],
    verify: (_) {
      verify(() => mockGetExamSchedule()).called(1);
    },
  );

  blocTest<ExamBloc, ExamState>(
    'emits [ExamLoading, ExamError] when getting data fails',
    build: () {
      when(() => mockGetExamSchedule()).thenThrow(Exception('Failed to load'));
      return examBloc;
    },
    act: (bloc) => bloc.add(LoadExamSchedule()),
    expect: () => [
      ExamLoading(),
      const ExamError('Exception: Failed to load'),
    ],
  );
}
