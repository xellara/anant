import '../../domain/entities/timetable_entry.dart';
import '../../domain/repositories/timetable_repository.dart';

class TimetableRepositoryImpl implements TimetableRepository {
  @override
  Future<List<TimetableSlot>> getTimetable() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Return hardcoded data for now (matching the original file)
    return const [
      TimetableSlot(
        startTime: '09:00',
        endTime: '10:00',
        showTeacher: true,
        weekSchedule: {
          'Monday': ClassSession(subject: 'Math', faculty: 'Dr. Smith'),
          'Tuesday': ClassSession(subject: 'English', faculty: 'Ms. Johnson'),
          'Wednesday': ClassSession(subject: 'Science', faculty: 'Dr. Brown'),
          'Thursday': ClassSession(subject: 'History', faculty: 'Mr. Davis'),
          'Friday': ClassSession(subject: 'Art', faculty: 'Mrs. Wilson'),
          'Saturday': ClassSession(subject: 'Physical Ed', faculty: 'Coach Taylor'),
        },
      ),
      TimetableSlot(
        startTime: '10:15',
        endTime: '11:15',
        showTeacher: false,
        weekSchedule: {
          'Monday': ClassSession(subject: 'Physics', faculty: 'Dr. Miller'),
          'Tuesday': ClassSession(subject: 'Chemistry', faculty: 'Dr. Anderson'),
          'Wednesday': ClassSession(subject: 'Biology', faculty: 'Dr. Thomas'),
          'Thursday': ClassSession(subject: 'PE', faculty: 'Coach Moore'),
          'Friday': ClassSession(subject: 'Music', faculty: 'Ms. Martin'),
          'Saturday': ClassSession(subject: 'Drama', faculty: 'Mrs. Thompson'),
        },
      ),
      TimetableSlot(
        startTime: '11:30',
        endTime: '12:30',
        showTeacher: false,
        weekSchedule: {
          'Monday': ClassSession(subject: 'Economics', faculty: 'Dr. Garcia'),
          'Tuesday': ClassSession(subject: 'Computer Sci', faculty: 'Dr. Martinez'),
          'Wednesday': ClassSession(subject: 'Literature', faculty: 'Ms. Robinson'),
          'Thursday': ClassSession(subject: 'Drama', faculty: 'Mrs. Clark'),
          'Friday': ClassSession(subject: 'Geography', faculty: 'Mr. Rodriguez'),
          'Saturday': ClassSession(subject: 'Social Studies', faculty: 'Ms. Lewis'),
        },
      ),
    ];
  }
}
