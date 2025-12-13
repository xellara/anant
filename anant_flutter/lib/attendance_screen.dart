import 'package:anant_flutter/common/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:anant_client/anant_client.dart'; // Ensure you import your actual client package.
import 'package:anant_flutter/main.dart';
import 'package:shared_preferences/shared_preferences.dart'; // If required for models or other elements.

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late Future<List<Map<String, dynamic>>> futureAttendanceData;

  @override
  void initState() {
    super.initState();
    futureAttendanceData = fetchGroupedAttendanceData();
  }

  // Fetch all attendance records using the client endpoint and group them by subject.
  Future<List<Map<String, dynamic>>> fetchGroupedAttendanceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String anantId = prefs.getString('userName') ?? '';
    List<Attendance> records = await client.attendance.getUserAttendanceRecords(anantId);
    Map<String, List<Attendance>> grouped = {};
    for (Attendance record in records) {
      if (record.subjectName != null) {
        grouped.putIfAbsent(record.subjectName!, () => []).add(record);
      }
    }

    // Build a summary list for each subject.
    List<Map<String, dynamic>> result = [];
    grouped.forEach((subject, recordList) {
      int present = recordList.where((r) => r.status == 'Present').length;
      int absent = recordList.where((r) => r.status == 'Absent').length;
      result.add({
        'subject': subject,
        'present': present,
        'absent': absent,
        'records': recordList,
      });
    });
    return result;
  }

  // Choose a color based on the attendance percentage.
  Color _getAttendanceColor(int percentage) {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 80) return Colors.orange;
    return Colors.red;
  }

  // Calculate the percentage from a subject’s present/absent counts.
  int _calculatePercentage(Map<String, dynamic> subjectData) {
    int present = subjectData['present'];
    int absent = subjectData['absent'];
    int total = present + absent;
    if (total == 0) return 0;
    return ((present / total) * 100).round();
  }

  // Helper widget to build a statistic column for the summary card.
  Widget _buildStatColumn(String title, int value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$value',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: futureAttendanceData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loader while the data loads.
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          // Display error if any.
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (snapshot.hasData) {
          final attendanceData = snapshot.data!;
          // Calculate overall totals.
          final int totalPresent = attendanceData.fold(
              0, (sum, data) => sum + (data['present'] as int));
          final int totalAbsent = attendanceData.fold(
              0, (sum, data) => sum + (data['absent'] as int));

          return Scaffold(
            appBar: CustomAppBar(title: 'Attendance'),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueGrey.shade50, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Overall attendance summary card.
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatColumn('Total Present', totalPresent),
                              Container(
                                height: 40,
                                width: 1,
                                color: Colors.grey[300],
                              ),
                              _buildStatColumn('Total Absent', totalAbsent),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: attendanceData.length,
                        itemBuilder: (context, index) {
                          final subjectData = attendanceData[index];
                          final int percentage = _calculatePercentage(subjectData);
                          return GestureDetector(
                            onTap: () {
                              // Navigate to the detailed view for the tapped subject.
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SubjectAttendanceDetailPage(
                                    subject: subjectData['subject'],
                                    records: subjectData['records'],
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 6.0),
                              child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 16.0),
                                  child: Row(
                                    children: [
                                      // Custom circular progress indicator.
                                      CustomCircularProgressIndicator(
                                        percentage: percentage,
                                        color: _getAttendanceColor(percentage),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              subjectData['subject'],
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.blueGrey[800],
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              children: [
                                                const Icon(Icons.check_circle,
                                                    color: Colors.green, size: 20),
                                                const SizedBox(width: 4),
                                                Text(
                                                  'Present: ${subjectData['present']}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                const Icon(Icons.cancel,
                                                    color: Colors.red, size: 20),
                                                const SizedBox(width: 4),
                                                Text(
                                                  'Absent: ${subjectData['absent']}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios, color: Colors.blueGrey),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: Text('No data available')),
          );
        }
      },
    );
  }
}

class SubjectAttendanceDetailPage extends StatelessWidget {
  final String subject;
  final List<Attendance> records;

  const SubjectAttendanceDetailPage({
    Key? key,
    required this.subject,
    required this.records,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sort records by date descending.
    records.sort((a, b) {
      // Compare dates as strings in descending order.
      int dateComparison = b.date.compareTo(a.date);
      if (dateComparison != 0) return dateComparison;
      // If the dates are equal, compare the end times in descending order.
      return b.endTime.compareTo(a.endTime);
    });
    return Scaffold(
      appBar: CustomAppBar(title: '$subject Attendance'),
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: ListView.builder(
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = records[index];
            // Determine whether this record is marked as absent.
            final bool isAbsent = record.status.toLowerCase() == 'absent';

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: BorderSide(
                  color: isAbsent ? Colors.red : Colors.green,
                  width: 0.5,
                ),
              ),
              // Set a light background color based on the absence status.
              color: isAbsent ? Colors.red[50] : Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // First row: Date and Status.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Date: ${record.date}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isAbsent ? Colors.red : Colors.green,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            record.status,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isAbsent ? Colors.red : Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Second row: Start and End times.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Start: ${record.startTime}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: isAbsent ? Colors.red : Colors.green,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            'End: ${record.endTime}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: isAbsent ? Colors.red : Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}



class CustomCircularProgressIndicator extends StatelessWidget {
  final int percentage;
  final Color color;
  final double size;

  const CustomCircularProgressIndicator({
    super.key,
    required this.percentage,
    required this.color,
    this.size = 65,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _CircleProgressPainter(
        percentage: percentage,
        color: color,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '$percentage%',
            style: TextStyle(
              fontSize: size * 0.25,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[800],
            ),
          ),
        ),
      ),
    );
  }
}

class _CircleProgressPainter extends CustomPainter {
  final int percentage;
  final Color color;

  _CircleProgressPainter({required this.percentage, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double lineWidth = 8;
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = (size.width - lineWidth) / 2;

    // Draw the background circle.
    final backgroundPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.grey.shade300, Colors.white],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw the progress arc with gradient.
    final progressGradient = SweepGradient(
      startAngle: -math.pi / 2,
      endAngle: 3 * math.pi / 2,
      colors: [color.withOpacity(0.5), color],
    );
    final progressPaint = Paint()
      ..shader =
          progressGradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round;
    double sweepAngle = 2 * math.pi * (percentage / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );

    // Optionally, draw an inner shadow.
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      shadowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircleProgressPainter oldDelegate) {
    return oldDelegate.percentage != percentage || oldDelegate.color != color;
  }
}
