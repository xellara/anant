import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_upi_india/flutter_upi_india.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// -- shared constants --------------------------------
const _upiId = '6386065723@paytm';
const _payeeName = 'Test English School';

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
  
  final double amount;
  final String note;

  PaymentBloc({required this.amount, required this.note}) : super(PaymentInitial()) {
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
        amount: amount.toStringAsFixed(2),
        app: event.appMeta.upiApplication,
        receiverUpiAddress: _upiId,
        receiverName: _payeeName,
        transactionRef: txnRef,
        transactionNote: 'Order #$_orderId | $note',
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
  final double amount;
  final String purpose;

  const PaymentGatewayPage({
    super.key,
    this.amount = 199.0,
    this.purpose = 'Fee Payment',
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentBloc(amount: amount, note: purpose)..add(LoadAppsEvent()),
      child: BlocConsumer<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentSuccessState) {
            // In a real app, you might want to return result to caller instead of navigating to splash
            Navigator.of(context).pop(true); 
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: !kIsWeb,
              title: Text(_getTitle(state)),
            ),
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
    return 'Pay ₹${amount.toStringAsFixed(2)} via UPI';
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
        'am': amount.toStringAsFixed(2),
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
    // Assuming fee is included or extra. Using 0 for now as per original
    const num fee = 0; 
    final total = amount + fee;
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
          _buildRow('Purpose', purpose),
          const SizedBox(height: 8),
          _buildRow('Amount', '₹${amount.toStringAsFixed(2)}'),
          _buildRow('Txn Fee', '₹${fee.toStringAsFixed(2)}'),
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
              if (response != null) ...[
                _buildRow('Txn ID', response.txnId ?? ''),
                _buildRow('Txn Ref', response.txnRef ?? ''),
                _buildRow('Approval Ref', response.approvalRefNo ?? ''),
                _buildRow('Response Code', response.responseCode ?? ''),
              ],
            ]),
          ),
        ),
        const SizedBox(height: 24),
        if (success) 
          ElevatedButton.icon(
            onPressed: () => _generatePdf(context, response!),
            icon: const Icon(Icons.download),
            label: const Text('Download Receipt'),
             style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        if (success) const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => context.read<PaymentBloc>().add(LoadAppsEvent()),
          child: const Text('Pay Again'),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => Navigator.of(context).pop(), 
          child: const Text('Close'),
        ),
      ]),
    );
  }

  Future<void> _generatePdf(BuildContext context, UpiTransactionResponse response) async {
    final doc = pw.Document();
    final font = await PdfGoogleFonts.nunitoExtraLight();
    
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
             children: [
              pw.Header(
                level: 0,
                child: pw.Text('Fee Payment Receipt', style: pw.TextStyle(font: font, fontSize: 24, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 20),
              pw.Text('School: $_payeeName', style: pw.TextStyle(font: font, fontSize: 18)),
              pw.SizedBox(height: 10),
              pw.Text('Date: ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now())}', style: pw.TextStyle(font: font, fontSize: 14)),
              pw.Divider(),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Transaction ID:', style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold)),
                  pw.Text(response.txnId ?? 'N/A', style: pw.TextStyle(font: font)),
                ]
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Amount Paid:', style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold)),
                  pw.Text('INR ${amount.toStringAsFixed(2)}', style: pw.TextStyle(font: font, color: PdfColors.green)),
                ]
              ),
               pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Purpose:', style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold)),
                  pw.Text(purpose, style: pw.TextStyle(font: font)),
                ]
              ),
               pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Status:', style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold)),
                  pw.Text('SUCCESS', style: pw.TextStyle(font: font, color: PdfColors.green, fontWeight: pw.FontWeight.bold)),
                ]
              ),
              pw.SizedBox(height: 40),
              pw.Divider(),
              pw.Center(
                child: pw.Text('Thank you for your payment!', style: pw.TextStyle(font: font, fontStyle: pw.FontStyle.italic)),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'fee_receipt_${response.txnId}.pdf',
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
