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

/// Class
abstract class Classes
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Classes._({
    this.id,
    this.organizationId,
    required this.name,
    required this.academicYear,
    this.courseName,
    this.classTeacherAnantId,
    this.startDate,
    this.endDate,
    bool? isActive,
  }) : isActive = isActive ?? true;

  factory Classes({
    int? id,
    int? organizationId,
    required String name,
    required String academicYear,
    String? courseName,
    String? classTeacherAnantId,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
  }) = _ClassesImpl;

  factory Classes.fromJson(Map<String, dynamic> jsonSerialization) {
    return Classes(
      id: jsonSerialization['id'] as int?,
      organizationId: jsonSerialization['organizationId'] as int?,
      name: jsonSerialization['name'] as String,
      academicYear: jsonSerialization['academicYear'] as String,
      courseName: jsonSerialization['courseName'] as String?,
      classTeacherAnantId: jsonSerialization['classTeacherAnantId'] as String?,
      startDate: jsonSerialization['startDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['startDate']),
      endDate: jsonSerialization['endDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      isActive: jsonSerialization['isActive'] as bool?,
    );
  }

  static final t = ClassesTable();

  static const db = ClassesRepository._();

  @override
  int? id;

  int? organizationId;

  String name;

  String academicYear;

  String? courseName;

  String? classTeacherAnantId;

  DateTime? startDate;

  DateTime? endDate;

  bool isActive;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Classes]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Classes copyWith({
    int? id,
    int? organizationId,
    String? name,
    String? academicYear,
    String? courseName,
    String? classTeacherAnantId,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Classes',
      if (id != null) 'id': id,
      if (organizationId != null) 'organizationId': organizationId,
      'name': name,
      'academicYear': academicYear,
      if (courseName != null) 'courseName': courseName,
      if (classTeacherAnantId != null)
        'classTeacherAnantId': classTeacherAnantId,
      if (startDate != null) 'startDate': startDate?.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      'isActive': isActive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Classes',
      if (id != null) 'id': id,
      if (organizationId != null) 'organizationId': organizationId,
      'name': name,
      'academicYear': academicYear,
      if (courseName != null) 'courseName': courseName,
      if (classTeacherAnantId != null)
        'classTeacherAnantId': classTeacherAnantId,
      if (startDate != null) 'startDate': startDate?.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      'isActive': isActive,
    };
  }

  static ClassesInclude include() {
    return ClassesInclude._();
  }

  static ClassesIncludeList includeList({
    _i1.WhereExpressionBuilder<ClassesTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ClassesTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ClassesTable>? orderByList,
    ClassesInclude? include,
  }) {
    return ClassesIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Classes.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Classes.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ClassesImpl extends Classes {
  _ClassesImpl({
    int? id,
    int? organizationId,
    required String name,
    required String academicYear,
    String? courseName,
    String? classTeacherAnantId,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
  }) : super._(
         id: id,
         organizationId: organizationId,
         name: name,
         academicYear: academicYear,
         courseName: courseName,
         classTeacherAnantId: classTeacherAnantId,
         startDate: startDate,
         endDate: endDate,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [Classes]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Classes copyWith({
    Object? id = _Undefined,
    Object? organizationId = _Undefined,
    String? name,
    String? academicYear,
    Object? courseName = _Undefined,
    Object? classTeacherAnantId = _Undefined,
    Object? startDate = _Undefined,
    Object? endDate = _Undefined,
    bool? isActive,
  }) {
    return Classes(
      id: id is int? ? id : this.id,
      organizationId: organizationId is int?
          ? organizationId
          : this.organizationId,
      name: name ?? this.name,
      academicYear: academicYear ?? this.academicYear,
      courseName: courseName is String? ? courseName : this.courseName,
      classTeacherAnantId: classTeacherAnantId is String?
          ? classTeacherAnantId
          : this.classTeacherAnantId,
      startDate: startDate is DateTime? ? startDate : this.startDate,
      endDate: endDate is DateTime? ? endDate : this.endDate,
      isActive: isActive ?? this.isActive,
    );
  }
}

class ClassesUpdateTable extends _i1.UpdateTable<ClassesTable> {
  ClassesUpdateTable(super.table);

  _i1.ColumnValue<int, int> organizationId(int? value) => _i1.ColumnValue(
    table.organizationId,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> academicYear(String value) => _i1.ColumnValue(
    table.academicYear,
    value,
  );

  _i1.ColumnValue<String, String> courseName(String? value) => _i1.ColumnValue(
    table.courseName,
    value,
  );

  _i1.ColumnValue<String, String> classTeacherAnantId(String? value) =>
      _i1.ColumnValue(
        table.classTeacherAnantId,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> startDate(DateTime? value) =>
      _i1.ColumnValue(
        table.startDate,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> endDate(DateTime? value) =>
      _i1.ColumnValue(
        table.endDate,
        value,
      );

  _i1.ColumnValue<bool, bool> isActive(bool value) => _i1.ColumnValue(
    table.isActive,
    value,
  );
}

class ClassesTable extends _i1.Table<int?> {
  ClassesTable({super.tableRelation}) : super(tableName: 'class') {
    updateTable = ClassesUpdateTable(this);
    organizationId = _i1.ColumnInt(
      'organizationId',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    academicYear = _i1.ColumnString(
      'academicYear',
      this,
    );
    courseName = _i1.ColumnString(
      'courseName',
      this,
    );
    classTeacherAnantId = _i1.ColumnString(
      'classTeacherAnantId',
      this,
    );
    startDate = _i1.ColumnDateTime(
      'startDate',
      this,
    );
    endDate = _i1.ColumnDateTime(
      'endDate',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
      hasDefault: true,
    );
  }

  late final ClassesUpdateTable updateTable;

  late final _i1.ColumnInt organizationId;

  late final _i1.ColumnString name;

  late final _i1.ColumnString academicYear;

  late final _i1.ColumnString courseName;

  late final _i1.ColumnString classTeacherAnantId;

  late final _i1.ColumnDateTime startDate;

  late final _i1.ColumnDateTime endDate;

  late final _i1.ColumnBool isActive;

  @override
  List<_i1.Column> get columns => [
    id,
    organizationId,
    name,
    academicYear,
    courseName,
    classTeacherAnantId,
    startDate,
    endDate,
    isActive,
  ];
}

class ClassesInclude extends _i1.IncludeObject {
  ClassesInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Classes.t;
}

class ClassesIncludeList extends _i1.IncludeList {
  ClassesIncludeList._({
    _i1.WhereExpressionBuilder<ClassesTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Classes.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Classes.t;
}

class ClassesRepository {
  const ClassesRepository._();

  /// Returns a list of [Classes]s matching the given query parameters.
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
  Future<List<Classes>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ClassesTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ClassesTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ClassesTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Classes>(
      where: where?.call(Classes.t),
      orderBy: orderBy?.call(Classes.t),
      orderByList: orderByList?.call(Classes.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Classes] matching the given query parameters.
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
  Future<Classes?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ClassesTable>? where,
    int? offset,
    _i1.OrderByBuilder<ClassesTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ClassesTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Classes>(
      where: where?.call(Classes.t),
      orderBy: orderBy?.call(Classes.t),
      orderByList: orderByList?.call(Classes.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Classes] by its [id] or null if no such row exists.
  Future<Classes?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Classes>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Classes]s in the list and returns the inserted rows.
  ///
  /// The returned [Classes]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Classes>> insert(
    _i1.Session session,
    List<Classes> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Classes>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Classes] and returns the inserted row.
  ///
  /// The returned [Classes] will have its `id` field set.
  Future<Classes> insertRow(
    _i1.Session session,
    Classes row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Classes>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Classes]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Classes>> update(
    _i1.Session session,
    List<Classes> rows, {
    _i1.ColumnSelections<ClassesTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Classes>(
      rows,
      columns: columns?.call(Classes.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Classes]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Classes> updateRow(
    _i1.Session session,
    Classes row, {
    _i1.ColumnSelections<ClassesTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Classes>(
      row,
      columns: columns?.call(Classes.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Classes] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Classes?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ClassesUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Classes>(
      id,
      columnValues: columnValues(Classes.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Classes]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Classes>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ClassesUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ClassesTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ClassesTable>? orderBy,
    _i1.OrderByListBuilder<ClassesTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Classes>(
      columnValues: columnValues(Classes.t.updateTable),
      where: where(Classes.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Classes.t),
      orderByList: orderByList?.call(Classes.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Classes]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Classes>> delete(
    _i1.Session session,
    List<Classes> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Classes>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Classes].
  Future<Classes> deleteRow(
    _i1.Session session,
    Classes row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Classes>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Classes>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ClassesTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Classes>(
      where: where(Classes.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ClassesTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Classes>(
      where: where?.call(Classes.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
