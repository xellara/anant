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

abstract class TimetableEntry
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  TimetableEntry._({
    this.id,
    required this.organizationId,
    required this.classId,
    required this.subjectId,
    required this.teacherId,
    required this.dayOfWeek,
    required this.startTime,
    required this.durationMinutes,
  });

  factory TimetableEntry({
    int? id,
    required int organizationId,
    required int classId,
    required int subjectId,
    required int teacherId,
    required int dayOfWeek,
    required DateTime startTime,
    required int durationMinutes,
  }) = _TimetableEntryImpl;

  factory TimetableEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return TimetableEntry(
      id: jsonSerialization['id'] as int?,
      organizationId: jsonSerialization['organizationId'] as int,
      classId: jsonSerialization['classId'] as int,
      subjectId: jsonSerialization['subjectId'] as int,
      teacherId: jsonSerialization['teacherId'] as int,
      dayOfWeek: jsonSerialization['dayOfWeek'] as int,
      startTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startTime'],
      ),
      durationMinutes: jsonSerialization['durationMinutes'] as int,
    );
  }

  static final t = TimetableEntryTable();

  static const db = TimetableEntryRepository._();

  @override
  int? id;

  int organizationId;

  int classId;

  int subjectId;

  int teacherId;

  int dayOfWeek;

  DateTime startTime;

  int durationMinutes;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [TimetableEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TimetableEntry copyWith({
    int? id,
    int? organizationId,
    int? classId,
    int? subjectId,
    int? teacherId,
    int? dayOfWeek,
    DateTime? startTime,
    int? durationMinutes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TimetableEntry',
      if (id != null) 'id': id,
      'organizationId': organizationId,
      'classId': classId,
      'subjectId': subjectId,
      'teacherId': teacherId,
      'dayOfWeek': dayOfWeek,
      'startTime': startTime.toJson(),
      'durationMinutes': durationMinutes,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TimetableEntry',
      if (id != null) 'id': id,
      'organizationId': organizationId,
      'classId': classId,
      'subjectId': subjectId,
      'teacherId': teacherId,
      'dayOfWeek': dayOfWeek,
      'startTime': startTime.toJson(),
      'durationMinutes': durationMinutes,
    };
  }

  static TimetableEntryInclude include() {
    return TimetableEntryInclude._();
  }

  static TimetableEntryIncludeList includeList({
    _i1.WhereExpressionBuilder<TimetableEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TimetableEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TimetableEntryTable>? orderByList,
    TimetableEntryInclude? include,
  }) {
    return TimetableEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TimetableEntry.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(TimetableEntry.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TimetableEntryImpl extends TimetableEntry {
  _TimetableEntryImpl({
    int? id,
    required int organizationId,
    required int classId,
    required int subjectId,
    required int teacherId,
    required int dayOfWeek,
    required DateTime startTime,
    required int durationMinutes,
  }) : super._(
         id: id,
         organizationId: organizationId,
         classId: classId,
         subjectId: subjectId,
         teacherId: teacherId,
         dayOfWeek: dayOfWeek,
         startTime: startTime,
         durationMinutes: durationMinutes,
       );

  /// Returns a shallow copy of this [TimetableEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TimetableEntry copyWith({
    Object? id = _Undefined,
    int? organizationId,
    int? classId,
    int? subjectId,
    int? teacherId,
    int? dayOfWeek,
    DateTime? startTime,
    int? durationMinutes,
  }) {
    return TimetableEntry(
      id: id is int? ? id : this.id,
      organizationId: organizationId ?? this.organizationId,
      classId: classId ?? this.classId,
      subjectId: subjectId ?? this.subjectId,
      teacherId: teacherId ?? this.teacherId,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startTime: startTime ?? this.startTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
    );
  }
}

class TimetableEntryUpdateTable extends _i1.UpdateTable<TimetableEntryTable> {
  TimetableEntryUpdateTable(super.table);

  _i1.ColumnValue<int, int> organizationId(int value) => _i1.ColumnValue(
    table.organizationId,
    value,
  );

  _i1.ColumnValue<int, int> classId(int value) => _i1.ColumnValue(
    table.classId,
    value,
  );

  _i1.ColumnValue<int, int> subjectId(int value) => _i1.ColumnValue(
    table.subjectId,
    value,
  );

  _i1.ColumnValue<int, int> teacherId(int value) => _i1.ColumnValue(
    table.teacherId,
    value,
  );

  _i1.ColumnValue<int, int> dayOfWeek(int value) => _i1.ColumnValue(
    table.dayOfWeek,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> startTime(DateTime value) =>
      _i1.ColumnValue(
        table.startTime,
        value,
      );

  _i1.ColumnValue<int, int> durationMinutes(int value) => _i1.ColumnValue(
    table.durationMinutes,
    value,
  );
}

class TimetableEntryTable extends _i1.Table<int?> {
  TimetableEntryTable({super.tableRelation})
    : super(tableName: 'timetable_entry') {
    updateTable = TimetableEntryUpdateTable(this);
    organizationId = _i1.ColumnInt(
      'organizationId',
      this,
    );
    classId = _i1.ColumnInt(
      'classId',
      this,
    );
    subjectId = _i1.ColumnInt(
      'subjectId',
      this,
    );
    teacherId = _i1.ColumnInt(
      'teacherId',
      this,
    );
    dayOfWeek = _i1.ColumnInt(
      'dayOfWeek',
      this,
    );
    startTime = _i1.ColumnDateTime(
      'startTime',
      this,
    );
    durationMinutes = _i1.ColumnInt(
      'durationMinutes',
      this,
    );
  }

  late final TimetableEntryUpdateTable updateTable;

  late final _i1.ColumnInt organizationId;

  late final _i1.ColumnInt classId;

  late final _i1.ColumnInt subjectId;

  late final _i1.ColumnInt teacherId;

  late final _i1.ColumnInt dayOfWeek;

  late final _i1.ColumnDateTime startTime;

  late final _i1.ColumnInt durationMinutes;

  @override
  List<_i1.Column> get columns => [
    id,
    organizationId,
    classId,
    subjectId,
    teacherId,
    dayOfWeek,
    startTime,
    durationMinutes,
  ];
}

class TimetableEntryInclude extends _i1.IncludeObject {
  TimetableEntryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => TimetableEntry.t;
}

class TimetableEntryIncludeList extends _i1.IncludeList {
  TimetableEntryIncludeList._({
    _i1.WhereExpressionBuilder<TimetableEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TimetableEntry.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => TimetableEntry.t;
}

class TimetableEntryRepository {
  const TimetableEntryRepository._();

  /// Returns a list of [TimetableEntry]s matching the given query parameters.
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
  Future<List<TimetableEntry>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TimetableEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TimetableEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TimetableEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<TimetableEntry>(
      where: where?.call(TimetableEntry.t),
      orderBy: orderBy?.call(TimetableEntry.t),
      orderByList: orderByList?.call(TimetableEntry.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [TimetableEntry] matching the given query parameters.
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
  Future<TimetableEntry?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TimetableEntryTable>? where,
    int? offset,
    _i1.OrderByBuilder<TimetableEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TimetableEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<TimetableEntry>(
      where: where?.call(TimetableEntry.t),
      orderBy: orderBy?.call(TimetableEntry.t),
      orderByList: orderByList?.call(TimetableEntry.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [TimetableEntry] by its [id] or null if no such row exists.
  Future<TimetableEntry?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<TimetableEntry>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [TimetableEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [TimetableEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<TimetableEntry>> insert(
    _i1.Session session,
    List<TimetableEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<TimetableEntry>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [TimetableEntry] and returns the inserted row.
  ///
  /// The returned [TimetableEntry] will have its `id` field set.
  Future<TimetableEntry> insertRow(
    _i1.Session session,
    TimetableEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<TimetableEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [TimetableEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<TimetableEntry>> update(
    _i1.Session session,
    List<TimetableEntry> rows, {
    _i1.ColumnSelections<TimetableEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<TimetableEntry>(
      rows,
      columns: columns?.call(TimetableEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TimetableEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TimetableEntry> updateRow(
    _i1.Session session,
    TimetableEntry row, {
    _i1.ColumnSelections<TimetableEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<TimetableEntry>(
      row,
      columns: columns?.call(TimetableEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TimetableEntry] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TimetableEntry?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<TimetableEntryUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<TimetableEntry>(
      id,
      columnValues: columnValues(TimetableEntry.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TimetableEntry]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<TimetableEntry>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<TimetableEntryUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<TimetableEntryTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TimetableEntryTable>? orderBy,
    _i1.OrderByListBuilder<TimetableEntryTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<TimetableEntry>(
      columnValues: columnValues(TimetableEntry.t.updateTable),
      where: where(TimetableEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TimetableEntry.t),
      orderByList: orderByList?.call(TimetableEntry.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [TimetableEntry]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<TimetableEntry>> delete(
    _i1.Session session,
    List<TimetableEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<TimetableEntry>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [TimetableEntry].
  Future<TimetableEntry> deleteRow(
    _i1.Session session,
    TimetableEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TimetableEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<TimetableEntry>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TimetableEntryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<TimetableEntry>(
      where: where(TimetableEntry.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TimetableEntryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<TimetableEntry>(
      where: where?.call(TimetableEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
