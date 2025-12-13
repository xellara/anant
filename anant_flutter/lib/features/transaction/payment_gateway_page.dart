import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_upi_india/flutter_upi_india.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// -- shared constants --------------------------------
const _upiId = '6386065723@paytm';
const _payeeName = 'Test English School';
const num _amount = 199;
const num _fee = 0;

/// -- EVENTS -------------------------------------------
abstract class PaymentEvent {}
class LoadAppsEvent extends PaymentEvent {}
class ToggleViewEvent extends PaymentEvent {
  final bool showQr;
  ToggleViewEvent(this.showQr);
}
class InitiatePaymentEvent extends PaymentEvent {
  final ApplicationMeta appMeta;
  InitiatePaymentEvent(this.appMeta);
}

/// -- STATES -------------------------------------------
abstract class PaymentState {}
class PaymentInitial extends PaymentState {}
class AppsLoadingState extends PaymentState {}
class AppsLoadedState extends PaymentState {
  final List<ApplicationMeta> apps;
  final bool showQr;
  AppsLoadedState(this.apps, this.showQr);
}
class AppsLoadFailureState extends PaymentState {
  final String error;
  AppsLoadFailureState(this.error);
}
class PaymentProcessingState extends PaymentState {}
class PaymentSuccessState extends PaymentState {
  final UpiTransactionResponse response;
  PaymentSuccessState(this.response);
}
class PaymentFailureState extends PaymentState {
  final String error;
  PaymentFailureState(this.error);
}

/// -- BLOC ---------------------------------------------
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final String _orderId = 'ORD-${1024 + Random().nextInt(1000)}';
  List<ApplicationMeta> _apps = [];

  PaymentBloc() : super(PaymentInitial()) {
    on<LoadAppsEvent>(_onLoadApps);
    on<ToggleViewEvent>(_onToggleView);
    on<InitiatePaymentEvent>(_onInitiatePayment);
  }

  Future<void> _onLoadApps(LoadAppsEvent _, Emitter<PaymentState> emit) async {
    emit(AppsLoadingState());
    try {
      _apps = await UpiPay.getInstalledUpiApplications(
        statusType: UpiApplicationDiscoveryAppStatusType.all,
        paymentType: UpiApplicationDiscoveryAppPaymentType.nonMerchant,
      );
      emit(AppsLoadedState(_apps, _apps.isEmpty));
    } catch (e) {
      emit(AppsLoadFailureState(e.toString()));
    }
  }

  void _onToggleView(ToggleViewEvent event, Emitter<PaymentState> emit) {
    emit(AppsLoadedState(_apps, event.showQr));
  }

  Future<void> _onInitiatePayment(InitiatePaymentEvent event, Emitter<PaymentState> emit) async {
    emit(PaymentProcessingState());
    final txnRef = Random.secure().nextInt(1 << 32).toString();
    try {
      final resp = await UpiPay.initiateTransaction(
        amount: _amount.toStringAsFixed(2),
        app: event.appMeta.upiApplication,
        receiverUpiAddress: _upiId,
        receiverName: _payeeName,
        transactionRef: txnRef,
        transactionNote: 'Order #$_orderId',
      );
      emit(PaymentSuccessState(resp));
    } catch (e) {
      emit(PaymentFailureState(e.toString()));
    }
  }

  String get orderId => _orderId;
}

