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
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Fee or Payment record
abstract class FeeRecord implements _i1.SerializableModel {
  FeeRecord._({
    this.id,
    required this.organizationId,
    required this.studentId,
    required this.amount,
    this.dueDate,
    this.paidDate,
    this.description,
  });

  factory FeeRecord({
    int? id,
    required int organizationId,
    required int studentId,
    required double amount,
    DateTime? dueDate,
    DateTime? paidDate,
    String? description,
  }) = _FeeRecordImpl;

  factory FeeRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return FeeRecord(
      id: jsonSerialization['id'] as int?,
      organizationId: jsonSerialization['organizationId'] as int,
      studentId: jsonSerialization['studentId'] as int,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      dueDate: jsonSerialization['dueDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['dueDate']),
      paidDate: jsonSerialization['paidDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['paidDate']),
      description: jsonSerialization['description'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int organizationId;

  int studentId;

  double amount;

  DateTime? dueDate;

  DateTime? paidDate;

  String? description;

  /// Returns a shallow copy of this [FeeRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FeeRecord copyWith({
    int? id,
    int? organizationId,
    int? studentId,
    double? amount,
    DateTime? dueDate,
    DateTime? paidDate,
    String? description,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FeeRecord',
      if (id != null) 'id': id,
      'organizationId': organizationId,
      'studentId': studentId,
      'amount': amount,
      if (dueDate != null) 'dueDate': dueDate?.toJson(),
      if (paidDate != null) 'paidDate': paidDate?.toJson(),
      if (description != null) 'description': description,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FeeRecordImpl extends FeeRecord {
  _FeeRecordImpl({
    int? id,
    required int organizationId,
    required int studentId,
    required double amount,
    DateTime? dueDate,
    DateTime? paidDate,
    String? description,
  }) : super._(
         id: id,
         organizationId: organizationId,
         studentId: studentId,
         amount: amount,
         dueDate: dueDate,
         paidDate: paidDate,
         description: description,
       );

  /// Returns a shallow copy of this [FeeRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FeeRecord copyWith({
    Object? id = _Undefined,
    int? organizationId,
    int? studentId,
    double? amount,
    Object? dueDate = _Undefined,
    Object? paidDate = _Undefined,
    Object? description = _Undefined,
  }) {
    return FeeRecord(
      id: id is int? ? id : this.id,
      organizationId: organizationId ?? this.organizationId,
      studentId: studentId ?? this.studentId,
      amount: amount ?? this.amount,
      dueDate: dueDate is DateTime? ? dueDate : this.dueDate,
      paidDate: paidDate is DateTime? ? paidDate : this.paidDate,
      description: description is String? ? description : this.description,
    );
  }
}
