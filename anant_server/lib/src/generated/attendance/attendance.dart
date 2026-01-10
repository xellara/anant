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

/// Attendance
abstract class Attendance
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Attendance._({
    this.id,
    required this.organizationName,
    required this.className,
    required this.sectionName,
    this.subjectName,
    required this.studentAnantId,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.markedByAnantId,
    required this.status,
    bool? isSubmitted,
    this.remarks,
  }) : isSubmitted = isSubmitted ?? false;

  factory Attendance({
    int? id,
    required String organizationName,
    required String className,
    required String sectionName,
    String? subjectName,
    required String studentAnantId,
    required String startTime,
    required String endTime,
    required String date,
    required String markedByAnantId,
    required String status,
    bool? isSubmitted,
    String? remarks,
  }) = _AttendanceImpl;

  factory Attendance.fromJson(Map<String, dynamic> jsonSerialization) {
    return Attendance(
      id: jsonSerialization['id'] as int?,
      organizationName: jsonSerialization['organizationName'] as String,
      className: jsonSerialization['className'] as String,
      sectionName: jsonSerialization['sectionName'] as String,
      subjectName: jsonSerialization['subjectName'] as String?,
      studentAnantId: jsonSerialization['studentAnantId'] as String,
      startTime: jsonSerialization['startTime'] as String,
      endTime: jsonSerialization['endTime'] as String,
      date: jsonSerialization['date'] as String,
      markedByAnantId: jsonSerialization['markedByAnantId'] as String,
      status: jsonSerialization['status'] as String,
      isSubmitted: jsonSerialization['isSubmitted'] as bool?,
      remarks: jsonSerialization['remarks'] as String?,
    );
  }

  static final t = AttendanceTable();

  static const db = AttendanceRepository._();

  @override
  int? id;

  String organizationName;

  String className;

  String sectionName;

  String? subjectName;

  String studentAnantId;

  String startTime;

  String endTime;

  String date;

  String markedByAnantId;

  String status;

  bool isSubmitted;

  String? remarks;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Attendance]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Attendance copyWith({
    int? id,
    String? organizationName,
    String? className,
    String? sectionName,
    String? subjectName,
    String? studentAnantId,
    String? startTime,
    String? endTime,
    String? date,
    String? markedByAnantId,
    String? status,
    bool? isSubmitted,
    String? remarks,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Attendance',
      if (id != null) 'id': id,
      'organizationName': organizationName,
      'className': className,
      'sectionName': sectionName,
      if (subjectName != null) 'subjectName': subjectName,
      'studentAnantId': studentAnantId,
      'startTime': startTime,
      'endTime': endTime,
      'date': date,
      'markedByAnantId': markedByAnantId,
      'status': status,
      'isSubmitted': isSubmitted,
      if (remarks != null) 'remarks': remarks,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Attendance',
      if (id != null) 'id': id,
      'organizationName': organizationName,
      'className': className,
      'sectionName': sectionName,
      if (subjectName != null) 'subjectName': subjectName,
      'studentAnantId': studentAnantId,
      'startTime': startTime,
      'endTime': endTime,
      'date': date,
      'markedByAnantId': markedByAnantId,
      'status': status,
      'isSubmitted': isSubmitted,
      if (remarks != null) 'remarks': remarks,
    };
  }

  static AttendanceInclude include() {
    return AttendanceInclude._();
  }

  static AttendanceIncludeList includeList({
    _i1.WhereExpressionBuilder<AttendanceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AttendanceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AttendanceTable>? orderByList,
    AttendanceInclude? include,
  }) {
    return AttendanceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Attendance.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Attendance.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AttendanceImpl extends Attendance {
  _AttendanceImpl({
    int? id,
    required String organizationName,
    required String className,
    required String sectionName,
    String? subjectName,
    required String studentAnantId,
    required String startTime,
    required String endTime,
    required String date,
    required String markedByAnantId,
    required String status,
    bool? isSubmitted,
    String? remarks,
  }) : super._(
         id: id,
         organizationName: organizationName,
         className: className,
         sectionName: sectionName,
         subjectName: subjectName,
         studentAnantId: studentAnantId,
         startTime: startTime,
         endTime: endTime,
         date: date,
         markedByAnantId: markedByAnantId,
         status: status,
         isSubmitted: isSubmitted,
         remarks: remarks,
       );

  /// Returns a shallow copy of this [Attendance]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Attendance copyWith({
    Object? id = _Undefined,
    String? organizationName,
    String? className,
    String? sectionName,
    Object? subjectName = _Undefined,
    String? studentAnantId,
    String? startTime,
    String? endTime,
    String? date,
    String? markedByAnantId,
    String? status,
    bool? isSubmitted,
    Object? remarks = _Undefined,
  }) {
    return Attendance(
      id: id is int? ? id : this.id,
      organizationName: organizationName ?? this.organizationName,
      className: className ?? this.className,
      sectionName: sectionName ?? this.sectionName,
      subjectName: subjectName is String? ? subjectName : this.subjectName,
      studentAnantId: studentAnantId ?? this.studentAnantId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      date: date ?? this.date,
      markedByAnantId: markedByAnantId ?? this.markedByAnantId,
      status: status ?? this.status,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      remarks: remarks is String? ? remarks : this.remarks,
    );
  }
}

class AttendanceUpdateTable extends _i1.UpdateTable<AttendanceTable> {
  AttendanceUpdateTable(super.table);

  _i1.ColumnValue<String, String> organizationName(String value) =>
      _i1.ColumnValue(
        table.organizationName,
        value,
      );

  _i1.ColumnValue<String, String> className(String value) => _i1.ColumnValue(
    table.className,
    value,
  );

  _i1.ColumnValue<String, String> sectionName(String value) => _i1.ColumnValue(
    table.sectionName,
    value,
  );

