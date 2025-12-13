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

/// Course
abstract class Course implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Course._({
    this.id,
    this.organizationId,
    this.department,
    required this.name,
    this.code,
    this.description,
    this.semester,
    this.academicYear,
    this.credits,
    bool? isElective,
    bool? isActive,
  })  : isElective = isElective ?? false,
        isActive = isActive ?? true;

  factory Course({
    int? id,
    int? organizationId,
    String? department,
    required String name,
    String? code,
    String? description,
    int? semester,
    String? academicYear,
    int? credits,
    bool? isElective,
    bool? isActive,
  }) = _CourseImpl;

  factory Course.fromJson(Map<String, dynamic> jsonSerialization) {
    return Course(
      id: jsonSerialization['id'] as int?,
      organizationId: jsonSerialization['organizationId'] as int?,
      department: jsonSerialization['department'] as String?,
      name: jsonSerialization['name'] as String,
      code: jsonSerialization['code'] as String?,
      description: jsonSerialization['description'] as String?,
      semester: jsonSerialization['semester'] as int?,
      academicYear: jsonSerialization['academicYear'] as String?,
      credits: jsonSerialization['credits'] as int?,
      isElective: jsonSerialization['isElective'] as bool,
      isActive: jsonSerialization['isActive'] as bool,
    );
  }

  static final t = CourseTable();

  static const db = CourseRepository._();

  @override
  int? id;

  int? organizationId;

  String? department;

  String name;

  String? code;

  String? description;

  int? semester;

  String? academicYear;

  int? credits;

  bool isElective;

  bool isActive;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Course]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Course copyWith({
    int? id,
    int? organizationId,
    String? department,
    String? name,
    String? code,
    String? description,
    int? semester,
    String? academicYear,
    int? credits,
    bool? isElective,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (organizationId != null) 'organizationId': organizationId,
      if (department != null) 'department': department,
      'name': name,
      if (code != null) 'code': code,
      if (description != null) 'description': description,
      if (semester != null) 'semester': semester,
      if (academicYear != null) 'academicYear': academicYear,
      if (credits != null) 'credits': credits,
      'isElective': isElective,
      'isActive': isActive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      if (organizationId != null) 'organizationId': organizationId,
      if (department != null) 'department': department,
      'name': name,
      if (code != null) 'code': code,
      if (description != null) 'description': description,
      if (semester != null) 'semester': semester,
      if (academicYear != null) 'academicYear': academicYear,
      if (credits != null) 'credits': credits,
      'isElective': isElective,
      'isActive': isActive,
    };
  }

  static CourseInclude include() {
    return CourseInclude._();
  }

  static CourseIncludeList includeList({
    _i1.WhereExpressionBuilder<CourseTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CourseTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CourseTable>? orderByList,
    CourseInclude? include,
  }) {
    return CourseIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Course.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Course.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CourseImpl extends Course {
  _CourseImpl({
    int? id,
    int? organizationId,
    String? department,
    required String name,
    String? code,
    String? description,
    int? semester,
    String? academicYear,
    int? credits,
    bool? isElective,
    bool? isActive,
  }) : super._(
          id: id,
          organizationId: organizationId,
          department: department,
          name: name,
          code: code,
          description: description,
          semester: semester,
          academicYear: academicYear,
          credits: credits,
          isElective: isElective,
          isActive: isActive,
        );

  /// Returns a shallow copy of this [Course]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Course copyWith({
    Object? id = _Undefined,
    Object? organizationId = _Undefined,
    Object? department = _Undefined,
    String? name,
    Object? code = _Undefined,
    Object? description = _Undefined,
    Object? semester = _Undefined,
    Object? academicYear = _Undefined,
    Object? credits = _Undefined,
    bool? isElective,
    bool? isActive,
  }) {
    return Course(
      id: id is int? ? id : this.id,
      organizationId:
          organizationId is int? ? organizationId : this.organizationId,
      department: department is String? ? department : this.department,
      name: name ?? this.name,
      code: code is String? ? code : this.code,
      description: description is String? ? description : this.description,
      semester: semester is int? ? semester : this.semester,
      academicYear: academicYear is String? ? academicYear : this.academicYear,
      credits: credits is int? ? credits : this.credits,
      isElective: isElective ?? this.isElective,
      isActive: isActive ?? this.isActive,
    );
  }
}

class CourseTable extends _i1.Table<int?> {
  CourseTable({super.tableRelation}) : super(tableName: 'course') {
    organizationId = _i1.ColumnInt(
      'organizationId',
      this,
    );
    department = _i1.ColumnString(
      'department',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    code = _i1.ColumnString(
      'code',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    semester = _i1.ColumnInt(
      'semester',
      this,
    );
    academicYear = _i1.ColumnString(
      'academicYear',
      this,
    );
    credits = _i1.ColumnInt(
      'credits',
      this,
    );
    isElective = _i1.ColumnBool(
      'isElective',
      this,
      hasDefault: true,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnInt organizationId;

  late final _i1.ColumnString department;

  late final _i1.ColumnString name;

  late final _i1.ColumnString code;

  late final _i1.ColumnString description;

  late final _i1.ColumnInt semester;

  late final _i1.ColumnString academicYear;

  late final _i1.ColumnInt credits;

  late final _i1.ColumnBool isElective;

  late final _i1.ColumnBool isActive;

  @override
  List<_i1.Column> get columns => [
        id,
        organizationId,
        department,
        name,
        code,
        description,
        semester,
        academicYear,
        credits,
        isElective,
        isActive,
      ];
}

class CourseInclude extends _i1.IncludeObject {
  CourseInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Course.t;
}

class CourseIncludeList extends _i1.IncludeList {
  CourseIncludeList._({
    _i1.WhereExpressionBuilder<CourseTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Course.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Course.t;
}

class CourseRepository {
  const CourseRepository._();

  /// Returns a list of [Course]s matching the given query parameters.
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
  Future<List<Course>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CourseTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CourseTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CourseTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Course>(
      where: where?.call(Course.t),
      orderBy: orderBy?.call(Course.t),
      orderByList: orderByList?.call(Course.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Course] matching the given query parameters.
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
  Future<Course?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CourseTable>? where,
    int? offset,
    _i1.OrderByBuilder<CourseTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CourseTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Course>(
      where: where?.call(Course.t),
      orderBy: orderBy?.call(Course.t),
      orderByList: orderByList?.call(Course.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Course] by its [id] or null if no such row exists.
  Future<Course?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Course>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Course]s in the list and returns the inserted rows.
  ///
  /// The returned [Course]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Course>> insert(
    _i1.Session session,
    List<Course> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Course>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Course] and returns the inserted row.
  ///
  /// The returned [Course] will have its `id` field set.
  Future<Course> insertRow(
    _i1.Session session,
    Course row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Course>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Course]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Course>> update(
    _i1.Session session,
    List<Course> rows, {
    _i1.ColumnSelections<CourseTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Course>(
      rows,
      columns: columns?.call(Course.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Course]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Course> updateRow(
    _i1.Session session,
    Course row, {
    _i1.ColumnSelections<CourseTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Course>(
      row,
      columns: columns?.call(Course.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Course]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Course>> delete(
    _i1.Session session,
    List<Course> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Course>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Course].
  Future<Course> deleteRow(
    _i1.Session session,
    Course row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Course>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Course>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CourseTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Course>(
      where: where(Course.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CourseTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Course>(
      where: where?.call(Course.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
