/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class MonthlyFeeTransaction implements _i1.SerializableModel {
  MonthlyFeeTransaction._({
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
    bool? isRefunded,
  }) : isRefunded = isRefunded ?? false;

  factory MonthlyFeeTransaction({
    int? id,
    required String anantId,
    required String organizationName,
    required String month,
    required double feeAmount,
    required double discount,
    required double fine,
    required DateTime transactionDate,
    required String transactionGateway,
    required String transactionRef,
    required String transactionId,
    required String transactionStatus,
    required String transactionType,
    required String markedByAnantId,
    bool? isRefunded,
  }) = _MonthlyFeeTransactionImpl;

  factory MonthlyFeeTransaction.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return MonthlyFeeTransaction(
      id: jsonSerialization['id'] as int?,
      anantId: jsonSerialization['anantId'] as String,
      organizationName: jsonSerialization['organizationName'] as String,
      month: jsonSerialization['month'] as String,
      feeAmount: (jsonSerialization['feeAmount'] as num).toDouble(),
      discount: (jsonSerialization['discount'] as num).toDouble(),
      fine: (jsonSerialization['fine'] as num).toDouble(),
      transactionDate: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['transactionDate']),
      transactionGateway: jsonSerialization['transactionGateway'] as String,
      transactionRef: jsonSerialization['transactionRef'] as String,
      transactionId: jsonSerialization['transactionId'] as String,
      transactionStatus: jsonSerialization['transactionStatus'] as String,
      transactionType: jsonSerialization['transactionType'] as String,
      markedByAnantId: jsonSerialization['markedByAnantId'] as String,
      isRefunded: jsonSerialization['isRefunded'] as bool,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String anantId;

  String organizationName;

  String month;

  double feeAmount;

  double discount;

  double fine;

  DateTime transactionDate;

  String transactionGateway;

  String transactionRef;

  String transactionId;

  String transactionStatus;

  String transactionType;

  String markedByAnantId;

  bool isRefunded;

  /// Returns a shallow copy of this [MonthlyFeeTransaction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MonthlyFeeTransaction copyWith({
    int? id,
    String? anantId,
    String? organizationName,
    String? month,
    double? feeAmount,
    double? discount,
    double? fine,
    DateTime? transactionDate,
    String? transactionGateway,
    String? transactionRef,
    String? transactionId,
    String? transactionStatus,
    String? transactionType,
    String? markedByAnantId,
    bool? isRefunded,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'anantId': anantId,
      'organizationName': organizationName,
      'month': month,
      'feeAmount': feeAmount,
      'discount': discount,
      'fine': fine,
      'transactionDate': transactionDate.toJson(),
      'transactionGateway': transactionGateway,
      'transactionRef': transactionRef,
      'transactionId': transactionId,
      'transactionStatus': transactionStatus,
      'transactionType': transactionType,
      'markedByAnantId': markedByAnantId,
      'isRefunded': isRefunded,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MonthlyFeeTransactionImpl extends MonthlyFeeTransaction {
  _MonthlyFeeTransactionImpl({
    int? id,
    required String anantId,
    required String organizationName,
    required String month,
    required double feeAmount,
    required double discount,
    required double fine,
    required DateTime transactionDate,
    required String transactionGateway,
    required String transactionRef,
    required String transactionId,
    required String transactionStatus,
    required String transactionType,
    required String markedByAnantId,
    bool? isRefunded,
  }) : super._(
          id: id,
          anantId: anantId,
          organizationName: organizationName,
          month: month,
          feeAmount: feeAmount,
          discount: discount,
          fine: fine,
          transactionDate: transactionDate,
          transactionGateway: transactionGateway,
          transactionRef: transactionRef,
          transactionId: transactionId,
          transactionStatus: transactionStatus,
          transactionType: transactionType,
          markedByAnantId: markedByAnantId,
          isRefunded: isRefunded,
        );

  /// Returns a shallow copy of this [MonthlyFeeTransaction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MonthlyFeeTransaction copyWith({
    Object? id = _Undefined,
    String? anantId,
    String? organizationName,
    String? month,
    double? feeAmount,
    double? discount,
    double? fine,
    DateTime? transactionDate,
    String? transactionGateway,
    String? transactionRef,
    String? transactionId,
    String? transactionStatus,
    String? transactionType,
    String? markedByAnantId,
    bool? isRefunded,
  }) {
    return MonthlyFeeTransaction(
      id: id is int? ? id : this.id,
      anantId: anantId ?? this.anantId,
      organizationName: organizationName ?? this.organizationName,
      month: month ?? this.month,
      feeAmount: feeAmount ?? this.feeAmount,
      discount: discount ?? this.discount,
      fine: fine ?? this.fine,
      transactionDate: transactionDate ?? this.transactionDate,
      transactionGateway: transactionGateway ?? this.transactionGateway,
      transactionRef: transactionRef ?? this.transactionRef,
      transactionId: transactionId ?? this.transactionId,
      transactionStatus: transactionStatus ?? this.transactionStatus,
      transactionType: transactionType ?? this.transactionType,
      markedByAnantId: markedByAnantId ?? this.markedByAnantId,
      isRefunded: isRefunded ?? this.isRefunded,
    );
  }
}
