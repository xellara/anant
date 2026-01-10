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

/// StudentCourseEnrollment
abstract class StudentCourseEnrollment
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  StudentCourseEnrollment._({
    this.id,
    required this.studentAnantId,
    required this.courseName,
    this.organizationId,
    required this.enrolledOn,
  });

  factory StudentCourseEnrollment({
    int? id,
    required String studentAnantId,
    required String courseName,
    int? organizationId,
    required DateTime enrolledOn,
  }) = _StudentCourseEnrollmentImpl;

  factory StudentCourseEnrollment.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return StudentCourseEnrollment(
      id: jsonSerialization['id'] as int?,
      studentAnantId: jsonSerialization['studentAnantId'] as String,
      courseName: jsonSerialization['courseName'] as String,
      organizationId: jsonSerialization['organizationId'] as int?,
      enrolledOn: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['enrolledOn'],
      ),
    );
  }

  static final t = StudentCourseEnrollmentTable();

  static const db = StudentCourseEnrollmentRepository._();

  @override
  int? id;

  String studentAnantId;

  String courseName;

  int? organizationId;

  DateTime enrolledOn;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [StudentCourseEnrollment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  StudentCourseEnrollment copyWith({
    int? id,
    String? studentAnantId,
    String? courseName,
    int? organizationId,
    DateTime? enrolledOn,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StudentCourseEnrollment',
      if (id != null) 'id': id,
      'studentAnantId': studentAnantId,
      'courseName': courseName,
      if (organizationId != null) 'organizationId': organizationId,
      'enrolledOn': enrolledOn.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StudentCourseEnrollment',
      if (id != null) 'id': id,
      'studentAnantId': studentAnantId,
      'courseName': courseName,
      if (organizationId != null) 'organizationId': organizationId,
      'enrolledOn': enrolledOn.toJson(),
    };
  }

  static StudentCourseEnrollmentInclude include() {
    return StudentCourseEnrollmentInclude._();
  }

  static StudentCourseEnrollmentIncludeList includeList({
    _i1.WhereExpressionBuilder<StudentCourseEnrollmentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StudentCourseEnrollmentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StudentCourseEnrollmentTable>? orderByList,
    StudentCourseEnrollmentInclude? include,
  }) {
    return StudentCourseEnrollmentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StudentCourseEnrollment.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(StudentCourseEnrollment.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StudentCourseEnrollmentImpl extends StudentCourseEnrollment {
  _StudentCourseEnrollmentImpl({
    int? id,
    required String studentAnantId,
    required String courseName,
    int? organizationId,
    required DateTime enrolledOn,
  }) : super._(
         id: id,
         studentAnantId: studentAnantId,
         courseName: courseName,
         organizationId: organizationId,
         enrolledOn: enrolledOn,
       );

  /// Returns a shallow copy of this [StudentCourseEnrollment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  StudentCourseEnrollment copyWith({
    Object? id = _Undefined,
    String? studentAnantId,
    String? courseName,
    Object? organizationId = _Undefined,
    DateTime? enrolledOn,
  }) {
    return StudentCourseEnrollment(
      id: id is int? ? id : this.id,
      studentAnantId: studentAnantId ?? this.studentAnantId,
      courseName: courseName ?? this.courseName,
      organizationId: organizationId is int?
          ? organizationId
          : this.organizationId,
      enrolledOn: enrolledOn ?? this.enrolledOn,
    );
  }
}

class StudentCourseEnrollmentUpdateTable
    extends _i1.UpdateTable<StudentCourseEnrollmentTable> {
  StudentCourseEnrollmentUpdateTable(super.table);

  _i1.ColumnValue<String, String> studentAnantId(String value) =>
      _i1.ColumnValue(
        table.studentAnantId,
        value,
      );

  _i1.ColumnValue<String, String> courseName(String value) => _i1.ColumnValue(
    table.courseName,
    value,
  );

  _i1.ColumnValue<int, int> organizationId(int? value) => _i1.ColumnValue(
    table.organizationId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> enrolledOn(DateTime value) =>
      _i1.ColumnValue(
        table.enrolledOn,
        value,
      );
}

class StudentCourseEnrollmentTable extends _i1.Table<int?> {
  StudentCourseEnrollmentTable({super.tableRelation})
    : super(tableName: 'student_course_enrollment') {
    updateTable = StudentCourseEnrollmentUpdateTable(this);
    studentAnantId = _i1.ColumnString(
      'studentAnantId',
      this,
    );
    courseName = _i1.ColumnString(
      'courseName',
      this,
    );
    organizationId = _i1.ColumnInt(
      'organizationId',
      this,
    );
    enrolledOn = _i1.ColumnDateTime(
      'enrolledOn',
      this,
    );
  }

  late final StudentCourseEnrollmentUpdateTable updateTable;

  late final _i1.ColumnString studentAnantId;

  late final _i1.ColumnString courseName;

  late final _i1.ColumnInt organizationId;

  late final _i1.ColumnDateTime enrolledOn;

  @override
  List<_i1.Column> get columns => [
    id,
    studentAnantId,
    courseName,
    organizationId,
    enrolledOn,
  ];
}

class StudentCourseEnrollmentInclude extends _i1.IncludeObject {
  StudentCourseEnrollmentInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => StudentCourseEnrollment.t;
}

class StudentCourseEnrollmentIncludeList extends _i1.IncludeList {
  StudentCourseEnrollmentIncludeList._({
    _i1.WhereExpressionBuilder<StudentCourseEnrollmentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(StudentCourseEnrollment.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => StudentCourseEnrollment.t;
}

class StudentCourseEnrollmentRepository {
  const StudentCourseEnrollmentRepository._();

  /// Returns a list of [StudentCourseEnrollment]s matching the given query parameters.
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
  Future<List<StudentCourseEnrollment>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StudentCourseEnrollmentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StudentCourseEnrollmentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StudentCourseEnrollmentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<StudentCourseEnrollment>(
      where: where?.call(StudentCourseEnrollment.t),
      orderBy: orderBy?.call(StudentCourseEnrollment.t),
      orderByList: orderByList?.call(StudentCourseEnrollment.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [StudentCourseEnrollment] matching the given query parameters.
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
  Future<StudentCourseEnrollment?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StudentCourseEnrollmentTable>? where,
    int? offset,
    _i1.OrderByBuilder<StudentCourseEnrollmentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StudentCourseEnrollmentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<StudentCourseEnrollment>(
      where: where?.call(StudentCourseEnrollment.t),
      orderBy: orderBy?.call(StudentCourseEnrollment.t),
      orderByList: orderByList?.call(StudentCourseEnrollment.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [StudentCourseEnrollment] by its [id] or null if no such row exists.
  Future<StudentCourseEnrollment?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<StudentCourseEnrollment>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [StudentCourseEnrollment]s in the list and returns the inserted rows.
  ///
  /// The returned [StudentCourseEnrollment]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<StudentCourseEnrollment>> insert(
    _i1.Session session,
    List<StudentCourseEnrollment> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<StudentCourseEnrollment>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [StudentCourseEnrollment] and returns the inserted row.
  ///
  /// The returned [StudentCourseEnrollment] will have its `id` field set.
  Future<StudentCourseEnrollment> insertRow(
    _i1.Session session,
    StudentCourseEnrollment row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<StudentCourseEnrollment>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [StudentCourseEnrollment]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<StudentCourseEnrollment>> update(
    _i1.Session session,
    List<StudentCourseEnrollment> rows, {
    _i1.ColumnSelections<StudentCourseEnrollmentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<StudentCourseEnrollment>(
      rows,
      columns: columns?.call(StudentCourseEnrollment.t),
      transaction: transaction,
    );
  }

  /// Updates a single [StudentCourseEnrollment]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<StudentCourseEnrollment> updateRow(
    _i1.Session session,
    StudentCourseEnrollment row, {
    _i1.ColumnSelections<StudentCourseEnrollmentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<StudentCourseEnrollment>(
      row,
      columns: columns?.call(StudentCourseEnrollment.t),
      transaction: transaction,
    );
  }

  /// Updates a single [StudentCourseEnrollment] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<StudentCourseEnrollment?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<StudentCourseEnrollmentUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<StudentCourseEnrollment>(
      id,
      columnValues: columnValues(StudentCourseEnrollment.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [StudentCourseEnrollment]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<StudentCourseEnrollment>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<StudentCourseEnrollmentUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<StudentCourseEnrollmentTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StudentCourseEnrollmentTable>? orderBy,
    _i1.OrderByListBuilder<StudentCourseEnrollmentTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<StudentCourseEnrollment>(
      columnValues: columnValues(StudentCourseEnrollment.t.updateTable),
      where: where(StudentCourseEnrollment.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StudentCourseEnrollment.t),
      orderByList: orderByList?.call(StudentCourseEnrollment.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [StudentCourseEnrollment]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<StudentCourseEnrollment>> delete(
    _i1.Session session,
    List<StudentCourseEnrollment> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<StudentCourseEnrollment>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [StudentCourseEnrollment].
  Future<StudentCourseEnrollment> deleteRow(
    _i1.Session session,
    StudentCourseEnrollment row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<StudentCourseEnrollment>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<StudentCourseEnrollment>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<StudentCourseEnrollmentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<StudentCourseEnrollment>(
      where: where(StudentCourseEnrollment.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StudentCourseEnrollmentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<StudentCourseEnrollment>(
      where: where?.call(StudentCourseEnrollment.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
