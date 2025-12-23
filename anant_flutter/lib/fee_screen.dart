import 'package:anant_flutter/common/loading_indicator.dart';
import 'package:anant_flutter/config/role_theme.dart';
import 'package:anant_flutter/features/transaction/data/repositories/fee_repository_impl.dart';
import 'package:anant_flutter/features/transaction/domain/usecases/get_user_fees.dart';
import 'package:anant_flutter/features/transaction/monthly_fee_list_screen.dart';
import 'package:anant_flutter/features/transaction/payment_gateway_page.dart';
import 'package:anant_flutter/features/transaction/presentation/bloc/fee_bloc.dart';
import 'package:anant_flutter/features/transaction/presentation/bloc/fee_event.dart';
import 'package:anant_flutter/features/transaction/presentation/bloc/fee_state.dart';
import 'package:anant_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:anant_flutter/common/widgets/responsive_layout.dart';

class FeeScreen extends StatelessWidget {
  const FeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeeBloc(
        getUserFees: GetUserFees(FeeRepositoryImpl()),
      ),
      child: const _FeeScreenView(),
    );
  }
}

class _FeeScreenView extends StatefulWidget {
  const _FeeScreenView();

  @override
  State<_FeeScreenView> createState() => _FeeScreenViewState();
}

class _FeeScreenViewState extends State<_FeeScreenView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _anantId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserAndFees();
  }

  Future<void> _loadUserAndFees() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      
      if (userId != null) {
        // Fetch user data from API to get anantId
        final userData = await client.user.me(userId);
        
        if (userData != null && userData.anantId != null && userData.anantId!.isNotEmpty) {
          setState(() {
            _anantId = userData.anantId;
          });
          
          if (!mounted) return;
          context.read<FeeBloc>().add(LoadUserFeesEvent(userData.anantId!));
        }
      }
    } catch (e) {
      debugPrint('Error loading user fees: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToPayment(BuildContext context, {double? amount, String? purpose}) {
    final paymentAmount = amount ?? 0.0;
    final paymentPurpose = purpose ?? 'Fee Payment';

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaymentGatewayPage(
          amount: paymentAmount,
          purpose: paymentPurpose,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // On desktop, we might want to hide the app bar if the layout provides its own header context,
      // but keeping it simple for now or strictly following mobile patterns where needed.
      // However, usually detailed pages inside a dashboard shell might not need their own scaffold if nested,
      // but here they are pushed on stack.
      body: BlocBuilder<FeeBloc, FeeState>(
        builder: (context, state) {
          if (state is FeeLoading) {
            return const Center(child: LoadingIndicator());
          } else if (state is FeeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load fees',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_anantId != null && _anantId!.isNotEmpty) {
                        context.read<FeeBloc>().add(LoadUserFeesEvent(_anantId!));
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is FeeLoaded) {
            final transactions = state.transactions;
            final outstanding = transactions
                .where((t) => t.isPending)
                .fold(0.0, (sum, t) => sum + t.totalAmount);

            return ResponsiveLayout(
              mobileBody: Column(
                children: [
                   _buildHeader(context, outstanding),
                   _buildTabBar(),
                   Expanded(
                     child: TabBarView(
                       controller: _tabController,
                       children: [
                         _buildFeeList(context, transactions: transactions, isUpcoming: true),
                         _buildFeeList(context, transactions: transactions, isUpcoming: false),
                       ],
                     ),
                   ),
                ],
              ),
              desktopBody: _buildDesktopLayout(context, transactions, outstanding),
              tabletBody: _buildDesktopLayout(context, transactions, outstanding),
            );
          }

          // Initial state
          return const Center(child: LoadingIndicator());
        },
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, List<dynamic> transactions, double outstanding) {
     return Center(
       child: ConstrainedBox(
         constraints: const BoxConstraints(maxWidth: 1200),
         child: Padding(
           padding: const EdgeInsets.all(32.0),
           child: Row(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               // Left Side: Summary Card
               SizedBox(
                 width: 380,
                 child: Column(
                   children: [
                      _buildDesktopSummaryCard(context, outstanding),
                      const SizedBox(height: 24),
                      // Can add more stats or info here
                   ],
                 ),
               ),
               
               const SizedBox(width: 32),
               
               // Right Side: Tabs and List
               Expanded(
                 child: Column(
                   children: [
                     // Custom desktop tab bar container
                     Container(
                       width: double.infinity,
                       decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.circular(16),
                         boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                         ]
                       ),
                       child: _buildTabBar(),
                     ),
                     const SizedBox(height: 24),
                     Expanded(
                        child: Container(
                           decoration: BoxDecoration(
                             color: Colors.white, 
                             borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  )
                              ]
                           ),
                           clipBehavior: Clip.antiAlias,
                           child: TabBarView(
                             controller: _tabController,
                             children: [
                               _buildDesktopFeeGrid(context, transactions: transactions, isUpcoming: true),
                               _buildDesktopFeeGrid(context, transactions: transactions, isUpcoming: false),
                             ],
                           ),
                        ),
                     ),
                   ],
                 ),
               ),
             ],
           ),
         ),
       ),
     );
  }

  Widget _buildDesktopSummaryCard(BuildContext context, double outstanding) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: Theme.of(context).extension<AppGradients>()?.primaryGradient,
        borderRadius: BorderRadius.circular(24),
         boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
         ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.currency_rupee_rounded, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              const Text(
                'Student Fees',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Text(
            'Total Outstanding Amount',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '₹${outstanding.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          if (outstanding > 0)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _navigateToPayment(
                  context,
                  amount: outstanding,
                  purpose: 'Total Outstanding Fees',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Theme.of(context).primaryColor,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Pay Now',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          else 
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
               child: const Center(
                 child: Text(
                  'No Dues Pending',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                             ),
               ),
            ),
        ],
      ),
    );
  }

  Widget _buildDesktopFeeGrid(
    BuildContext context, {
    required List transactions,
    required bool isUpcoming,
  }) {
    final fees = transactions.where((t) {
      return isUpcoming ? t.isPending : t.isPaid;
    }).toList();

    // Group logic reuse
    final Map<String, List<Map<String, dynamic>>> groupedFees = {};
    for (var fee in fees) {
      final month = fee.month;
      if (!groupedFees.containsKey(month)) {
        groupedFees[month] = [];
      }
      groupedFees[month]!.add({
        'title': _getFeeTitle(fee),
        'amount': fee.totalAmount,
        'dueDate': fee.transactionDate,
        'paidDate': fee.transactionDate,
        'status': fee.transactionStatus,
        'month': fee.month,
      });
    }

    final months = groupedFees.keys.toList();
    if (isUpcoming) {
      months.sort();
    } else {
      months.sort((a, b) => b.compareTo(a));
    }

    if (fees.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUpcoming ? Icons.check_circle_outline : Icons.history,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              isUpcoming ? 'No upcoming dues!' : 'No payment history',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(32),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, 
        childAspectRatio: 2.2,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
      ),
      itemCount: months.length,
      itemBuilder: (context, index) {
        final month = months[index];
        final monthFees = groupedFees[month]!;
        // Reusing _buildMonthSummaryCard but it works well in grid too
        return _buildMonthSummaryCard(context, month, monthFees, isUpcoming);
      },
    );
  }

  // Mobile/Original Header
  Widget _buildHeader(BuildContext context, double outstanding) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: BoxDecoration(
        gradient: Theme.of(context).extension<AppGradients>()?.primaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 48,
            child: Center(
              child: Text(
                'Student Fees',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Total Outstanding',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '₹${outstanding.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          if (outstanding > 0)
            ElevatedButton(
              onPressed: () => _navigateToPayment(
                context,
                amount: outstanding,
                purpose: 'Total Outstanding Fees',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).primaryColor,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Pay Now',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: TabBar(
          controller: _tabController,
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: const Color(0xFF2E7D32),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2E7D32).withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            letterSpacing: 0.5,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Paid History'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeeList(
    BuildContext context, {
    required List transactions,
    required bool isUpcoming,
  }) {
    final fees = transactions.where((t) {
      return isUpcoming ? t.isPending : t.isPaid;
    }).toList();

    // Group by month
    final Map<String, List<Map<String, dynamic>>> groupedFees = {};
    for (var fee in fees) {
      final month = fee.month;
      if (!groupedFees.containsKey(month)) {
        groupedFees[month] = [];
      }
      groupedFees[month]!.add({
        'title': _getFeeTitle(fee),
        'amount': fee.totalAmount,
        'dueDate': fee.transactionDate,
        'paidDate': fee.transactionDate,
        'status': fee.transactionStatus,
        'month': fee.month,
      });
    }

    final months = groupedFees.keys.toList();
    // Sort months - upcoming ascending, paid descending
    if (isUpcoming) {
      months.sort();
    } else {
      months.sort((a, b) => b.compareTo(a));
    }

    if (fees.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUpcoming ? Icons.check_circle_outline : Icons.history,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              isUpcoming ? 'No upcoming dues!' : 'No payment history',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: months.length,
      itemBuilder: (context, index) {
        final month = months[index];
        final monthFees = groupedFees[month]!;
        return _buildMonthSummaryCard(context, month, monthFees, isUpcoming);
      },
    );
  }

  String _getFeeTitle(dynamic fee) {
    // Generate title based on transaction type or use a default
    final type = fee.transactionType;
    if (type.toLowerCase().contains('tuition')) {
      return 'School Tuition Fee';
    } else if (type.toLowerCase().contains('transport')) {
      return 'Transportation Fee';
    } else if (type.toLowerCase().contains('library')) {
      return 'Library Fee';
    } else if (type.toLowerCase().contains('lab')) {
      return 'Lab Material Fee';
    } else if (type.toLowerCase().contains('development')) {
      return 'Development Charge';
    }
    return 'Monthly Fee';
  }

  Widget _buildMonthSummaryCard(
    BuildContext context,
    String month,
    List<Map<String, dynamic>> fees,
    bool isUpcoming,
  ) {
    final double totalAmount = fees.fold(0.0, (sum, item) => sum + (item['amount'] as double));
    final int feeCount = fees.length;
    final DateFormat dateFormat = DateFormat('dd MMM yyyy');
    DateTime? earliestDueDate;
    if (fees.isNotEmpty) {
      earliestDueDate = fees.first['dueDate'] as DateTime;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MonthlyFeeListScreen(
                  month: month,
                  fees: fees,
                  isUpcoming: isUpcoming,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    // Month Date/Icon Box
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: isUpcoming ? const Color(0xFFE8F5E9) : const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            month.substring(0, month.length >= 3 ? 3 : month.length).toUpperCase(),
                            style: TextStyle(
                              color: isUpcoming ? const Color(0xFF2E7D32) : const Color(0xFF1976D2),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            month,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3142),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '$feeCount Transaction${feeCount > 1 ? 's' : ''}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (earliestDueDate != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              isUpcoming ? 'Due: ${dateFormat.format(earliestDueDate)}' : 'Paid',
                              style: TextStyle(
                                fontSize: 12,
                                color: isUpcoming ? const Color(0xFFE53935) : const Color(0xFF2E7D32),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${totalAmount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (isUpcoming)
                          GestureDetector(
                            onTap: () => _navigateToPayment(
                              context,
                              amount: totalAmount,
                              purpose: '$month Fees Total',
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E7D32),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Pay',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Paid',
                              style: TextStyle(
                                color: Color(0xFF2E7D32),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
