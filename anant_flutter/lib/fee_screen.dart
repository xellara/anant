import 'package:flutter/material.dart';

class FeeScreen extends StatelessWidget {
  const FeeScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> feeDetails = const [
    {
      'title': 'Tuition Fee',
      'amount': '\$5000',
      'dueDate': '2025-04-01',
      'status': 'Paid',
    },
    {
      'title': 'Library Fee',
      'amount': '\$300',
      'dueDate': '2025-04-05',
      'status': 'Due',
    },
    {
      'title': 'Exam Fee',
      'amount': '\$200',
      'dueDate': '2025-04-10',
      'status': 'Due',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fee Details'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: feeDetails.length,
        itemBuilder: (context, index) {
          final fee = feeDetails[index];
          final bool isPaid = fee['status'] == 'Paid';
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isPaid ? Colors.green : Colors.red,
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        isPaid ? Icons.check : Icons.error_outline,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fee['title']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Amount: ${fee['amount']}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Due: ${fee['dueDate']}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isPaid ? Icons.check_circle : Icons.pending,
                      color: isPaid ? Colors.green : Colors.red,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
