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

abstract class MonthlyFeeTransaction
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = MonthlyFeeTransactionTable();

  static const db = MonthlyFeeTransactionRepository._();

  @override
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

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static MonthlyFeeTransactionInclude include() {
    return MonthlyFeeTransactionInclude._();
  }

  static MonthlyFeeTransactionIncludeList includeList({
    _i1.WhereExpressionBuilder<MonthlyFeeTransactionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MonthlyFeeTransactionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MonthlyFeeTransactionTable>? orderByList,
    MonthlyFeeTransactionInclude? include,
  }) {
    return MonthlyFeeTransactionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MonthlyFeeTransaction.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(MonthlyFeeTransaction.t),
      include: include,
    );
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

class MonthlyFeeTransactionTable extends _i1.Table<int?> {
  MonthlyFeeTransactionTable({super.tableRelation})
      : super(tableName: 'monthly_fee_transaction') {
    anantId = _i1.ColumnString(
      'anantId',
      this,
    );
    organizationName = _i1.ColumnString(
      'organizationName',
      this,
    );
    month = _i1.ColumnString(
      'month',
      this,
    );
    feeAmount = _i1.ColumnDouble(
      'feeAmount',
      this,
    );
    discount = _i1.ColumnDouble(
      'discount',
      this,
    );
    fine = _i1.ColumnDouble(
      'fine',
      this,
    );
    transactionDate = _i1.ColumnDateTime(
      'transactionDate',
      this,
    );
    transactionGateway = _i1.ColumnString(
      'transactionGateway',
      this,
    );
    transactionRef = _i1.ColumnString(
      'transactionRef',
      this,
    );
    transactionId = _i1.ColumnString(
      'transactionId',
      this,
    );
    transactionStatus = _i1.ColumnString(
      'transactionStatus',
      this,
    );
    transactionType = _i1.ColumnString(
      'transactionType',
      this,
    );
    markedByAnantId = _i1.ColumnString(
      'markedByAnantId',
      this,
    );
    isRefunded = _i1.ColumnBool(
      'isRefunded',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnString anantId;

  late final _i1.ColumnString organizationName;

  late final _i1.ColumnString month;

  late final _i1.ColumnDouble feeAmount;

  late final _i1.ColumnDouble discount;

  late final _i1.ColumnDouble fine;

  late final _i1.ColumnDateTime transactionDate;

  late final _i1.ColumnString transactionGateway;

  late final _i1.ColumnString transactionRef;

  late final _i1.ColumnString transactionId;

  late final _i1.ColumnString transactionStatus;

  late final _i1.ColumnString transactionType;

  late final _i1.ColumnString markedByAnantId;

  late final _i1.ColumnBool isRefunded;

  @override
  List<_i1.Column> get columns => [
        id,
        anantId,
        organizationName,
        month,
        feeAmount,
        discount,
        fine,
        transactionDate,
        transactionGateway,
        transactionRef,
        transactionId,
        transactionStatus,
        transactionType,
        markedByAnantId,
        isRefunded,
      ];
}

class MonthlyFeeTransactionInclude extends _i1.IncludeObject {
  MonthlyFeeTransactionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => MonthlyFeeTransaction.t;
}

class MonthlyFeeTransactionIncludeList extends _i1.IncludeList {
  MonthlyFeeTransactionIncludeList._({
    _i1.WhereExpressionBuilder<MonthlyFeeTransactionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MonthlyFeeTransaction.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => MonthlyFeeTransaction.t;
}

class MonthlyFeeTransactionRepository {
  const MonthlyFeeTransactionRepository._();

  /// Returns a list of [MonthlyFeeTransaction]s matching the given query parameters.
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
  Future<List<MonthlyFeeTransaction>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MonthlyFeeTransactionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MonthlyFeeTransactionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MonthlyFeeTransactionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<MonthlyFeeTransaction>(
      where: where?.call(MonthlyFeeTransaction.t),
      orderBy: orderBy?.call(MonthlyFeeTransaction.t),
      orderByList: orderByList?.call(MonthlyFeeTransaction.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [MonthlyFeeTransaction] matching the given query parameters.
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
  Future<MonthlyFeeTransaction?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MonthlyFeeTransactionTable>? where,
    int? offset,
    _i1.OrderByBuilder<MonthlyFeeTransactionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MonthlyFeeTransactionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<MonthlyFeeTransaction>(
      where: where?.call(MonthlyFeeTransaction.t),
      orderBy: orderBy?.call(MonthlyFeeTransaction.t),
      orderByList: orderByList?.call(MonthlyFeeTransaction.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [MonthlyFeeTransaction] by its [id] or null if no such row exists.
  Future<MonthlyFeeTransaction?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<MonthlyFeeTransaction>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [MonthlyFeeTransaction]s in the list and returns the inserted rows.
  ///
  /// The returned [MonthlyFeeTransaction]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<MonthlyFeeTransaction>> insert(
    _i1.Session session,
    List<MonthlyFeeTransaction> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<MonthlyFeeTransaction>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [MonthlyFeeTransaction] and returns the inserted row.
  ///
  /// The returned [MonthlyFeeTransaction] will have its `id` field set.
  Future<MonthlyFeeTransaction> insertRow(
    _i1.Session session,
    MonthlyFeeTransaction row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<MonthlyFeeTransaction>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [MonthlyFeeTransaction]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<MonthlyFeeTransaction>> update(
    _i1.Session session,
    List<MonthlyFeeTransaction> rows, {
    _i1.ColumnSelections<MonthlyFeeTransactionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<MonthlyFeeTransaction>(
      rows,
      columns: columns?.call(MonthlyFeeTransaction.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MonthlyFeeTransaction]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MonthlyFeeTransaction> updateRow(
    _i1.Session session,
    MonthlyFeeTransaction row, {
    _i1.ColumnSelections<MonthlyFeeTransactionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<MonthlyFeeTransaction>(
      row,
      columns: columns?.call(MonthlyFeeTransaction.t),
      transaction: transaction,
    );
  }

  /// Deletes all [MonthlyFeeTransaction]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<MonthlyFeeTransaction>> delete(
    _i1.Session session,
    List<MonthlyFeeTransaction> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<MonthlyFeeTransaction>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [MonthlyFeeTransaction].
  Future<MonthlyFeeTransaction> deleteRow(
    _i1.Session session,
    MonthlyFeeTransaction row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MonthlyFeeTransaction>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<MonthlyFeeTransaction>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<MonthlyFeeTransactionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<MonthlyFeeTransaction>(
      where: where(MonthlyFeeTransaction.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MonthlyFeeTransactionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<MonthlyFeeTransaction>(
      where: where?.call(MonthlyFeeTransaction.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
