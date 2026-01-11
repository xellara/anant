import 'package:anant_flutter/common/widgets/circular_back_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:anant_flutter/common/widgets/responsive_layout.dart';
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
        automaticallyImplyLeading: false,
        leading: const CircularBackButton(),
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
                  Icon(PhosphorIcons.warningCircle(), size: 64, color: Colors.red[300]),
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
                    Icon(PhosphorIcons.calendarX(), size: 64, color: Colors.grey[400]),
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
            
            return ResponsiveLayout(
              mobileBody: _buildExamList(context, state.exams),
              desktopBody: _buildDesktopExamGrid(context, state.exams),
              tabletBody: _buildDesktopExamGrid(context, state.exams, isTablet: true),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildExamList(BuildContext context, List<Exam> exams) {
    // Sort exams by sortedExams
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

  Widget _buildDesktopExamGrid(BuildContext context, List<Exam> exams, {bool isTablet = false}) {
    final sortedExams = List<Exam>.from(exams)
      ..sort((a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA), // Light background for desktop
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!kIsWeb) // If hiding app bar on web, we might need a header here. 
                             // But AppBar is present.
                  const SizedBox.shrink(),
                
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isTablet ? 2 : 3,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      childAspectRatio: 1.8, // Adjust based on card content
                    ),
                    itemCount: sortedExams.length,
                    itemBuilder: (context, index) {
                      return _buildExamCard(context, sortedExams[index], index);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExamCard(BuildContext context, Exam exam, int index) {
    final examDate = DateTime.parse(exam.date);
    final now = DateTime.now();
    final difference = examDate.difference(now).inDays;
    
    // Logic for status
    bool isPast = difference < 0;
    bool isToday = difference == 0;
    bool isUpcoming = difference > 0 && difference <= 7;
    
    Color accentColor;
    String statusLabel;
    IconData statusIcon;

    if (isPast) {
      accentColor = Colors.grey;
      statusLabel = 'Completed';
      statusIcon = PhosphorIcons.checkCircle(PhosphorIconsStyle.fill);
    } else if (isToday) {
      accentColor = const Color(0xFFFF5252);
      statusLabel = 'Today';
      statusIcon = PhosphorIcons.clock(PhosphorIconsStyle.fill);
    } else if (isUpcoming) {
      accentColor = const Color(0xFFFFAB40);
      statusLabel = 'In $difference days';
      statusIcon = PhosphorIcons.hourglass(PhosphorIconsStyle.fill);
    } else {
      accentColor = const Color(0xFF448AFF);
      statusLabel = '$difference days left';
      statusIcon = PhosphorIcons.calendar(PhosphorIconsStyle.fill);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20), // Margin useful for list view
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Decorative right accent
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                   // Date Column
                  Container(
                    width: 70,
                    height: 80,
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: accentColor.withOpacity(0.2)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Text(
                          DateFormat('dd').format(examDate),
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: accentColor,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('MMM').format(examDate).toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: accentColor.withOpacity(0.8),
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  
                  // Details Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center, // Vertically center content
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Container(
                               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                               decoration: BoxDecoration(
                                 color: accentColor,
                                 borderRadius: BorderRadius.circular(20),
                               ),
                               child: Row(
                                 mainAxisSize: MainAxisSize.min,
                                 children: [
                                   Icon(statusIcon, color: Colors.white, size: 10),
                                   const SizedBox(width: 4),
                                   Text(
                                     statusLabel.toUpperCase(),
                                     style: const TextStyle(
                                       color: Colors.white,
                                       fontWeight: FontWeight.bold,
                                       fontSize: 10,
                                       letterSpacing: 0.5,
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                          ],
                        ),
                        const SizedBox(height: 8),
                         Text(
                          exam.subject,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2D3142),
                            decoration: isPast ? TextDecoration.lineThrough : null,
                            decorationColor: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                         Row(
                          children: [
                            Icon(PhosphorIcons.clock(), size: 14, color: Colors.grey[400]),
                            const SizedBox(width: 6),
                            Text(
                              exam.time,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
