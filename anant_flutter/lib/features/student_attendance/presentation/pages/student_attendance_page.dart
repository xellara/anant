import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:anant_flutter/common/widgets/responsive_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anant_flutter/config/role_theme.dart';
import '../../domain/entities/student_attendance_summary.dart';
import '../../data/repositories/student_attendance_repository_impl.dart';
import '../../domain/usecases/get_student_attendance.dart';
import '../bloc/student_attendance_bloc.dart';
import '../bloc/student_attendance_event.dart';
import '../bloc/student_attendance_state.dart';


class StudentAttendancePage extends StatelessWidget {
  final String? studentId;

  const StudentAttendancePage({super.key, this.studentId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentAttendanceBloc(
        getStudentAttendance: GetStudentAttendance(StudentAttendanceRepositoryImpl()),
      )..add(LoadStudentAttendance(studentId: studentId)),
      child: const StudentAttendanceView(),
    );
  }
}

class StudentAttendanceView extends StatelessWidget {
  const StudentAttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: !kIsWeb,
        title: const Text('Attendance'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(context).extension<AppGradients>()?.primaryGradient,
          ),
        ),
      ),
      body: BlocBuilder<StudentAttendanceBloc, StudentAttendanceState>(
        builder: (context, state) {
          if (state is StudentAttendanceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StudentAttendanceError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is StudentAttendanceLoaded) {
            if (state.attendance.isEmpty) {
              return const Center(child: Text('No information available'));
            }
            return ResponsiveLayout(
              mobileBody: _buildContent(context, state.attendance),
              tabletBody: _buildWideContent(context, state.attendance, isTablet: true),
              desktopBody: _buildWideContent(context, state.attendance, isTablet: false),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<SubjectAttendance> attendance) {
    final summary = _calculateSummary(attendance);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          _buildSummaryCard(context, summary),
          const SizedBox(height: 30),
          _buildSubjectListHeader(attendance.length),
          const SizedBox(height: 16),
          ...attendance.map((subject) => _buildSubjectRow(context, subject)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildWideContent(BuildContext context, List<SubjectAttendance> attendance, {required bool isTablet}) {
    final summary = _calculateSummary(attendance);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 380,
            child: SingleChildScrollView(
              child: _buildSummaryCard(context, summary),
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildSubjectListHeader(attendance.length),
                  const SizedBox(height: 24),
                  if (isTablet)
                    Column(
                      children: attendance.map((subject) => _buildSubjectRow(context, subject)).toList(),
                    )
                  else
                    Align(
                      alignment: Alignment.topLeft,
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.start,
                        children: attendance.map((subject) => SizedBox(
                          width: 350,
                          child: _buildSubjectRow(context, subject, margin: EdgeInsets.zero)
                        )).toList(),
                      ),
                    ),
                   const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _calculateSummary(List<SubjectAttendance> attendance) {
    int totalSessions = 0;
    int totalPresent = 0;
    
    for (var subject in attendance) {
      totalSessions += (subject.presentCount + subject.absentCount);
      totalPresent += subject.presentCount;
    }
    
    double overallPercentage = totalSessions > 0 ? (totalPresent / totalSessions) * 100 : 0.0;
    Color overallColor = _getAttendanceColor(overallPercentage);

    return {
      'totalSessions': totalSessions,
      'totalPresent': totalPresent,
      'overallPercentage': overallPercentage,
      'overallColor': overallColor,
    };
  }

  Widget _buildSummaryCard(BuildContext context, Map<String, dynamic> summary) {
    final double overallPercentage = summary['overallPercentage'];
    final Color overallColor = summary['overallColor'];
    final int totalSessions = summary['totalSessions'];
    final int totalPresent = summary['totalPresent'];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: Theme.of(context).extension<AppGradients>()?.cardGradient,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overall Result',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Academic Year 2024-25',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: overallColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  overallPercentage >= 75 ? 'Good' : (overallPercentage >= 60 ? 'Average' : 'Low'),
                  style: TextStyle(
                    color: overallColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: overallPercentage / 100),
            duration: const Duration(seconds: 2),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: CircularProgressIndicator(
                      value: value,
                      strokeWidth: 15,
                      backgroundColor: const Color(0xFFF0F3F5),
                      valueColor: AlwaysStoppedAnimation<Color>(overallColor),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '${(value * 100).toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          color: overallColor,
                          letterSpacing: -1,
                        ),
                      ),
                      Text(
                        'Present',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatPill('Total Classes', '$totalSessions', const Color(0xFF455A64)),
              Container(height: 40, width: 1, color: Colors.grey[200]),
              _buildStatPill('Present', '$totalPresent', const Color(0xFF00C853)),
              Container(height: 40, width: 1, color: Colors.grey[200]),
              _buildStatPill('Absent', '${totalSessions - totalPresent}', const Color(0xFFEF4444)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectListHeader(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          const Text(
            'Subject Attendance',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const Spacer(),
          Text(
            '$count Subjects',
            style: TextStyle(
              color: Colors.grey[500],
              fontWeight: FontWeight.w600,
              fontSize: 14
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatPill(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectRow(BuildContext context, SubjectAttendance subject, {EdgeInsetsGeometry? margin}) {
    final int total = subject.presentCount + subject.absentCount;
    final double percentage = subject.percentage; 
    final Color color = _getAttendanceColor(percentage);
    
    // Generate a consistent pastel color for background based on Subject Name
    final int hash = subject.subjectName.codeUnits.fold(0, (sum, char) => sum + char);
    final List<Color> bgColors = [
      const Color(0xFFE3F2FD), // Blue
      const Color(0xFFF3E5F5), // Purple
      const Color(0xFFE0F2F1), // Teal
      const Color(0xFFFFF3E0), // Orange
      const Color(0xFFFFEBEE), // Red
      const Color(0xFFE8EAF6), // Indigo
    ];
    final Color iconBgColor = bgColors[hash % bgColors.length];
    final Color iconColor = [
      Colors.blue[700]!,
      Colors.purple[700]!,
      Colors.teal[700]!,
      Colors.orange[800]!,
      Colors.red[700]!,
      Colors.indigo[700]!,
    ][hash % bgColors.length];

    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubjectDetailPage(subject: subject),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subject Icon/Color
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      subject.subjectName.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: iconColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  subject.subjectName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3142),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.person_outline_rounded, size: 14, color: Colors.grey[500]),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        subject.teacherName,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${percentage.toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: total > 0 ? (subject.presentCount / total) : 0),
                        duration: const Duration(seconds: 1, milliseconds: 500),
                        curve: Curves.easeOutQuart,
                        builder: (context, value, _) {
                           return ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: value,
                              backgroundColor: const Color(0xFFF1F5F9),
                              valueColor: AlwaysStoppedAnimation<Color>(color),
                              minHeight: 8,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                           Container(
                             padding: const EdgeInsets.all(4),
                             decoration: BoxDecoration(color: Colors.green[50], shape: BoxShape.circle),
                             child: Icon(Icons.check, size: 10, color: Colors.green[700]),
                           ),
                           const SizedBox(width: 6),
                           Text(
                            '${subject.presentCount} Present',
                            style: TextStyle(fontSize: 12, color: Colors.green[700], fontWeight: FontWeight.w600),
                           ),
                           const SizedBox(width: 16),
                           Container(
                             padding: const EdgeInsets.all(4),
                             decoration: BoxDecoration(color: Colors.red[50], shape: BoxShape.circle),
                             child: Icon(Icons.close, size: 10, color: Colors.red[700]),
                           ),
                           const SizedBox(width: 6),
                           Text(
                            '${subject.absentCount} Absent',
                            style: TextStyle(fontSize: 12, color: Colors.red[400], fontWeight: FontWeight.w600),
                           ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getAttendanceColor(double percentage) {
    if (percentage >= 75) return const Color(0xFF00C853); // Fresh Green
    if (percentage >= 60) return const Color(0xFFFFAB00); // Amber
    return const Color(0xFFFF3D00); // Deep Orange
  }
}

class SubjectDetailPage extends StatelessWidget {
  final SubjectAttendance subject;

  const SubjectDetailPage({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    // Sort records by date descending
    final sortedRecords = List<AttendanceRecord>.from(subject.records)
      ..sort((a, b) => b.date.compareTo(a.date));

    // Calculate stats for this subject
    final int present = subject.presentCount;
    final int absent = subject.absentCount;
    final int total = present + absent;
    final double percentage = subject.percentage;

    final headerCard = _buildHeaderCard(context, percentage, total, present, absent);
    final historyList = _buildHistoryList(sortedRecords);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(subject.subjectName, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent, 
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ResponsiveLayout(
        mobileBody: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              headerCard,
              const SizedBox(height: 24),
              historyList,
            ],
          ),
        ),
        tabletBody: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: SingleChildScrollView(child: headerCard),
              ),
              const SizedBox(width: 32),
              Expanded(
                flex: 3,
                child: SingleChildScrollView(child: historyList),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, double percentage, int total, int present, int absent) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: percentage >= 75 
              ? [const Color(0xFF00C853), const Color(0xFF69F0AE)] 
              : (percentage >= 60 ? [const Color(0xFFFFAB00), const Color(0xFFFFD740)] : [const Color(0xFFFF3D00), const Color(0xFFFF6E40)]),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (percentage >= 75 ? Colors.green : (percentage >= 60 ? Colors.orange : Colors.red)).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text('Attendance Score', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeaderStat('Total', '$total'),
              _buildHeaderVerticalDivider(),
              _buildHeaderStat('Present', '$present'),
              _buildHeaderVerticalDivider(),
              _buildHeaderStat('Absent', '$absent'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(List<AttendanceRecord> sortedRecords) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              'History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (sortedRecords.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Center(child: Text("No records found", style: TextStyle(color: Colors.grey))),
          ),
        ...sortedRecords.map((record) => _buildHistoryTile(record)),
      ],
    );
  }

  Widget _buildHeaderStat(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderVerticalDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.white24,
    );
  }

  Widget _buildHistoryTile(AttendanceRecord record) {
    final isPresent = record.status == 'Present';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isPresent ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPresent ? Icons.check : Icons.close,
              color: isPresent ? Colors.green : Colors.red,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.date,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '${record.startTime} - ${record.endTime}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isPresent ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isPresent ? 'Present' : 'Absent',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isPresent ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
