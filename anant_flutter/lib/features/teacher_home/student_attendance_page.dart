import 'package:anant_flutter/common/widgets/custom_button.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:anant_flutter/common/widgets/custom_appbar.dart';
import 'dart:math' as math;
import 'package:anant_client/anant_client.dart'; // Ensure you import your actual client package.
import 'package:anant_flutter/main.dart';
import 'package:shared_preferences/shared_preferences.dart'; // If required for models or other elements.

class StudentAttendancePage extends StatefulWidget {
  const StudentAttendancePage({super.key});

  @override
  State<StudentAttendancePage> createState() => _StudentAttendancePageState();
}

class _StudentAttendancePageState extends State<StudentAttendancePage> {
  String? selectedClassAndSection;
  User? userData;
  String searchText = ''; // Holds the search query.
  List<User> searchResults = [];
  User? selectedUser;

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('userId');
      // Fetch subjects and organization data from the backend.
      userData = await client.user.me(userId ?? 0);
      setState(() {
        // No pre-selection so that the hint text is shown.
      });
    } catch (e) {
      print('Error loading subjects: $e');
    }
  }

  /// Searches for users using filters and updates the search results list.
  Future<void> _searchUsers(String query) async {
    // When query or necessary filters are missing, reset search results while keeping selected user intact.
    if (query.isEmpty ||
        selectedClassAndSection == null ||
        userData?.organizationName == null) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    try {
      // Fetch filtered users based on the search query.
      List<User> results = await client.user.searchUsers(
        selectedClassAndSection!.substring(
            0, selectedClassAndSection!.length - 1),
        selectedClassAndSection!
            .substring(selectedClassAndSection!.length - 1),
        userData!.organizationName,
        query,
      );
      setState(() {
        searchResults = results;
      });
    } catch (e) {
      print('Error searching users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the border color for the dropdown based on search and selection.
    final dropdownBorderColor =
        (searchText.isNotEmpty && selectedClassAndSection == null)
            ? Colors.red
            : const Color(0xFFD0D5DD);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Student Attendance',
        ),
        body: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dropdown for selecting Class & Section.
                Container(
                  padding: EdgeInsets.zero,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      value: selectedClassAndSection,
                      isExpanded: true,
                      hint: const Text(
                        'Class & Section',
                        style: TextStyle(fontSize: 14),
                      ),
                      items: (userData?.classAndSectionTeaching ?? [])
                              .map(
                                (cls) => DropdownMenuItem<String>(
                                  value: cls,
                                  child: Text(
                                    cls,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedClassAndSection = value;
                        });
                        // Re-run the search if there's an active query.
                        if (searchText.isNotEmpty) {
                          _searchUsers(searchText);
                        }
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: dropdownBorderColor),
                        ),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 300,
                        padding: const EdgeInsets.all(8),
                        offset: const Offset(0, -10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        padding: EdgeInsets.all(8),
                        height: 40,
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            size: 24,
                            color: Color(0xFF41419B),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Search Text Field.
                SizedBox(
                  height: 44,
                  child: TextField(
                    cursorWidth: 2.0,  // Sets the width of the cursor.
                  cursorHeight:15.0, 
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                      _searchUsers(value);
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      labelText: 'Search by name or roll number',
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide:
                            const BorderSide(color: Color(0xFFD0D5DD)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide:
                            const BorderSide(color: Color(0xFFD0D5DD)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide:
                            const BorderSide(color: Color(0xFFD0D5DD)),
                      ),
                      
                    ),
                  ),
                ),
                // Display search results in a container mimicking the dropdown style.
                if (searchResults.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFFD0D5DD)),
                    ),
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                          final user = searchResults[index];
                          return GestureDetector(
                          onTap: () {
                            setState(() {
                            selectedUser = user;
                            // Clear the search results but keep searchText unchanged.
                            searchResults = [];
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                            color: const Color(0xFFEFF4FF),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFB6C8E2)),
                            ),
                            child: Row(
                            children: [
                              Expanded(
                              child: Text(
                                '${user.fullName ?? ''} (${user.rollNumber ?? 'N/A'})',
                                style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF1D3557),
                                fontWeight: FontWeight.w500,
                                ),
                              ),
                              ),
                              const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Color(0xFF1D3557),
                              ),
                            ],
                            ),
                          ),
                          );
                      },
                    ),
                  ),
                const SizedBox(height: 20),
                // Display the selected user's details, if any.
                if (selectedUser != null)
                  Container(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF4FF),
                    border: Border.all(color: const Color(0xFFB6C8E2)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                      child: Text(
                        '${selectedUser!.fullName} (${selectedUser!.rollNumber ?? ''})',
                        style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1D3557),
                        fontWeight: FontWeight.w500,
                        ),
                      ),
                      ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                      setState(() {
                        selectedUser = null;
                      });
                      },
                      child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Color(0xFFB00020),
                      ),
                    ),
                    ],
                  ),
                  ),
                const SizedBox(height: 50),
                  CustomButton(
                    onPressed: (){
                    if (selectedUser != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AttendanceScreen(user: selectedUser!),
                        ),
                      );
                    } else {
                      // Show a message if no user is selected.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a student')),
                      );
                    }
                  }, label: 'View Attendance'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}








class AttendanceScreen extends StatefulWidget {
  final User user;
  const AttendanceScreen({super.key, required this.user});

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
    List<Attendance> records = await client.attendance.getUserAttendanceRecords(widget.user.anantId!);
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
            appBar: CustomAppBar(title: '${widget.user.fullName} Attendance'),
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
