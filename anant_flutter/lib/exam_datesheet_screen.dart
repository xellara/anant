import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ExamDateSheetScreen extends StatelessWidget {
  // A sample list representing exam data
  final List<Map<String, String>> examDates = [
    {'subject': 'Mathematics', 'date': '2025-04-01', 'time': '09:00 AM'},
    {'subject': 'Physics', 'date': '2025-04-03', 'time': '11:00 AM'},
    {'subject': 'Chemistry', 'date': '2025-04-05', 'time': '10:00 AM'},
    // You can add more exam entries here
  ];

  ExamDateSheetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar for the screen title
      appBar: AppBar(
        automaticallyImplyLeading: !kIsWeb,
        title: const Text('Exam Date Sheet'),
      ),
      // Using a ListView to display exam details
      body: ListView.builder(
        itemCount: examDates.length,
        itemBuilder: (context, index) {
          final exam = examDates[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(exam['subject'] ?? ''),
              subtitle: Text('Date: ${exam['date']} | Time: ${exam['time']}'),
              leading: const Icon(Icons.calendar_today),
              // You can add onTap or other interactions here if needed
            ),
          );
        },
      ),
    );
  }
}
