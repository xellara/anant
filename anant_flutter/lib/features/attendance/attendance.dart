import 'package:anant_client/anant_client.dart';
import 'package:anant_flutter/common/widgets/custom_appbar.dart';
import 'package:anant_flutter/common/widgets/custom_button.dart';
import 'package:anant_flutter/main.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // Only the changed parts of the AttendanceInputPage build() method are shown below.

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: CustomAppBar(title: 'Attendance Entry'),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Changed: Class & Section dropdown using DropdownButton2.
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
          // Date picker remains unchanged.
          Row(
            children: [
              Expanded(
                child: Text(
                  selectedDate == null
                      ? 'Select Date'
                      : 'Date: $selectedDate',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: _pickDate,
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Changed: Subject dropdown using DropdownButton2.
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
          // Changed: Time selection row using DropdownButton2.
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

    final bottomPadding = students.isNotEmpty ? 80.0 : 8.0;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Record Attendance'
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(12, 8, 12, bottomPadding),
        children: [
          if (students.isNotEmpty)
            SwitchListTile(
              title: Text(!allPresent ? 'Marked all as Absent' : 'Marked all as Present', style: TextStyle(fontSize: 14)),
              value: allPresent,
              onChanged: (value) => toggleAll(value),
              activeColor: Colors.green,
              inactiveThumbColor: Colors.red,
              inactiveTrackColor: Colors.red.withValues(alpha: 0.4),
              contentPadding: EdgeInsets.zero,
            ),
          const SizedBox(height: 8),
          if (students.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: Table(
                border: TableBorder.all(color: Colors.grey, width: 1),
                columnWidths: const {
                  0: FixedColumnWidth(60), // Admission number column.
                  1: FlexColumnWidth(),     // Name column.
                  2: FixedColumnWidth(80),  // Attendance toggle column.
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey[300]),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Roll No.", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Name", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Attendance", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                  ...students.map((student) {
                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(student.rollNumber, style: const TextStyle(fontSize: 14)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(student.name, style: const TextStyle(fontSize: 14)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                activeColor: Colors.green,
                                inactiveThumbColor: Colors.red,
                                inactiveTrackColor: Colors.red.withValues(alpha: 0.4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
        ],
      ),
      bottomSheet: students.isNotEmpty
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
}
