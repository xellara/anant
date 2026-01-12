import 'package:anant_client/anant_client.dart';
import 'package:anant_flutter/config/role_theme.dart';
import 'package:anant_flutter/common/widgets/custom_button.dart';
import 'package:anant_flutter/main.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:anant_flutter/common/widgets/responsive_layout.dart';

/// A simple local Student model.
class Student {
  final String name;
  final String rollNumber;
  final String anantId;
  bool isPresent;
  Student({
    required this.name,
    required this.rollNumber,
    required this.anantId,
    this.isPresent = false,
  });
}

class AttendanceInputPage extends StatefulWidget {
  const AttendanceInputPage({super.key});

  @override
  _AttendanceInputPageState createState() => _AttendanceInputPageState();
}

class _AttendanceInputPageState extends State<AttendanceInputPage> {
  // Change type to String so that only the date part is stored.
  String? selectedDate;
  String? selectedSubject;
  String? selectedStartTime;
  String? selectedEndTime;
  String? selectedClassAndSection;
  User? userData;
  final List<String> timeSlots = [
    '07:00 AM',
    '08:00 AM',
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    // Set selectedDate to today's date as a string ("yyyy-MM-dd").
    _loadSubjects();
    final now = DateTime.now();
    selectedDate =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> _loadSubjects() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('userId');
      // Fetch subjects from the backend.
      userData = await client.user.me(userId ?? 0);
      setState(() {
        
      });
    } catch (e) {
      debugPrint('Error loading subjects: $e');
    }
  }

  // Date picker that prevents selecting future dates.
  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    // Convert current selectedDate string back to DateTime for the date picker.
    DateTime initialDate = now;
    if (selectedDate != null) {
      List<String> parts = selectedDate!.split('-');
      if (parts.length == 3) {
        initialDate = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
      }
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now.subtract(const Duration(days: 28)), // Adjust as needed.
      lastDate: now, // No future dates allowed.
    );
    if (picked != null) {
      setState(() {
        // Save only date part as a formatted string.
        selectedDate =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  void navigateToAttendanceDetail() {
    if (selectedDate != null &&
        selectedSubject != null &&
        selectedStartTime != null &&
        selectedEndTime != null &&
        selectedClassAndSection != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AttendanceDetailPage(
            selectedDate: selectedDate!, // Pass the string date.
            selectedSubject: selectedSubject!,
            selectedStartTime: selectedStartTime!,
            selectedEndTime: selectedEndTime!,
            selectedClass: selectedClassAndSection!.substring(0, selectedClassAndSection!.length - 1), // Extract class.
            selectedSection: selectedClassAndSection!.substring(selectedClassAndSection!.length - 1), // Extract section.
            organizationName: userData!.organizationName, // Replace with actual organization name.
            markedByAnantId: userData!.anantId!, // Replace with actual user ID.
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: !kIsWeb,
          title: const Text('Attendance Entry'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: Theme.of(context).extension<AppGradients>()?.primaryGradient,
            ),
          ),
        ),
      body: ResponsiveLayout(
        mobileBody: _buildFormContent(isDesktop: false),
        desktopBody: _buildDesktopLayout(),
        tabletBody: _buildDesktopLayout(),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left Panel: Context/Info
        Expanded(
          flex: 4,
          child: Container(
            decoration: BoxDecoration(
              gradient: Theme.of(context).extension<AppGradients>()?.primaryGradient,
            ),
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.class_rounded, size: 80, color: Colors.white),
                const SizedBox(height: 32),
                const Text(
                  'Record Class\nAttendance',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Select the class details on the right to proceed with marking attendance.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Right Panel: Form
        Expanded(
          flex: 6,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: _buildFormContent(isDesktop: true),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormContent({bool isDesktop = false}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isDesktop) ...[
             const Text(
               'Class Details',
               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
             ),
             const SizedBox(height: 32),
          ],
          // Class & Section dropdown using DropdownButton2.
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
                    .map((cls) => DropdownMenuItem<String>(
                          value: cls,
                          child: Text(cls, style: const TextStyle(fontSize: 14)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedClassAndSection = value;
                  });
                },
                buttonStyleData: ButtonStyleData(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFFD0D5DD)),
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
          const SizedBox(height: 12),
          // Date picker
          Container(
             height: 44,
             decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFFD0D5DD)),
             ),
             child: InkWell(
               onTap: _pickDate,
               child: Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 12.0),
                 child: Row(
                   children: [
                     Expanded(
                       child: Text(
                         selectedDate == null
                             ? 'Select Date'
                             : 'Date: $selectedDate',
                         style: const TextStyle(fontSize: 14),
                       ),
                     ),
                     const Icon(Icons.calendar_today, size: 20, color: Color(0xFF41419B)),
                   ],
                 ),
               ),
             ),
          ),
          const SizedBox(height: 12),
          // Subject dropdown using DropdownButton2.
          Container(
            padding: EdgeInsets.zero,
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                value: selectedSubject,
                isExpanded: true,
                hint: const Text(
                  'Subject',
                  style: TextStyle(fontSize: 14),
                ),
                items: (userData?.subjectTeaching ?? [])
                    .map((subject) => DropdownMenuItem<String>(
                          value: subject,
                          child: Text(subject, style: const TextStyle(fontSize: 14)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSubject = value;
                  });
                },
                buttonStyleData: ButtonStyleData(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFFD0D5DD)),
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
          const SizedBox(height: 12),
          // Time selection row using DropdownButton2.
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.zero,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      value: selectedStartTime,
                      isExpanded: true,
                      hint: const Text(
                        'Start Time',
                        style: TextStyle(fontSize: 14),
                      ),
                      items: timeSlots.map((time) {
                        return DropdownMenuItem<String>(
                          value: time,
                          child: Text(time, style: const TextStyle(fontSize: 14)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedStartTime = value;
                          // Reset end time if it's no longer valid.
                          if (selectedEndTime != null &&
                              timeSlots.indexOf(selectedEndTime!) <= timeSlots.indexOf(selectedStartTime!)) {
                            selectedEndTime = null;
                          }
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFFD0D5DD)),
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
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: EdgeInsets.zero,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      value: selectedEndTime,
                      isExpanded: true,
                      hint: const Text(
                        'End Time',
                        style: TextStyle(fontSize: 14),
                      ),
                      items: (selectedStartTime == null
                              ? timeSlots
                              : timeSlots.where((time) =>
                                  timeSlots.indexOf(time) > timeSlots.indexOf(selectedStartTime!)))
                          .map((time) {
                        return DropdownMenuItem<String>(
                          value: time,
                          child: Text(time, style: const TextStyle(fontSize: 14)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedEndTime = value;
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFFD0D5DD)),
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
              ),
            ],
          ),
          const SizedBox(height: 40),
          CustomButton(onPressed: navigateToAttendanceDetail, label: 'Load Students'),
        ],
      ),
    );
  }
}


