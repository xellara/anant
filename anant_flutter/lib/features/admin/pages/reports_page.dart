import 'package:anant_flutter/config/role_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String _selectedPeriod = 'This Month';
  final List<String> _periods = ['Today', 'This Week', 'This Month', 'This Year'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !kIsWeb,
        title: const Text('Reports & Analytics'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(context).extension<AppGradients>()?.primaryGradient,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading report...')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Period Selector
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Text('Period:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 12),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _periods.map((period) {
                        final isSelected = _selectedPeriod == period;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(period),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedPeriod = period;
                              });
                            },
                            selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // KPI Cards
          Row(
            children: [
              Expanded(
                child: _buildKpiCard('Total Revenue', '₹2,45,000', '+12%', Colors.green, Icons.currency_rupee),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildKpiCard('Attendance', '92.5%', '+3.2%', Colors.blue, Icons.check_circle),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildKpiCard('Active Students', '758', '+5', Colors.orange, Icons.people),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildKpiCard('Pending Fees', '₹45,000', '-8%', Colors.red, Icons.warning),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Attendance Chart
          _buildChartCard(
            'Attendance Overview',
            'Weekly attendance rate',
            Colors.blue,
            _buildAttendanceChart(),
          ),

          const SizedBox(height: 24),

          // Fee Collection Chart
          _buildChartCard(
            'Fee Collection',
            'Monthly revenue trend',
            Colors.green,
            _buildRevenueChart(),
          ),

          const SizedBox(height: 24),

          // Quick Reports
          _buildQuickReportsSection(),

          const SizedBox(height: 24),

          // Detailed Stats
          _buildDetailedStatsSection(),
        ],
      ),
    );
  }

  Widget _buildKpiCard(String title, String value, String change, Color color, IconData icon) {
    final isPositive = change.startsWith('+');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: (isPositive ? Colors.green : Colors.red).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(String title, String subtitle, Color color, Widget chart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(height: 200, child: chart),
        ],
      ),
    );
  }

  Widget _buildAttendanceChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                return Text(days[value.toInt() % days.length], style: const TextStyle(fontSize: 10));
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Text('${value.toInt()}%', style: const TextStyle(fontSize: 10)),
              reservedSize: 40,
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 92, color: Colors.blue, width: 16)]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 88, color: Colors.blue, width: 16)]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 95, color: Colors.blue, width: 16)]),
          BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 91, color: Colors.blue, width: 16)]),
          BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 93, color: Colors.blue, width: 16)]),
          BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 85, color: Colors.blue, width: 16)]),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                return Text(months[value.toInt() % months.length], style: const TextStyle(fontSize: 10));
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Text('₹${value.toInt()}k', style: const TextStyle(fontSize: 10)),
              reservedSize: 40,
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 180),
              FlSpot(1, 210),
              FlSpot(2, 195),
              FlSpot(3, 230),
              FlSpot(4, 215),
              FlSpot(5, 245),
            ],
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickReportsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Reports',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildReportItem('Student Performance Report', Icons.assessment, Colors.purple),
          _buildReportItem('Fee Collection Report', Icons.account_balance, Colors.green),
          _buildReportItem('Attendance Report', Icons.calendar_today, Colors.blue),
          _buildReportItem('Staff Performance Report', Icons.people, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildReportItem(String title, IconData icon, Color color) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title),
      trailing: const Icon(Icons.download, size: 20),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloading $title...')),
        );
      },
    );
  }

  Widget _buildDetailedStatsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detailed Statistics',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildStatRow('Total Students', '758', Colors.blue),
          _buildStatRow('Total Teachers', '45', Colors.green),
          _buildStatRow('Total Classes', '12', Colors.orange),
          _buildStatRow('Average Attendance', '92.5%', Colors.purple),
          _buildStatRow('Fee Collection Rate', '89.3%', Colors.teal),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[700])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
