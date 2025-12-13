import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/student_attendance_summary.dart';
import '../../data/repositories/student_attendance_repository_impl.dart';
import '../../domain/usecases/get_student_attendance.dart';
import '../bloc/student_attendance_bloc.dart';
import '../bloc/student_attendance_event.dart';
import '../bloc/student_attendance_state.dart';


class StudentAttendancePage extends StatelessWidget {
  const StudentAttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentAttendanceBloc(
        getStudentAttendance: GetStudentAttendance(StudentAttendanceRepositoryImpl()),
      )..add(LoadStudentAttendance()),
      child: const StudentAttendanceView(),
    );
  }
}

class StudentAttendanceView extends StatelessWidget {
  const StudentAttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Attendance', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF335762).withOpacity(0.9),
                const Color(0xFF335762).withOpacity(0.7),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F7FA), Color(0xFFE4E7EB)],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: BlocBuilder<StudentAttendanceBloc, StudentAttendanceState>(
              builder: (context, state) {
                if (state is StudentAttendanceLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is StudentAttendanceError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else if (state is StudentAttendanceLoaded) {
                  if (state.attendance.isEmpty) {
                    return const Center(child: Text('No attendance records found.'));
                  }
                  return SafeArea(child: _buildAttendanceList(context, state.attendance));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceList(BuildContext context, List<SubjectAttendance> attendance) {
    final totalPresent = attendance.fold(0, (sum, item) => sum + item.presentCount);
    final totalAbsent = attendance.fold(0, (sum, item) => sum + item.absentCount);

    return Column(
      children: [
        _buildSummaryCard(context, totalPresent, totalAbsent),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: attendance.length,
            itemBuilder: (context, index) {
              return _buildSubjectCard(context, attendance[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(BuildContext context, int present, int absent) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF335762).withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(context, 'Present', present, Colors.green, Icons.check_circle_rounded),
          Container(width: 1, height: 50, color: Colors.grey[200]),
          _buildStatItem(context, 'Absent', absent, Colors.redAccent, Icons.cancel_rounded),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, int value, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 12),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectCard(BuildContext context, SubjectAttendance subject) {
    final percentage = subject.percentage.round();
    final color = _getAttendanceColor(percentage);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubjectDetailPage(subject: subject),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                _buildCircularIndicator(percentage, color),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject.subjectName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildMiniStat('Present', subject.presentCount, Colors.green),
                          const SizedBox(width: 16),
                          _buildMiniStat('Absent', subject.absentCount, Colors.redAccent),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: Colors.grey[400], size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, int count, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$label: $count',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCircularIndicator(int percentage, Color color) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        children: [
          Center(
            child: CircularProgressIndicator(
              value: percentage / 100,
              strokeWidth: 6,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              strokeCap: StrokeCap.round,
            ),
          ),
          Center(
            child: Text(
              '$percentage%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getAttendanceColor(int percentage) {
    if (percentage >= 75) return const Color(0xFF10B981); // Emerald Green
    if (percentage >= 60) return const Color(0xFFF59E0B); // Amber
    return const Color(0xFFEF4444); // Red
  }
}

class SubjectDetailPage extends StatelessWidget {
  final SubjectAttendance subject;

  const SubjectDetailPage({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final sortedRecords = List<AttendanceRecord>.from(subject.records)
      ..sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(subject.subjectName, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF335762).withOpacity(0.9),
                const Color(0xFF335762).withOpacity(0.7),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F7FA), Color(0xFFE4E7EB)],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: SafeArea(
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: sortedRecords.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final record = sortedRecords[index];
                  final isPresent = record.status == 'Present';
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: isPresent ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isPresent ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isPresent ? Icons.check_rounded : Icons.close_rounded,
                          color: isPresent ? Colors.green : Colors.red,
                        ),
                      ),
                      title: Text(
                        record.date,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${record.startTime} - ${record.endTime}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isPresent ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          record.status,
                          style: TextStyle(
                            color: isPresent ? Colors.green[700] : Colors.red[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
