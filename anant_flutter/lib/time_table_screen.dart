import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class TimeTableScreen extends StatefulWidget {
  const TimeTableScreen({super.key});

  @override
  State<TimeTableScreen> createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  // Toggle between table view and grid view.
  bool showTableView = false;

  final List<String> header = const [
    'Time',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  // Each row may include a 'showTeacher' flag.
  final List<Map<String, dynamic>> timetable = const [
    {
      'startTime': '09:00',
      'endTime': '10:00',
      'showTeacher': true,
      'Monday': {'subject': 'Math', 'faculty': 'Dr. Smith'},
      'Tuesday': {'subject': 'English', 'faculty': 'Ms. Johnson'},
      'Wednesday': {'subject': 'Science', 'faculty': 'Dr. Brown'},
      'Thursday': {'subject': 'History', 'faculty': 'Mr. Davis'},
      'Friday': {'subject': 'Art', 'faculty': 'Mrs. Wilson'},
      'Saturday': {'subject': 'Physical Ed', 'faculty': 'Coach Taylor'},
    },
    {
      'startTime': '10:15',
      'endTime': '11:15',
      'showTeacher': false,
      'Monday': {'subject': 'Physics', 'faculty': 'Dr. Miller'},
      'Tuesday': {'subject': 'Chemistry', 'faculty': 'Dr. Anderson'},
      'Wednesday': {'subject': 'Biology', 'faculty': 'Dr. Thomas'},
      'Thursday': {'subject': 'PE', 'faculty': 'Coach Moore'},
      'Friday': {'subject': 'Music', 'faculty': 'Ms. Martin'},
      'Saturday': {'subject': 'Drama', 'faculty': 'Mrs. Thompson'},
    },
    {
      'startTime': '11:30',
      'endTime': '12:30',
      // If showTeacher key is omitted, we treat it as false by default.
      'Monday': {'subject': 'Economics', 'faculty': 'Dr. Garcia'},
      'Tuesday': {'subject': 'Computer Sci', 'faculty': 'Dr. Martinez'},
      'Wednesday': {'subject': 'Literature', 'faculty': 'Ms. Robinson'},
      'Thursday': {'subject': 'Drama', 'faculty': 'Mrs. Clark'},
      'Friday': {'subject': 'Geography', 'faculty': 'Mr. Rodriguez'},
      'Saturday': {'subject': 'Social Studies', 'faculty': 'Ms. Lewis'},
    },
  ];

  // Helper method to get today's day string from timetable header.
  String getTodayDay() {
    int weekday = DateTime.now().weekday;
    if (weekday >= 1 && weekday <= 6) {
      return header[weekday]; // header[1] is Monday, etc.
    } else {
      return 'Monday'; // Default for Sunday or adjust as needed.
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = getTodayDay();

    return Scaffold(
      appBar: AppBar(
        // Back button to pop the current route.
        automaticallyImplyLeading: !kIsWeb,
        title: const Text('Timetable'),
        actions: [
          IconButton(
            icon: const Icon(Icons.table_chart),
            tooltip: 'Show Table View',
            onPressed: () {
              setState(() {
                showTableView = true;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.grid_view),
            tooltip: 'Show Today\'s Classes',
            onPressed: () {
              setState(() {
                showTableView = false;
              });
            },
          ),
        ],
      ),
      body: showTableView
          ? buildTableView()
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6DD5FA), Color(0xFFFFFFFF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: buildGridView(today),
            ),
    );
  }

  Widget buildTableView() {
    return Center(
      child: RotatedBox(
        quarterTurns: 1,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Class 9B', style: TextStyle(fontSize: 20)),
              ),
              Table(
                border: TableBorder.all(),
                defaultColumnWidth: const FixedColumnWidth(120.0),
                children: [
                  // Header row with styled text.
                  TableRow(
                    decoration: const BoxDecoration(color: Colors.blueAccent),
                    children: header.map((title) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }).toList(),
                  ),
                  // Data rows for each time slot.
                  ...timetable.map((row) {
                    // Retrieve the per-row flag; default to false if missing.
                    final bool showTeacher =
                        row.containsKey('showTeacher') ? row['showTeacher'] : false;
                    return TableRow(
                      children: header.map((key) {
                        String displayText = '';
                        if (key == 'Time') {
                          displayText = '${row['startTime']} - ${row['endTime']}';
                        } else {
                          final dayEntry = row[key];
                          if (dayEntry != null) {
                            // If showTeacher is true, display teacher only;
                            // otherwise, display only the subject.
                            displayText = showTeacher
                                ? '${dayEntry['faculty']}'
                                : '${dayEntry['subject']}';
                          }
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            displayText,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGridView(String today) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Today\'s Classes: $today',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: timetable.map((row) {
                // Retrieve the per-row flag; default to false if missing.
                final bool showTeacher =
                    row.containsKey('showTeacher') ? row['showTeacher'] : false;
                final dayEntry = row[today];
                // If showTeacher is true, show teacher; if false, show subject only.
                final displayText = dayEntry != null
                    ? (showTeacher ? dayEntry['faculty'] : dayEntry['subject'])
                    : 'No Class';
                final time = '${row['startTime']} - ${row['endTime']}';
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF84fab0), Color(0xFF8fd3f4)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              displayText,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              time,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
