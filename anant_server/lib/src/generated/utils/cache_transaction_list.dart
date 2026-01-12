/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../transaction/montly_fee_transaction.dart' as _i2;
import 'package:anant_server/src/generated/protocol.dart' as _i3;

abstract class TransactionListContainer
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  TransactionListContainer._({required this.transactions});

  factory TransactionListContainer({
    required List<_i2.MonthlyFeeTransaction> transactions,
  }) = _TransactionListContainerImpl;

  factory TransactionListContainer.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return TransactionListContainer(
      transactions: _i3.Protocol().deserialize<List<_i2.MonthlyFeeTransaction>>(
        jsonSerialization['transactions'],
      ),
    );
  }

  List<_i2.MonthlyFeeTransaction> transactions;

  /// Returns a shallow copy of this [TransactionListContainer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TransactionListContainer copyWith({
    List<_i2.MonthlyFeeTransaction>? transactions,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TransactionListContainer',
      'transactions': transactions.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TransactionListContainer',
      'transactions': transactions.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _TransactionListContainerImpl extends TransactionListContainer {
  _TransactionListContainerImpl({
    required List<_i2.MonthlyFeeTransaction> transactions,
  }) : super._(transactions: transactions);

  /// Returns a shallow copy of this [TransactionListContainer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TransactionListContainer copyWith({
    List<_i2.MonthlyFeeTransaction>? transactions,
  }) {
    return TransactionListContainer(
      transactions:
          transactions ?? this.transactions.map((e0) => e0.copyWith()).toList(),
    );
  }
}
