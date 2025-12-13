import '../../domain/entities/exam.dart';
import '../../domain/repositories/exam_repository.dart';

class ExamRepositoryImpl implements ExamRepository {
  @override
  Future<List<Exam>> getExamSchedule() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Return hardcoded data for now
    return const [
      Exam(subject: 'Mathematics', date: '2025-04-01', time: '09:00 AM'),
      Exam(subject: 'Physics', date: '2025-04-03', time: '11:00 AM'),
      Exam(subject: 'Chemistry', date: '2025-04-05', time: '10:00 AM'),
      Exam(subject: 'English', date: '2025-04-07', time: '09:00 AM'),
      Exam(subject: 'Computer Science', date: '2025-04-09', time: '02:00 PM'),
    ];
  }
}
