import 'package:anant_client/anant_client.dart';

class FeeTransaction {
  final int? id;
  final String anantId;
  final String organizationName;
  final String month;
  final double feeAmount;
  final double discount;
  final double fine;
  final DateTime transactionDate;
  final String transactionGateway;
  final String transactionRef;
  final String transactionId;
  final String transactionStatus; // 'Paid' or 'Pending'
  final String transactionType;
  final String markedByAnantId;
  final bool isRefunded;

  FeeTransaction({
    this.id,
    required this.anantId,
    required this.organizationName,
    required this.month,
    required this.feeAmount,
    required this.discount,
    required this.fine,
    required this.transactionDate,
    required this.transactionGateway,
    required this.transactionRef,
    required this.transactionId,
    required this.transactionStatus,
    required this.transactionType,
    required this.markedByAnantId,
    required this.isRefunded,
  });

  factory FeeTransaction.fromClient(MonthlyFeeTransaction client) {
    return FeeTransaction(
      id: client.id,
      anantId: client.anantId,
      organizationName: client.organizationName,
      month: client.month,
      feeAmount: client.feeAmount,
      discount: client.discount,
      fine: client.fine,
      transactionDate: client.transactionDate,
      transactionGateway: client.transactionGateway,
      transactionRef: client.transactionRef,
      transactionId: client.transactionId,
      transactionStatus: client.transactionStatus,
      transactionType: client.transactionType,
      markedByAnantId: client.markedByAnantId,
      isRefunded: client.isRefunded,
    );
  }

  double get totalAmount => feeAmount - discount + fine;

  bool get isPaid => transactionStatus.toLowerCase() == 'paid';
  bool get isPending => transactionStatus.toLowerCase() == 'pending';
}