/// Page 2: AttendanceDetailPage - loads and displays student data.
/// This page immediately updates a student's attendance on every change.
class AttendanceDetailPage extends StatefulWidget {
  // Change type from DateTime to String to contain only the date.
  final String selectedDate;
  final String selectedSubject;
  final String selectedStartTime;
  final String selectedEndTime;
  final String selectedClass;
  final String selectedSection;
  final String organizationName;
  final String markedByAnantId;

  const AttendanceDetailPage({
    super.key,
    required this.selectedDate,
    required this.selectedSubject,
    required this.selectedStartTime,
    required this.selectedEndTime,
    required this.selectedClass,
    required this.selectedSection,
    required this.organizationName,
    required this.markedByAnantId,
  });

  @override
  _AttendanceDetailPageState createState() => _AttendanceDetailPageState();
}

class _AttendanceDetailPageState extends State<AttendanceDetailPage> {
  List<Student> students = [];

  Future<void> loadStudents() async {
    final sectionName = widget.selectedSection;
    final className = widget.selectedClass;
    var organizationName = widget.organizationName;
    const role = 'student';

    try {
      // Retrieve filtered users from the backend.
      List<User> filteredUsers = await client.user.getFilteredUsers(
        sectionName,
        className,
        organizationName,
        role,
        limit: 100,
      );
      // Convert User objects to local Student objects.
      List<Student> fetchedStudents = filteredUsers.map((user) {
        return Student(
          name: user.fullName ?? '',
          rollNumber: user.rollNumber ?? '',
          anantId: user.anantId ?? '',
        );
      }).toList();

      // Fetch current attendance status if parameters are set.
      List<String> studentIds = fetchedStudents.map((s) => s.anantId).toList();
      fetchedStudents.sort((a, b) => int.tryParse(a.rollNumber)?.compareTo(int.tryParse(b.rollNumber) ?? 0) ?? 0);
      Map<String, String> attendanceStatus = await client.attendance.getFilteredAttendanceStatus(
        studentIds,
        widget.selectedSubject,
        widget.selectedStartTime,
        widget.selectedEndTime,
        sectionName,
        className,
        widget.selectedDate, // The date is now sent as a string (e.g. "2025-04-12")
        organizationName,
      );
      for (var student in fetchedStudents) {
        student.isPresent = (attendanceStatus[student.anantId] == 'Present');
      }

      setState(() {
        students = fetchedStudents;
      });
    } catch (e) {
      debugPrint('Error loading students: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading students')),
      );
    }
  }

  /// Updates a single student's attendance immediately when toggled.
  Future<void> updateAttendanceForStudent(Student student) async {
    final attendance = Attendance(
      studentAnantId: student.anantId,
      date: widget.selectedDate, // Sent as string.
      subjectName: widget.selectedSubject,
      startTime: widget.selectedStartTime,
      endTime: widget.selectedEndTime,
      className: widget.selectedClass,
      sectionName: widget.selectedSection,
      organizationName: widget.organizationName,
      status: student.isPresent ? 'Present' : 'Absent',
      isSubmitted: false,
      markedByAnantId: widget.markedByAnantId, // Replace with actual user ID as needed.
    );

    try {
      await client.attendance.updateSingleAttendance(attendance);
    } catch (e) {
      debugPrint('Error updating attendance for ${student.rollNumber}: $e');
    }
  }

  /// Batch submission (e.g. final submission) of attendance.
  void submitAttendance() async {
    final attendanceList = students.map((student) {
      return Attendance(
        studentAnantId: student.anantId,
        date: widget.selectedDate, // Sent as string.
        subjectName: widget.selectedSubject,
        startTime: widget.selectedStartTime,
        endTime: widget.selectedEndTime,
        className: widget.selectedClass,
        sectionName: widget.selectedSection,
        organizationName: widget.organizationName,
        status: student.isPresent ? 'Present' : 'Absent',
        isSubmitted: false,
        markedByAnantId: widget.markedByAnantId, // Replace with actual user ID as needed.
      );
    }).toList();

    try {
      await client.attendance.submitCompleteAttendance(attendanceList);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Attendance submitted successfully!')),
        );
      }
    } catch (e) {
      debugPrint('Error submitting attendance: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error submitting attendance')),
        );
      }
    }
  }

  /// Toggle all student's attendance.
  void toggleAll(bool value) {
    setState(() {
      for (var student in students) {
        student.isPresent = value;
        updateAttendanceForStudent(student);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  @override
  Widget build(BuildContext context) {
    // Compute if all students are present.
    bool allPresent = students.isNotEmpty && students.every((student) => student.isPresent);
    
    // Stats for desktop
    int presentCount = students.where((s) => s.isPresent).length;
    int absentCount = students.length - presentCount;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !kIsWeb,
        title: const Text('Record Attendance'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(context).extension<AppGradients>()?.primaryGradient,
          ),
        ),
      ),
      body: ResponsiveLayout(
        mobileBody: _buildMobileList(allPresent),
        desktopBody: _buildDesktopLayout(allPresent, presentCount, absentCount),
        tabletBody: _buildDesktopLayout(allPresent, presentCount, absentCount),
      ),
      bottomSheet: (!ResponsiveLayout.isDesktop(context) && students.isNotEmpty)
          ? Padding(
          padding: const EdgeInsets.fromLTRB(30, 12, 30, 20),
          child: CustomButton(
            onPressed: () {
              Navigator.pop(context);
              submitAttendance();
            },
            label: 'Submit Attendance',
          ),
        )
          : null,
    );
  }
  
  Widget _buildDesktopLayout(bool allPresent, int presentCount, int absentCount) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Side: Stats and Info
          Expanded(
            flex: 3,
            child: Column(
              children: [
                _buildStatCard('Total Students', '${students.length}', Colors.blue),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildStatCard('Present', '$presentCount', Colors.green)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildStatCard('Absent', '$absentCount', Colors.red)),
                  ],
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
                    ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Class Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 16),
                      _buildDetailRow('Date', widget.selectedDate),
                      _buildDetailRow('Subject', widget.selectedSubject),
                      _buildDetailRow('Class', '${widget.selectedClass} ${widget.selectedSection}'),
                      _buildDetailRow('Time', '${widget.selectedStartTime} - ${widget.selectedEndTime}'),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          onPressed: () {
                            Navigator.pop(context);
                            submitAttendance();
                          },
                          label: 'Submit Final Attendance',
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Right Side: List
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                 boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
                 ]
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Column(
                    children: [
                      // Header for Desktop List
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        color: Colors.grey[50],
                        child: Row(
                          children: [
                            const Text('Student List', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const Spacer(),
                            Text('Mark All Present', style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                            const SizedBox(width: 8),
                            Switch(
                              value: allPresent,
                              onChanged: (value) => toggleAll(value),
                              activeColor: Colors.green,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _buildStudentTable(),
                      ),
                    ],
                  ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: 14, color: color.withOpacity(0.8), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           SizedBox(width: 80, child: Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 14))),
           Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildMobileList(bool allPresent) {
    final bottomPadding = students.isNotEmpty ? 80.0 : 8.0;
    return ListView(
        padding: EdgeInsets.fromLTRB(12, 8, 12, bottomPadding),
        children: [
          if (students.isNotEmpty)
            SwitchListTile(
              title: Text(!allPresent ? 'Marked all as Absent' : 'Marked all as Present', style: const TextStyle(fontSize: 14)),
              value: allPresent,
              onChanged: (value) => toggleAll(value),
              activeColor: Colors.green,
              inactiveThumbColor: Colors.red,
              inactiveTrackColor: Colors.red.withOpacity(0.4),
              contentPadding: EdgeInsets.zero,
            ),
          const SizedBox(height: 8),
          if (students.isNotEmpty)
            Card(
              elevation: 4,
              shadowColor: Colors.black26, 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _buildStudentTable(),
              ),
            ),
        ],
      );
  }

  Widget _buildStudentTable() {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const {
        0: FixedColumnWidth(70), // Roll No
        1: FlexColumnWidth(),     // Name
        2: FixedColumnWidth(90),  // Toggle
      },
      children: [
        // Header Row
        TableRow(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Text("Roll No", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Text("Name", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Text("Status", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            ),
          ],
        ),
        // Data Rows
        ...students.asMap().entries.map((entry) {
          final int index = entry.key;
          final Student student = entry.value;
          final bool isEven = index % 2 == 0;
          return TableRow(
            decoration: BoxDecoration(
              color: isEven ? Colors.white : Colors.grey.withOpacity(0.05),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Text(student.rollNumber, style: TextStyle(fontSize: 14, color: Colors.grey[800], fontWeight: FontWeight.w500), textAlign: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Text(student.name, style: TextStyle(fontSize: 15, color: Colors.grey[900], fontWeight: FontWeight.w500)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Center(
                  child: Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: student.isPresent,
                      onChanged: (bool value) async {
                        setState(() {
                          student.isPresent = value;
                        });
                        await updateAttendanceForStudent(student);
                      },
                      activeColor: Colors.white,
                      activeTrackColor: Colors.green,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.red.shade300,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
