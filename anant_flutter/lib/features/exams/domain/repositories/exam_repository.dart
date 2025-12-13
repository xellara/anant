import '../entities/exam.dart';

abstract class ExamRepository {
  Future<List<Exam>> getExamSchedule();
}
