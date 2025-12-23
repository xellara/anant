import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';


class FeeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> fee;

  const FeeDetailScreen({super.key, required this.fee});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final bool isUpcoming = fee['status'] == 'Upcoming';
    
    // Mock breakdown data
    final double baseAmount = fee['amount'] * 0.9;
    final double tax = fee['amount'] * 0.1;
    final double total = fee['amount'];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        automaticallyImplyLeading: !kIsWeb,
        title: const Text('Fee Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             _buildInfoCard(isUpcoming, dateFormat),
             const SizedBox(height: 20),
             _buildBreakdownCard(baseAmount, tax, total),
             const SizedBox(height: 30),

          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(bool isUpcoming, DateFormat dateFormat) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isUpcoming ? const Color(0xFFE8F5E9) : const Color(0xFFE3F2FD),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isUpcoming ? Icons.account_balance_wallet : Icons.check_circle,
              color: isUpcoming ? const Color(0xFF2E7D32) : const Color(0xFF1976D2),
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            fee['title'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 8),
          Container(
             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
             decoration: BoxDecoration(
               color: isUpcoming ? const Color(0xFFFFEBEE) : const Color(0xFFE8F5E9),
               borderRadius: BorderRadius.circular(20),
             ),
             child: Text(
               isUpcoming ? 'Due: ${dateFormat.format(fee['dueDate'])}' : 'Paid on: ${dateFormat.format(fee['paidDate'])}',
               style: TextStyle(
                 color: isUpcoming ? const Color(0xFFC62828) : const Color(0xFF2E7D32),
                 fontWeight: FontWeight.bold,
                 fontSize: 12,
               ),
             ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownCard(double base, double tax, double total) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Breakdown',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 20),
          _buildRow('Base Amount', base),
          _buildRow('Tax & Charges', tax),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          _buildRow('Total Amount', total, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? Colors.black87 : Colors.black54,
            ),
          ),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 20 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? const Color(0xFF2E7D32) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