/// -- UI WIDGET ----------------------------------------
class PaymentGatewayPage extends StatelessWidget {
  const PaymentGatewayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentBloc()..add(LoadAppsEvent()),
      child: BlocConsumer<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentSuccessState) {
            Navigator.of(context).pushReplacementNamed('/splash');
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text(_getTitle(state))),
            body: _buildBody(context, state),
            bottomNavigationBar: _buildFooter(),
          );
        },
      ),
    );
  }
  

  String _getTitle(PaymentState state) {
    if (state is PaymentSuccessState || state is PaymentFailureState) {
      return 'Payment Result';
    }
    if (state is PaymentProcessingState) {
      return 'Processing Payment';
    }
    return 'Pay ₹${_amount.toStringAsFixed(2)} via UPI';
  }

  Widget _buildBody(BuildContext context, PaymentState state) {
    if (state is AppsLoadingState || state is PaymentInitial) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is AppsLoadFailureState) {
      return Center(child: Text('Error loading apps: ${state.error}'));
    }
    if (state is PaymentProcessingState) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Complete the payment in the UPI app', textAlign: TextAlign.center),
          ],
        ),
      );
    }
    if (state is PaymentSuccessState) {
      return _buildResultView(context, response: state.response);
    }
    if (state is PaymentFailureState) {
      return _buildResultView(context, error: state.error);
    }
    if (state is AppsLoadedState) {
      final apps = state.apps;
      // If no UPI apps installed → only QR, no toggle
      if (apps.isEmpty) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildReceiptCard(context),
              const SizedBox(height: 24),
              _buildQrView(context),
            ],
          ),
        );
      }
      // Otherwise, show toggle + apps/QR
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildReceiptCard(context),
            const SizedBox(height: 24),
            _buildToggleRow(context, state.showQr),
            const SizedBox(height: 24),
            state.showQr
                ? _buildQrView(context)
                : _buildAppsGrid(context, apps),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildToggleRow(BuildContext context, bool showQr) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => context.read<PaymentBloc>().add(ToggleViewEvent(false)),
          style: ElevatedButton.styleFrom(
            backgroundColor: !showQr ? Theme.of(context).primaryColor : Colors.grey[300],
          ),
          child: Text('UPI Apps',
              style: TextStyle(color: !showQr ? Colors.white : Colors.black87)),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () => context.read<PaymentBloc>().add(ToggleViewEvent(true)),
          style: ElevatedButton.styleFrom(
            backgroundColor: showQr ? Theme.of(context).primaryColor : Colors.grey[300],
          ),
          child: Text('QR Code',
              style: TextStyle(color: showQr ? Colors.white : Colors.black87)),
        ),
      ],
    );
  }

  Widget _buildAppsGrid(BuildContext context, List<ApplicationMeta> apps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Choose a UPI app:', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: apps.map((app) {
            return Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => context.read<PaymentBloc>().add(InitiatePaymentEvent(app)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    app.iconImage(48),
                    const SizedBox(height: 6),
                    Text(app.upiApplication.getAppName(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQrView(BuildContext context) {
    final orderId = context.read<PaymentBloc>().orderId;
    final uri = Uri(
      scheme: 'upi',
      host: 'pay',
      queryParameters: {
        'pa': _upiId,
        'pn': _payeeName,
        'am': _amount.toStringAsFixed(2),
        'cu': 'INR',
        'tn': 'Order #$orderId',
      },
    ).toString();

    return Column(
      children: [
        const Text('Scan QR to pay:', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 12),
        QrImageView(data: uri, version: QrVersions.auto, size: 200),
      ],
    );
  }

  Widget _buildReceiptCard(BuildContext context) {
    final orderId = context.read<PaymentBloc>().orderId;
    final date = DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());
    final total = _amount + _fee;
    return Card(
      color: Colors.grey[50],
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(children: [
          const Text('Payment Receipt',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Divider(height: 24),
          _buildRow('Order ID', orderId),
          _buildRow('Date', date),
          _buildRow('Payee', _payeeName),
          _buildRow('UPI ID', _upiId),
          const SizedBox(height: 8),
          _buildRow('Amount', '₹${_amount.toStringAsFixed(2)}'),
          _buildRow('Txn Fee', '₹${_fee.toStringAsFixed(2)}'),
          const Divider(height: 24),
          _buildRow('Total', '₹${total.toStringAsFixed(2)}', isTotal: true),
        ]),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[800])),
          Text(value,
              style: TextStyle(
                  fontSize: isTotal ? 16 : 14,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildResultView(
    BuildContext context, {
    UpiTransactionResponse? response,
    String? error,
  }) {
    final success = response?.status.toString().toLowerCase().contains('success') ?? false;
    final color = success ? Colors.green : Colors.red;
    final statusText = error ?? response!.status.toString().toUpperCase();
    final icon = success ? Icons.check_circle : Icons.error;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        Icon(icon, color: color, size: 64),
        const SizedBox(height: 12),
        Text(
          statusText,
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 24),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Column(children: [
              const Text('Transaction Details', style: TextStyle(fontWeight: FontWeight.bold)),
              const Divider(height: 20),
              _buildRow('Txn ID', response?.txnId ?? ''),
              _buildRow('Txn Ref', response?.txnRef ?? ''),
              _buildRow('Approval Ref', response?.approvalRefNo ?? ''),
              _buildRow('Response Code', response?.responseCode ?? ''),
            ]),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => context.read<PaymentBloc>().add(LoadAppsEvent()),
          child: const Text('Pay Again'),
        ),
      ]),
    );
  }

  Widget _buildFooter() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          'Powered by Xellara Digital Solutions',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      );
}
