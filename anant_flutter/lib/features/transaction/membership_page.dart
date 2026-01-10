import 'package:anant_flutter/common/widgets/custom_button.dart';
import 'package:anant_flutter/features/transaction/payment_gateway_page.dart'; // Ensure this file exists and contains the PaymentGatewayPage class.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// EVENTS
abstract class MembershipEvent {}
class CheckMembership extends MembershipEvent {}
class UpgradeMembership extends MembershipEvent {}

// STATES
abstract class MembershipState {}
class MembershipInitial extends MembershipState {}
class MembershipLoading extends MembershipState {}
class MembershipNonPremium extends MembershipState {
  final double feeAmount;
  MembershipNonPremium(this.feeAmount);
}
class MembershipPremium extends MembershipState {}
class MembershipError extends MembershipState {
  final String message;
  MembershipError(this.message);
}

// BLOC
class MembershipBloc extends Bloc<MembershipEvent, MembershipState> {
  MembershipBloc() : super(MembershipInitial()) {
    on<CheckMembership>(_onCheckMembership);
    on<UpgradeMembership>(_onUpgradeMembership);
  }

  Future<void> _onCheckMembership(
    CheckMembership event,
    Emitter<MembershipState> emit,
  ) async {
    emit(MembershipLoading());
    await Future.delayed(const Duration(seconds: 1));
    const fee = 99.00;
    emit(MembershipNonPremium(fee));
  }

  Future<void> _onUpgradeMembership(
    UpgradeMembership event,
    Emitter<MembershipState> emit,
  ) async {
    emit(MembershipLoading());
    await Future.delayed(const Duration(seconds: 1));
    emit(MembershipPremium());
  }
}

class MembershipPage extends StatelessWidget {
  const MembershipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MembershipBloc()..add(CheckMembership()),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 0.5, 1.0],
              colors: [
                Color(0xFF6B6BD1),
                Color(0xFFCCCCCC),
                Color(0xFF1A1F71),
              ],
            ),
          ),
          child: BlocBuilder<MembershipBloc, MembershipState>(
            builder: (context, state) {
              if (state is MembershipLoading || state is MembershipInitial) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                );
              }

              if (state is MembershipPremium) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.verified_user,
                        size: 100,
                        color: Color(0xFF335762),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Premium Activated!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF335762),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (state is MembershipError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                );
              }

              if (state is MembershipNonPremium) {
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 32),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Color(0xFFedf5f2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Color(0xFF335762),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Annual Membership Benefits',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF335762),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Divider(
                            color: Color(0xFF335762),
                            thickness: 2,
                          ),
                          const SizedBox(height: 12),
                          ListTile(
                            leading: Icon(
                              Icons.check_circle_outline,
                              color: Color(0xFF335762),
                            ),
                            title: const Text('View Attendance'),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.grade_outlined,
                              color: Color(0xFF335762),
                            ),
                            title: const Text('View Marks'),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.schedule,
                              color: Color(0xFF335762),
                            ),
                            title: const Text('View Timetable'),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.payment,
                              color: Color(0xFF335762),
                            ),
                            title: const Text('Pay Fees'),
                            onTap: () {},
                          ),
                          const SizedBox(height: 20),
                          CustomButton(
                            label: 'Pay ₹${state.feeAmount.toStringAsFixed(2)}',
                            onPressed: () {
                              ///Use bloc
                              ///Navigate to payment gateway
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PaymentGatewayPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}