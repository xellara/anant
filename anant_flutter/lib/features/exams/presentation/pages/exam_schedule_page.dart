import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/exam.dart';
import '../../data/repositories/exam_repository_impl.dart';
import '../../domain/usecases/get_exam_schedule.dart';
import '../bloc/exam_bloc.dart';
import '../bloc/exam_event.dart';
import '../bloc/exam_state.dart';

class ExamSchedulePage extends StatelessWidget {
  const ExamSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExamBloc(
        getExamSchedule: GetExamSchedule(ExamRepositoryImpl()),
      )..add(LoadExamSchedule()),
      child: const ExamScheduleView(),
    );
  }
}

class ExamScheduleView extends StatelessWidget {
  const ExamScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Schedule'),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<ExamBloc, ExamState>(
        builder: (context, state) {
          if (state is ExamLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExamError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text('Error: ${state.message}'),
                ],
              ),
            );
          } else if (state is ExamLoaded) {
            if (state.exams.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No exams scheduled',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              );
            }
            return _buildExamList(context, state.exams);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildExamList(BuildContext context, List<Exam> exams) {
    // Sort exams by date
    final sortedExams = List<Exam>.from(exams)
      ..sort((a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
            Theme.of(context).colorScheme.surface,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sortedExams.length,
        itemBuilder: (context, index) {
          return _buildExamCard(context, sortedExams[index], index);
        },
      ),
    );
  }

  Widget _buildExamCard(BuildContext context, Exam exam, int index) {
    final examDate = DateTime.parse(exam.date);
    final now = DateTime.now();
    final daysUntil = examDate.difference(now).inDays;
    final isPast = daysUntil < 0;
    final isToday = daysUntil == 0;
    final isUpcoming = daysUntil > 0 && daysUntil <= 7;

    Color statusColor = Colors.grey;
    String statusText = '';
    
    if (isPast) {
      statusColor = Colors.grey;
      statusText = 'Completed';
    } else if (isToday) {
      statusColor = Colors.red;
      statusText = 'Today';
    } else if (isUpcoming) {
      statusColor = Colors.orange;
      statusText = '$daysUntil days left';
    } else {
      statusColor = Colors.blue;
      statusText = '${daysUntil} days left';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isPast ? 1 : 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isToday
            ? BorderSide(color: statusColor, width: 2)
            : BorderSide.none,
      ),
      child: Opacity(
        opacity: isPast ? 0.6 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                isPast ? Colors.grey[100]! : statusColor.withOpacity(0.05),
                Colors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('dd').format(examDate),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  Text(
                    DateFormat('MMM').format(examDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),
            title: Text(
              exam.subject,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    decoration: isPast ? TextDecoration.lineThrough : null,
                  ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(exam.time),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            trailing: Icon(
              isPast ? Icons.check_circle_outline : Icons.event_note,
              color: statusColor,
            ),
          ),
        ),
      ),
    );
  }
}
