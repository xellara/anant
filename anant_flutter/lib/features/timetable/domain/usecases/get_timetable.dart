import '../entities/timetable_entry.dart';
import '../repositories/timetable_repository.dart';

class GetTimetable {
  final TimetableRepository repository;

  GetTimetable(this.repository);

  Future<List<TimetableSlot>> call() async {
    return await repository.getTimetable();
  }
}