  _i1.ColumnValue<String, String> subjectName(String? value) => _i1.ColumnValue(
    table.subjectName,
    value,
  );

  _i1.ColumnValue<String, String> studentAnantId(String value) =>
      _i1.ColumnValue(
        table.studentAnantId,
        value,
      );

  _i1.ColumnValue<String, String> startTime(String value) => _i1.ColumnValue(
    table.startTime,
    value,
  );

  _i1.ColumnValue<String, String> endTime(String value) => _i1.ColumnValue(
    table.endTime,
    value,
  );

  _i1.ColumnValue<String, String> date(String value) => _i1.ColumnValue(
    table.date,
    value,
  );

  _i1.ColumnValue<String, String> markedByAnantId(String value) =>
      _i1.ColumnValue(
        table.markedByAnantId,
        value,
      );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<bool, bool> isSubmitted(bool value) => _i1.ColumnValue(
    table.isSubmitted,
    value,
  );

  _i1.ColumnValue<String, String> remarks(String? value) => _i1.ColumnValue(
    table.remarks,
    value,
  );
}

class AttendanceTable extends _i1.Table<int?> {
  AttendanceTable({super.tableRelation}) : super(tableName: 'attendance') {
    updateTable = AttendanceUpdateTable(this);
    organizationName = _i1.ColumnString(
      'organizationName',
      this,
    );
    className = _i1.ColumnString(
      'className',
      this,
    );
    sectionName = _i1.ColumnString(
      'sectionName',
      this,
    );
    subjectName = _i1.ColumnString(
      'subjectName',
      this,
    );
    studentAnantId = _i1.ColumnString(
      'studentAnantId',
      this,
    );
    startTime = _i1.ColumnString(
      'startTime',
      this,
    );
    endTime = _i1.ColumnString(
      'endTime',
      this,
    );
    date = _i1.ColumnString(
      'date',
      this,
    );
    markedByAnantId = _i1.ColumnString(
      'markedByAnantId',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    isSubmitted = _i1.ColumnBool(
      'isSubmitted',
      this,
      hasDefault: true,
    );
    remarks = _i1.ColumnString(
      'remarks',
      this,
    );
  }

  late final AttendanceUpdateTable updateTable;

  late final _i1.ColumnString organizationName;

  late final _i1.ColumnString className;

  late final _i1.ColumnString sectionName;

  late final _i1.ColumnString subjectName;

  late final _i1.ColumnString studentAnantId;

  late final _i1.ColumnString startTime;

  late final _i1.ColumnString endTime;

  late final _i1.ColumnString date;

  late final _i1.ColumnString markedByAnantId;

  late final _i1.ColumnString status;

  late final _i1.ColumnBool isSubmitted;

  late final _i1.ColumnString remarks;

  @override
  List<_i1.Column> get columns => [
    id,
    organizationName,
    className,
    sectionName,
    subjectName,
    studentAnantId,
    startTime,
    endTime,
    date,
    markedByAnantId,
    status,
    isSubmitted,
    remarks,
  ];
}

class AttendanceInclude extends _i1.IncludeObject {
  AttendanceInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Attendance.t;
}

class AttendanceIncludeList extends _i1.IncludeList {
  AttendanceIncludeList._({
    _i1.WhereExpressionBuilder<AttendanceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Attendance.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Attendance.t;
}

class AttendanceRepository {
  const AttendanceRepository._();

  /// Returns a list of [Attendance]s matching the given query parameters.
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
  Future<List<Attendance>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AttendanceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AttendanceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AttendanceTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Attendance>(
      where: where?.call(Attendance.t),
      orderBy: orderBy?.call(Attendance.t),
      orderByList: orderByList?.call(Attendance.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Attendance] matching the given query parameters.
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
  Future<Attendance?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AttendanceTable>? where,
    int? offset,
    _i1.OrderByBuilder<AttendanceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AttendanceTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Attendance>(
      where: where?.call(Attendance.t),
      orderBy: orderBy?.call(Attendance.t),
      orderByList: orderByList?.call(Attendance.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Attendance] by its [id] or null if no such row exists.
  Future<Attendance?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Attendance>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Attendance]s in the list and returns the inserted rows.
  ///
  /// The returned [Attendance]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Attendance>> insert(
    _i1.Session session,
    List<Attendance> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Attendance>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Attendance] and returns the inserted row.
  ///
  /// The returned [Attendance] will have its `id` field set.
  Future<Attendance> insertRow(
    _i1.Session session,
    Attendance row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Attendance>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Attendance]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Attendance>> update(
    _i1.Session session,
    List<Attendance> rows, {
    _i1.ColumnSelections<AttendanceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Attendance>(
      rows,
      columns: columns?.call(Attendance.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Attendance]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Attendance> updateRow(
    _i1.Session session,
    Attendance row, {
    _i1.ColumnSelections<AttendanceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Attendance>(
      row,
      columns: columns?.call(Attendance.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Attendance] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Attendance?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<AttendanceUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Attendance>(
      id,
      columnValues: columnValues(Attendance.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Attendance]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Attendance>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<AttendanceUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AttendanceTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AttendanceTable>? orderBy,
    _i1.OrderByListBuilder<AttendanceTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Attendance>(
      columnValues: columnValues(Attendance.t.updateTable),
      where: where(Attendance.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Attendance.t),
      orderByList: orderByList?.call(Attendance.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Attendance]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Attendance>> delete(
    _i1.Session session,
    List<Attendance> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Attendance>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Attendance].
  Future<Attendance> deleteRow(
    _i1.Session session,
    Attendance row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Attendance>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Attendance>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AttendanceTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Attendance>(
      where: where(Attendance.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AttendanceTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Attendance>(
      where: where?.call(Attendance.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
