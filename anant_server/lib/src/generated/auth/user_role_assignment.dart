/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../user/user.dart' as _i2;
import '../auth/role.dart' as _i3;
import 'package:anant_server/src/generated/protocol.dart' as _i4;

/// User-Role assignment table for multi-role support
abstract class UserRoleAssignment
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UserRoleAssignment._({
    this.id,
    required this.userId,
    this.user,
    required this.roleId,
    this.role,
    DateTime? assignedAt,
    this.assignedById,
    bool? isActive,
    this.validFrom,
    this.validUntil,
  }) : assignedAt = assignedAt ?? DateTime.now(),
       isActive = isActive ?? true;

  factory UserRoleAssignment({
    int? id,
    required int userId,
    _i2.User? user,
    required int roleId,
    _i3.Role? role,
    DateTime? assignedAt,
    int? assignedById,
    bool? isActive,
    DateTime? validFrom,
    DateTime? validUntil,
  }) = _UserRoleAssignmentImpl;

  factory UserRoleAssignment.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserRoleAssignment(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      user: jsonSerialization['user'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.User>(jsonSerialization['user']),
      roleId: jsonSerialization['roleId'] as int,
      role: jsonSerialization['role'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.Role>(jsonSerialization['role']),
      assignedAt: jsonSerialization['assignedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['assignedAt']),
      assignedById: jsonSerialization['assignedById'] as int?,
      isActive: jsonSerialization['isActive'] as bool?,
      validFrom: jsonSerialization['validFrom'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['validFrom']),
      validUntil: jsonSerialization['validUntil'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['validUntil']),
    );
  }

  static final t = UserRoleAssignmentTable();

  static const db = UserRoleAssignmentRepository._();

  @override
  int? id;

  int userId;

  _i2.User? user;

  int roleId;

  _i3.Role? role;

  DateTime assignedAt;

  int? assignedById;

  bool isActive;

  DateTime? validFrom;

  DateTime? validUntil;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserRoleAssignment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserRoleAssignment copyWith({
    int? id,
    int? userId,
    _i2.User? user,
    int? roleId,
    _i3.Role? role,
    DateTime? assignedAt,
    int? assignedById,
    bool? isActive,
    DateTime? validFrom,
    DateTime? validUntil,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserRoleAssignment',
      if (id != null) 'id': id,
      'userId': userId,
      if (user != null) 'user': user?.toJson(),
      'roleId': roleId,
      if (role != null) 'role': role?.toJson(),
      'assignedAt': assignedAt.toJson(),
      if (assignedById != null) 'assignedById': assignedById,
      'isActive': isActive,
      if (validFrom != null) 'validFrom': validFrom?.toJson(),
      if (validUntil != null) 'validUntil': validUntil?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserRoleAssignment',
      if (id != null) 'id': id,
      'userId': userId,
      if (user != null) 'user': user?.toJsonForProtocol(),
      'roleId': roleId,
      if (role != null) 'role': role?.toJsonForProtocol(),
      'assignedAt': assignedAt.toJson(),
      if (assignedById != null) 'assignedById': assignedById,
      'isActive': isActive,
      if (validFrom != null) 'validFrom': validFrom?.toJson(),
      if (validUntil != null) 'validUntil': validUntil?.toJson(),
    };
  }

  static UserRoleAssignmentInclude include({
    _i2.UserInclude? user,
    _i3.RoleInclude? role,
  }) {
    return UserRoleAssignmentInclude._(
      user: user,
      role: role,
    );
  }

  static UserRoleAssignmentIncludeList includeList({
    _i1.WhereExpressionBuilder<UserRoleAssignmentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserRoleAssignmentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserRoleAssignmentTable>? orderByList,
    UserRoleAssignmentInclude? include,
  }) {
    return UserRoleAssignmentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserRoleAssignment.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserRoleAssignment.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserRoleAssignmentImpl extends UserRoleAssignment {
  _UserRoleAssignmentImpl({
    int? id,
    required int userId,
    _i2.User? user,
    required int roleId,
    _i3.Role? role,
    DateTime? assignedAt,
    int? assignedById,
    bool? isActive,
    DateTime? validFrom,
    DateTime? validUntil,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         roleId: roleId,
         role: role,
         assignedAt: assignedAt,
         assignedById: assignedById,
         isActive: isActive,
         validFrom: validFrom,
         validUntil: validUntil,
       );

  /// Returns a shallow copy of this [UserRoleAssignment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserRoleAssignment copyWith({
    Object? id = _Undefined,
    int? userId,
    Object? user = _Undefined,
    int? roleId,
    Object? role = _Undefined,
    DateTime? assignedAt,
    Object? assignedById = _Undefined,
    bool? isActive,
    Object? validFrom = _Undefined,
    Object? validUntil = _Undefined,
  }) {
    return UserRoleAssignment(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i2.User? ? user : this.user?.copyWith(),
      roleId: roleId ?? this.roleId,
      role: role is _i3.Role? ? role : this.role?.copyWith(),
      assignedAt: assignedAt ?? this.assignedAt,
      assignedById: assignedById is int? ? assignedById : this.assignedById,
      isActive: isActive ?? this.isActive,
      validFrom: validFrom is DateTime? ? validFrom : this.validFrom,
      validUntil: validUntil is DateTime? ? validUntil : this.validUntil,
    );
  }
}

class UserRoleAssignmentUpdateTable
    extends _i1.UpdateTable<UserRoleAssignmentTable> {
  UserRoleAssignmentUpdateTable(super.table);

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<int, int> roleId(int value) => _i1.ColumnValue(
    table.roleId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> assignedAt(DateTime value) =>
      _i1.ColumnValue(
        table.assignedAt,
        value,
      );

  _i1.ColumnValue<int, int> assignedById(int? value) => _i1.ColumnValue(
    table.assignedById,
    value,
  );

  _i1.ColumnValue<bool, bool> isActive(bool value) => _i1.ColumnValue(
    table.isActive,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> validFrom(DateTime? value) =>
      _i1.ColumnValue(
        table.validFrom,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> validUntil(DateTime? value) =>
      _i1.ColumnValue(
        table.validUntil,
        value,
      );
}

class UserRoleAssignmentTable extends _i1.Table<int?> {
  UserRoleAssignmentTable({super.tableRelation})
    : super(tableName: 'user_role_assignment') {
    updateTable = UserRoleAssignmentUpdateTable(this);
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    roleId = _i1.ColumnInt(
      'roleId',
      this,
    );
    assignedAt = _i1.ColumnDateTime(
      'assignedAt',
      this,
      hasDefault: true,
    );
    assignedById = _i1.ColumnInt(
      'assignedById',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
      hasDefault: true,
    );
    validFrom = _i1.ColumnDateTime(
      'validFrom',
      this,
    );
    validUntil = _i1.ColumnDateTime(
      'validUntil',
      this,
    );
  }

  late final UserRoleAssignmentUpdateTable updateTable;

  late final _i1.ColumnInt userId;

  _i2.UserTable? _user;

  late final _i1.ColumnInt roleId;

  _i3.RoleTable? _role;

  late final _i1.ColumnDateTime assignedAt;

  late final _i1.ColumnInt assignedById;

  late final _i1.ColumnBool isActive;

  late final _i1.ColumnDateTime validFrom;

  late final _i1.ColumnDateTime validUntil;

  _i2.UserTable get user {
    if (_user != null) return _user!;
    _user = _i1.createRelationTable(
      relationFieldName: 'user',
      field: UserRoleAssignment.t.userId,
      foreignField: _i2.User.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UserTable(tableRelation: foreignTableRelation),
    );
    return _user!;
  }

  _i3.RoleTable get role {
    if (_role != null) return _role!;
    _role = _i1.createRelationTable(
      relationFieldName: 'role',
      field: UserRoleAssignment.t.roleId,
      foreignField: _i3.Role.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.RoleTable(tableRelation: foreignTableRelation),
    );
    return _role!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    roleId,
    assignedAt,
    assignedById,
    isActive,
    validFrom,
    validUntil,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'user') {
      return user;
    }
    if (relationField == 'role') {
      return role;
    }
    return null;
  }
}

class UserRoleAssignmentInclude extends _i1.IncludeObject {
  UserRoleAssignmentInclude._({
    _i2.UserInclude? user,
    _i3.RoleInclude? role,
  }) {
    _user = user;
    _role = role;
  }

  _i2.UserInclude? _user;

  _i3.RoleInclude? _role;

  @override
  Map<String, _i1.Include?> get includes => {
    'user': _user,
    'role': _role,
  };

  @override
  _i1.Table<int?> get table => UserRoleAssignment.t;
}

class UserRoleAssignmentIncludeList extends _i1.IncludeList {
  UserRoleAssignmentIncludeList._({
    _i1.WhereExpressionBuilder<UserRoleAssignmentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserRoleAssignment.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UserRoleAssignment.t;
}

class UserRoleAssignmentRepository {
  const UserRoleAssignmentRepository._();

  final attachRow = const UserRoleAssignmentAttachRowRepository._();

  /// Returns a list of [UserRoleAssignment]s matching the given query parameters.
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
  Future<List<UserRoleAssignment>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserRoleAssignmentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserRoleAssignmentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserRoleAssignmentTable>? orderByList,
    _i1.Transaction? transaction,
    UserRoleAssignmentInclude? include,
  }) async {
    return session.db.find<UserRoleAssignment>(
      where: where?.call(UserRoleAssignment.t),
      orderBy: orderBy?.call(UserRoleAssignment.t),
      orderByList: orderByList?.call(UserRoleAssignment.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [UserRoleAssignment] matching the given query parameters.
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
  Future<UserRoleAssignment?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserRoleAssignmentTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserRoleAssignmentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserRoleAssignmentTable>? orderByList,
    _i1.Transaction? transaction,
    UserRoleAssignmentInclude? include,
  }) async {
    return session.db.findFirstRow<UserRoleAssignment>(
      where: where?.call(UserRoleAssignment.t),
      orderBy: orderBy?.call(UserRoleAssignment.t),
      orderByList: orderByList?.call(UserRoleAssignment.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [UserRoleAssignment] by its [id] or null if no such row exists.
  Future<UserRoleAssignment?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    UserRoleAssignmentInclude? include,
  }) async {
    return session.db.findById<UserRoleAssignment>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [UserRoleAssignment]s in the list and returns the inserted rows.
  ///
  /// The returned [UserRoleAssignment]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UserRoleAssignment>> insert(
    _i1.Session session,
    List<UserRoleAssignment> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserRoleAssignment>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UserRoleAssignment] and returns the inserted row.
  ///
  /// The returned [UserRoleAssignment] will have its `id` field set.
  Future<UserRoleAssignment> insertRow(
    _i1.Session session,
    UserRoleAssignment row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserRoleAssignment>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserRoleAssignment]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserRoleAssignment>> update(
    _i1.Session session,
    List<UserRoleAssignment> rows, {
    _i1.ColumnSelections<UserRoleAssignmentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserRoleAssignment>(
      rows,
      columns: columns?.call(UserRoleAssignment.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserRoleAssignment]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserRoleAssignment> updateRow(
    _i1.Session session,
    UserRoleAssignment row, {
    _i1.ColumnSelections<UserRoleAssignmentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserRoleAssignment>(
      row,
      columns: columns?.call(UserRoleAssignment.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserRoleAssignment] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserRoleAssignment?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<UserRoleAssignmentUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UserRoleAssignment>(
      id,
      columnValues: columnValues(UserRoleAssignment.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserRoleAssignment]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UserRoleAssignment>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<UserRoleAssignmentUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<UserRoleAssignmentTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserRoleAssignmentTable>? orderBy,
    _i1.OrderByListBuilder<UserRoleAssignmentTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UserRoleAssignment>(
      columnValues: columnValues(UserRoleAssignment.t.updateTable),
      where: where(UserRoleAssignment.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserRoleAssignment.t),
      orderByList: orderByList?.call(UserRoleAssignment.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UserRoleAssignment]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserRoleAssignment>> delete(
    _i1.Session session,
    List<UserRoleAssignment> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserRoleAssignment>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserRoleAssignment].
  Future<UserRoleAssignment> deleteRow(
    _i1.Session session,
    UserRoleAssignment row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserRoleAssignment>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserRoleAssignment>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserRoleAssignmentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserRoleAssignment>(
      where: where(UserRoleAssignment.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserRoleAssignmentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserRoleAssignment>(
      where: where?.call(UserRoleAssignment.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class UserRoleAssignmentAttachRowRepository {
  const UserRoleAssignmentAttachRowRepository._();

  /// Creates a relation between the given [UserRoleAssignment] and [User]
  /// by setting the [UserRoleAssignment]'s foreign key `userId` to refer to the [User].
  Future<void> user(
    _i1.Session session,
    UserRoleAssignment userRoleAssignment,
    _i2.User user, {
    _i1.Transaction? transaction,
  }) async {
    if (userRoleAssignment.id == null) {
      throw ArgumentError.notNull('userRoleAssignment.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $userRoleAssignment = userRoleAssignment.copyWith(userId: user.id);
    await session.db.updateRow<UserRoleAssignment>(
      $userRoleAssignment,
      columns: [UserRoleAssignment.t.userId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [UserRoleAssignment] and [Role]
  /// by setting the [UserRoleAssignment]'s foreign key `roleId` to refer to the [Role].
  Future<void> role(
    _i1.Session session,
    UserRoleAssignment userRoleAssignment,
    _i3.Role role, {
    _i1.Transaction? transaction,
  }) async {
    if (userRoleAssignment.id == null) {
      throw ArgumentError.notNull('userRoleAssignment.id');
    }
    if (role.id == null) {
      throw ArgumentError.notNull('role.id');
    }

    var $userRoleAssignment = userRoleAssignment.copyWith(roleId: role.id);
    await session.db.updateRow<UserRoleAssignment>(
      $userRoleAssignment,
      columns: [UserRoleAssignment.t.roleId],
      transaction: transaction,
    );
  }
}
