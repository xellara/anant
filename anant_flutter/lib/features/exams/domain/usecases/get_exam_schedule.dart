import '../entities/exam.dart';
import '../repositories/exam_repository.dart';

class GetExamSchedule {
  final ExamRepository repository;

  GetExamSchedule(this.repository);

  Future<List<Exam>> call() async {
    return await repository.getExamSchedule();
  }
}
