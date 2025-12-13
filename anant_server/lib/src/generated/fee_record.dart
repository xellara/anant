/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Fee or Payment record
abstract class FeeRecord
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = FeeRecordTable();

  static const db = FeeRecordRepository._();

  @override
  int? id;

  int organizationId;

  int studentId;

  double amount;

  DateTime? dueDate;

  DateTime? paidDate;

  String? description;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'organizationId': organizationId,
      'studentId': studentId,
      'amount': amount,
      if (dueDate != null) 'dueDate': dueDate?.toJson(),
      if (paidDate != null) 'paidDate': paidDate?.toJson(),
      if (description != null) 'description': description,
    };
  }

  static FeeRecordInclude include() {
    return FeeRecordInclude._();
  }

  static FeeRecordIncludeList includeList({
    _i1.WhereExpressionBuilder<FeeRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FeeRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FeeRecordTable>? orderByList,
    FeeRecordInclude? include,
  }) {
    return FeeRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FeeRecord.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(FeeRecord.t),
      include: include,
    );
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

class FeeRecordTable extends _i1.Table<int?> {
  FeeRecordTable({super.tableRelation}) : super(tableName: 'fee_record') {
    organizationId = _i1.ColumnInt(
      'organizationId',
      this,
    );
    studentId = _i1.ColumnInt(
      'studentId',
      this,
    );
    amount = _i1.ColumnDouble(
      'amount',
      this,
    );
    dueDate = _i1.ColumnDateTime(
      'dueDate',
      this,
    );
    paidDate = _i1.ColumnDateTime(
      'paidDate',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
  }

  late final _i1.ColumnInt organizationId;

  late final _i1.ColumnInt studentId;

  late final _i1.ColumnDouble amount;

  late final _i1.ColumnDateTime dueDate;

  late final _i1.ColumnDateTime paidDate;

  late final _i1.ColumnString description;

  @override
  List<_i1.Column> get columns => [
        id,
        organizationId,
        studentId,
        amount,
        dueDate,
        paidDate,
        description,
      ];
}

class FeeRecordInclude extends _i1.IncludeObject {
  FeeRecordInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => FeeRecord.t;
}

class FeeRecordIncludeList extends _i1.IncludeList {
  FeeRecordIncludeList._({
    _i1.WhereExpressionBuilder<FeeRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FeeRecord.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => FeeRecord.t;
}

class FeeRecordRepository {
  const FeeRecordRepository._();

  /// Returns a list of [FeeRecord]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<FeeRecord>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FeeRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FeeRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FeeRecordTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<FeeRecord>(
      where: where?.call(FeeRecord.t),
      orderBy: orderBy?.call(FeeRecord.t),
      orderByList: orderByList?.call(FeeRecord.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [FeeRecord] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<FeeRecord?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FeeRecordTable>? where,
    int? offset,
    _i1.OrderByBuilder<FeeRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FeeRecordTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<FeeRecord>(
      where: where?.call(FeeRecord.t),
      orderBy: orderBy?.call(FeeRecord.t),
      orderByList: orderByList?.call(FeeRecord.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [FeeRecord] by its [id] or null if no such row exists.
  Future<FeeRecord?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<FeeRecord>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [FeeRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [FeeRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<FeeRecord>> insert(
    _i1.Session session,
    List<FeeRecord> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<FeeRecord>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [FeeRecord] and returns the inserted row.
  ///
  /// The returned [FeeRecord] will have its `id` field set.
  Future<FeeRecord> insertRow(
    _i1.Session session,
    FeeRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<FeeRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [FeeRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<FeeRecord>> update(
    _i1.Session session,
    List<FeeRecord> rows, {
    _i1.ColumnSelections<FeeRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<FeeRecord>(
      rows,
      columns: columns?.call(FeeRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FeeRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FeeRecord> updateRow(
    _i1.Session session,
    FeeRecord row, {
    _i1.ColumnSelections<FeeRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<FeeRecord>(
      row,
      columns: columns?.call(FeeRecord.t),
      transaction: transaction,
    );
  }

  /// Deletes all [FeeRecord]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<FeeRecord>> delete(
    _i1.Session session,
    List<FeeRecord> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<FeeRecord>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [FeeRecord].
  Future<FeeRecord> deleteRow(
    _i1.Session session,
    FeeRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FeeRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<FeeRecord>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<FeeRecordTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<FeeRecord>(
      where: where(FeeRecord.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FeeRecordTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<FeeRecord>(
      where: where?.call(FeeRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
