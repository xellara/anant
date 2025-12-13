/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../auth/role.dart' as _i2;
import '../auth/permission.dart' as _i3;

abstract class RolePermission
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  RolePermission._({
    this.id,
    required this.roleId,
    this.role,
    required this.permissionId,
    this.permission,
  });

  factory RolePermission({
    int? id,
    required int roleId,
    _i2.Role? role,
    required int permissionId,
    _i3.Permission? permission,
  }) = _RolePermissionImpl;

  factory RolePermission.fromJson(Map<String, dynamic> jsonSerialization) {
    return RolePermission(
      id: jsonSerialization['id'] as int?,
      roleId: jsonSerialization['roleId'] as int,
      role: jsonSerialization['role'] == null
          ? null
          : _i2.Role.fromJson(
              (jsonSerialization['role'] as Map<String, dynamic>)),
      permissionId: jsonSerialization['permissionId'] as int,
      permission: jsonSerialization['permission'] == null
          ? null
          : _i3.Permission.fromJson(
              (jsonSerialization['permission'] as Map<String, dynamic>)),
    );
  }

  static final t = RolePermissionTable();

  static const db = RolePermissionRepository._();

  @override
  int? id;

  int roleId;

  _i2.Role? role;

  int permissionId;

  _i3.Permission? permission;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [RolePermission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RolePermission copyWith({
    int? id,
    int? roleId,
    _i2.Role? role,
    int? permissionId,
    _i3.Permission? permission,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'roleId': roleId,
      if (role != null) 'role': role?.toJson(),
      'permissionId': permissionId,
      if (permission != null) 'permission': permission?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'roleId': roleId,
      if (role != null) 'role': role?.toJsonForProtocol(),
      'permissionId': permissionId,
      if (permission != null) 'permission': permission?.toJsonForProtocol(),
    };
  }

  static RolePermissionInclude include({
    _i2.RoleInclude? role,
    _i3.PermissionInclude? permission,
  }) {
    return RolePermissionInclude._(
      role: role,
      permission: permission,
    );
  }

  static RolePermissionIncludeList includeList({
    _i1.WhereExpressionBuilder<RolePermissionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RolePermissionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RolePermissionTable>? orderByList,
    RolePermissionInclude? include,
  }) {
    return RolePermissionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RolePermission.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RolePermission.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RolePermissionImpl extends RolePermission {
  _RolePermissionImpl({
    int? id,
    required int roleId,
    _i2.Role? role,
    required int permissionId,
    _i3.Permission? permission,
  }) : super._(
          id: id,
          roleId: roleId,
          role: role,
          permissionId: permissionId,
          permission: permission,
        );

  /// Returns a shallow copy of this [RolePermission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RolePermission copyWith({
    Object? id = _Undefined,
    int? roleId,
    Object? role = _Undefined,
    int? permissionId,
    Object? permission = _Undefined,
  }) {
    return RolePermission(
      id: id is int? ? id : this.id,
      roleId: roleId ?? this.roleId,
      role: role is _i2.Role? ? role : this.role?.copyWith(),
      permissionId: permissionId ?? this.permissionId,
      permission: permission is _i3.Permission?
          ? permission
          : this.permission?.copyWith(),
    );
  }
}

class RolePermissionTable extends _i1.Table<int?> {
  RolePermissionTable({super.tableRelation})
      : super(tableName: 'role_permission') {
    roleId = _i1.ColumnInt(
      'roleId',
      this,
    );
    permissionId = _i1.ColumnInt(
      'permissionId',
      this,
    );
  }

  late final _i1.ColumnInt roleId;

  _i2.RoleTable? _role;

  late final _i1.ColumnInt permissionId;

  _i3.PermissionTable? _permission;

  _i2.RoleTable get role {
    if (_role != null) return _role!;
    _role = _i1.createRelationTable(
      relationFieldName: 'role',
      field: RolePermission.t.roleId,
      foreignField: _i2.Role.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.RoleTable(tableRelation: foreignTableRelation),
    );
    return _role!;
  }

  _i3.PermissionTable get permission {
    if (_permission != null) return _permission!;
    _permission = _i1.createRelationTable(
      relationFieldName: 'permission',
      field: RolePermission.t.permissionId,
      foreignField: _i3.Permission.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.PermissionTable(tableRelation: foreignTableRelation),
    );
    return _permission!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        roleId,
        permissionId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'role') {
      return role;
    }
    if (relationField == 'permission') {
      return permission;
    }
    return null;
  }
}

class RolePermissionInclude extends _i1.IncludeObject {
  RolePermissionInclude._({
    _i2.RoleInclude? role,
    _i3.PermissionInclude? permission,
  }) {
    _role = role;
    _permission = permission;
  }

