import 'package:anant_flutter/common/widgets/responsive_layout.dart';
import 'package:anant_flutter/config/role_theme.dart';
import 'package:anant_flutter/features/transaction/fee_detail_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthlyFeeListScreen extends StatelessWidget {
  final String month;
  final List<Map<String, dynamic>> fees;
  final bool isUpcoming;

  const MonthlyFeeListScreen({
    super.key,
    required this.month,
    required this.fees,
    required this.isUpcoming,
  });

  @override
  Widget build(BuildContext context) {
    final totalAmount = fees.fold(0.0, (sum, item) => sum + (item['amount'] as double));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: !kIsWeb,
        title: Text('$month details'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(context).extension<AppGradients>()?.primaryGradient,
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ResponsiveLayout(
        mobileBody: _buildContent(context, totalAmount),
        desktopBody: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: _buildContent(context, totalAmount, isDesktop: true),
          ),
        ),
        tabletBody: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: _buildContent(context, totalAmount, isDesktop: true),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, double totalAmount, {bool isDesktop = false}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: isDesktop 
                ? const BorderRadius.all(Radius.circular(30))
                : const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          margin: isDesktop ? const EdgeInsets.all(24) : EdgeInsets.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Amount",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
              Text(
                "₹${totalAmount.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: fees.length,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
            separatorBuilder: (context, index) => const Divider(height: 1, indent: 20, endIndent: 20),
            itemBuilder: (context, index) {
              return _buildFeeItem(context, fees[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeeItem(BuildContext context, Map<String, dynamic> fee) {
    final dateFormat = DateFormat('dd MMM yyyy');
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FeeDetailScreen(fee: fee),
              ),
            );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.2),
                  ),
                ),
                child: Icon(
                  isUpcoming
                      ? Icons.account_balance_wallet_outlined
                      : Icons.check_circle_outlined,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fee['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isUpcoming
                          ? 'Due: ${dateFormat.format(fee['dueDate'])}'
                          : 'Paid: ${dateFormat.format(fee['paidDate'])}',
                      style: TextStyle(
                        fontSize: 13,
                        color: isUpcoming ? const Color(0xFFE53935) : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${fee['amount'].toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey[300]),
            ],
          ),
        ),
      ),
    );
  }
}
