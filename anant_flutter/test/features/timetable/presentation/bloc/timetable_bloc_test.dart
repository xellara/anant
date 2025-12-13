import 'package:anant_flutter/features/timetable/domain/entities/timetable_entry.dart';
import 'package:anant_flutter/features/timetable/domain/usecases/get_timetable.dart';
import 'package:anant_flutter/features/timetable/presentation/bloc/timetable_bloc.dart';
import 'package:anant_flutter/features/timetable/presentation/bloc/timetable_event.dart';
import 'package:anant_flutter/features/timetable/presentation/bloc/timetable_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetTimetable extends Mock implements GetTimetable {}

void main() {
  late TimetableBloc timetableBloc;
  late MockGetTimetable mockGetTimetable;

  setUp(() {
    mockGetTimetable = MockGetTimetable();
    timetableBloc = TimetableBloc(getTimetable: mockGetTimetable);
  });

  tearDown(() {
    timetableBloc.close();
  });

  final tTimetable = [
    const TimetableSlot(
      startTime: '09:00',
      endTime: '10:00',
      showTeacher: true,
      weekSchedule: {
        'Monday': ClassSession(subject: 'Math', faculty: 'Dr. Smith'),
      },
    ),
  ];

  test('initial state should be TimetableInitial', () {
    expect(timetableBloc.state, equals(TimetableInitial()));
  });

  blocTest<TimetableBloc, TimetableState>(
    'emits [TimetableLoading, TimetableLoaded] when data is gotten successfully',
    build: () {
      when(() => mockGetTimetable()).thenAnswer((_) async => tTimetable);
      return timetableBloc;
    },
    act: (bloc) => bloc.add(LoadTimetable()),
    expect: () => [
      TimetableLoading(),
      TimetableLoaded(tTimetable),
    ],
    verify: (_) {
      verify(() => mockGetTimetable()).called(1);
    },
  );

  blocTest<TimetableBloc, TimetableState>(
    'emits [TimetableLoading, TimetableError] when getting data fails',
    build: () {
      when(() => mockGetTimetable()).thenThrow(Exception('Failed to load'));
      return timetableBloc;
    },
    act: (bloc) => bloc.add(LoadTimetable()),
    expect: () => [
      TimetableLoading(),
      const TimetableError('Exception: Failed to load'),
    ],
  );
}