  _i2.RoleInclude? _role;

  _i3.PermissionInclude? _permission;

  @override
  Map<String, _i1.Include?> get includes => {
        'role': _role,
        'permission': _permission,
      };

  @override
  _i1.Table<int?> get table => RolePermission.t;
}

class RolePermissionIncludeList extends _i1.IncludeList {
  RolePermissionIncludeList._({
    _i1.WhereExpressionBuilder<RolePermissionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RolePermission.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => RolePermission.t;
}

class RolePermissionRepository {
  const RolePermissionRepository._();

  final attachRow = const RolePermissionAttachRowRepository._();

  /// Returns a list of [RolePermission]s matching the given query parameters.
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
  Future<List<RolePermission>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RolePermissionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RolePermissionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RolePermissionTable>? orderByList,
    _i1.Transaction? transaction,
    RolePermissionInclude? include,
  }) async {
    return session.db.find<RolePermission>(
      where: where?.call(RolePermission.t),
      orderBy: orderBy?.call(RolePermission.t),
      orderByList: orderByList?.call(RolePermission.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [RolePermission] matching the given query parameters.
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
  Future<RolePermission?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RolePermissionTable>? where,
    int? offset,
    _i1.OrderByBuilder<RolePermissionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RolePermissionTable>? orderByList,
    _i1.Transaction? transaction,
    RolePermissionInclude? include,
  }) async {
    return session.db.findFirstRow<RolePermission>(
      where: where?.call(RolePermission.t),
      orderBy: orderBy?.call(RolePermission.t),
      orderByList: orderByList?.call(RolePermission.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [RolePermission] by its [id] or null if no such row exists.
  Future<RolePermission?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    RolePermissionInclude? include,
  }) async {
    return session.db.findById<RolePermission>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [RolePermission]s in the list and returns the inserted rows.
  ///
  /// The returned [RolePermission]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<RolePermission>> insert(
    _i1.Session session,
    List<RolePermission> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<RolePermission>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [RolePermission] and returns the inserted row.
  ///
  /// The returned [RolePermission] will have its `id` field set.
  Future<RolePermission> insertRow(
    _i1.Session session,
    RolePermission row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RolePermission>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RolePermission]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RolePermission>> update(
    _i1.Session session,
    List<RolePermission> rows, {
    _i1.ColumnSelections<RolePermissionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RolePermission>(
      rows,
      columns: columns?.call(RolePermission.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RolePermission]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RolePermission> updateRow(
    _i1.Session session,
    RolePermission row, {
    _i1.ColumnSelections<RolePermissionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RolePermission>(
      row,
      columns: columns?.call(RolePermission.t),
      transaction: transaction,
    );
  }

  /// Deletes all [RolePermission]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RolePermission>> delete(
    _i1.Session session,
    List<RolePermission> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RolePermission>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RolePermission].
  Future<RolePermission> deleteRow(
    _i1.Session session,
    RolePermission row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RolePermission>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RolePermission>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<RolePermissionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RolePermission>(
      where: where(RolePermission.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RolePermissionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RolePermission>(
      where: where?.call(RolePermission.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class RolePermissionAttachRowRepository {
  const RolePermissionAttachRowRepository._();

  /// Creates a relation between the given [RolePermission] and [Role]
  /// by setting the [RolePermission]'s foreign key `roleId` to refer to the [Role].
  Future<void> role(
    _i1.Session session,
    RolePermission rolePermission,
    _i2.Role role, {
    _i1.Transaction? transaction,
  }) async {
    if (rolePermission.id == null) {
      throw ArgumentError.notNull('rolePermission.id');
    }
    if (role.id == null) {
      throw ArgumentError.notNull('role.id');
    }

    var $rolePermission = rolePermission.copyWith(roleId: role.id);
    await session.db.updateRow<RolePermission>(
      $rolePermission,
      columns: [RolePermission.t.roleId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [RolePermission] and [Permission]
  /// by setting the [RolePermission]'s foreign key `permissionId` to refer to the [Permission].
  Future<void> permission(
    _i1.Session session,
    RolePermission rolePermission,
    _i3.Permission permission, {
    _i1.Transaction? transaction,
  }) async {
    if (rolePermission.id == null) {
      throw ArgumentError.notNull('rolePermission.id');
    }
    if (permission.id == null) {
      throw ArgumentError.notNull('permission.id');
    }

    var $rolePermission = rolePermission.copyWith(permissionId: permission.id);
    await session.db.updateRow<RolePermission>(
      $rolePermission,
      columns: [RolePermission.t.permissionId],
      transaction: transaction,
    );
  }
}
