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

/// Resource-based access control for fine-grained permissions
abstract class ResourcePermission
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ResourcePermission._({
    this.id,
    required this.roleId,
    this.role,
    required this.permissionId,
    this.permission,
    required this.resourceType,
    required this.resourceId,
    this.organizationName,
    this.conditions,
    DateTime? createdAt,
    this.createdById,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ResourcePermission({
    int? id,
    required int roleId,
    _i2.Role? role,
    required int permissionId,
    _i3.Permission? permission,
    required String resourceType,
    required String resourceId,
    String? organizationName,
    String? conditions,
    DateTime? createdAt,
    int? createdById,
  }) = _ResourcePermissionImpl;

  factory ResourcePermission.fromJson(Map<String, dynamic> jsonSerialization) {
    return ResourcePermission(
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
      resourceType: jsonSerialization['resourceType'] as String,
      resourceId: jsonSerialization['resourceId'] as String,
      organizationName: jsonSerialization['organizationName'] as String?,
      conditions: jsonSerialization['conditions'] as String?,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      createdById: jsonSerialization['createdById'] as int?,
    );
  }

  static final t = ResourcePermissionTable();

  static const db = ResourcePermissionRepository._();

  @override
  int? id;

  int roleId;

  _i2.Role? role;

  int permissionId;

  _i3.Permission? permission;

  String resourceType;

  String resourceId;

  String? organizationName;

  String? conditions;

  DateTime createdAt;

  int? createdById;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ResourcePermission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ResourcePermission copyWith({
    int? id,
    int? roleId,
    _i2.Role? role,
    int? permissionId,
    _i3.Permission? permission,
    String? resourceType,
    String? resourceId,
    String? organizationName,
    String? conditions,
    DateTime? createdAt,
    int? createdById,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'roleId': roleId,
      if (role != null) 'role': role?.toJson(),
      'permissionId': permissionId,
      if (permission != null) 'permission': permission?.toJson(),
      'resourceType': resourceType,
      'resourceId': resourceId,
      if (organizationName != null) 'organizationName': organizationName,
      if (conditions != null) 'conditions': conditions,
      'createdAt': createdAt.toJson(),
      if (createdById != null) 'createdById': createdById,
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
      'resourceType': resourceType,
      'resourceId': resourceId,
      if (organizationName != null) 'organizationName': organizationName,
      if (conditions != null) 'conditions': conditions,
      'createdAt': createdAt.toJson(),
      if (createdById != null) 'createdById': createdById,
    };
  }

  static ResourcePermissionInclude include({
    _i2.RoleInclude? role,
    _i3.PermissionInclude? permission,
  }) {
    return ResourcePermissionInclude._(
      role: role,
      permission: permission,
    );
  }

  static ResourcePermissionIncludeList includeList({
    _i1.WhereExpressionBuilder<ResourcePermissionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ResourcePermissionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ResourcePermissionTable>? orderByList,
    ResourcePermissionInclude? include,
  }) {
    return ResourcePermissionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ResourcePermission.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ResourcePermission.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ResourcePermissionImpl extends ResourcePermission {
  _ResourcePermissionImpl({
    int? id,
    required int roleId,
    _i2.Role? role,
    required int permissionId,
    _i3.Permission? permission,
    required String resourceType,
    required String resourceId,
    String? organizationName,
    String? conditions,
    DateTime? createdAt,
    int? createdById,
  }) : super._(
          id: id,
          roleId: roleId,
          role: role,
          permissionId: permissionId,
          permission: permission,
          resourceType: resourceType,
          resourceId: resourceId,
          organizationName: organizationName,
          conditions: conditions,
          createdAt: createdAt,
          createdById: createdById,
        );

  /// Returns a shallow copy of this [ResourcePermission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ResourcePermission copyWith({
    Object? id = _Undefined,
    int? roleId,
    Object? role = _Undefined,
    int? permissionId,
    Object? permission = _Undefined,
    String? resourceType,
    String? resourceId,
    Object? organizationName = _Undefined,
    Object? conditions = _Undefined,
    DateTime? createdAt,
    Object? createdById = _Undefined,
  }) {
    return ResourcePermission(
      id: id is int? ? id : this.id,
      roleId: roleId ?? this.roleId,
      role: role is _i2.Role? ? role : this.role?.copyWith(),
      permissionId: permissionId ?? this.permissionId,
      permission: permission is _i3.Permission?
          ? permission
          : this.permission?.copyWith(),
      resourceType: resourceType ?? this.resourceType,
      resourceId: resourceId ?? this.resourceId,
      organizationName: organizationName is String?
          ? organizationName
          : this.organizationName,
      conditions: conditions is String? ? conditions : this.conditions,
      createdAt: createdAt ?? this.createdAt,
      createdById: createdById is int? ? createdById : this.createdById,
    );
  }
}

class ResourcePermissionTable extends _i1.Table<int?> {
  ResourcePermissionTable({super.tableRelation})
      : super(tableName: 'resource_permission') {
    roleId = _i1.ColumnInt(
      'roleId',
      this,
    );
    permissionId = _i1.ColumnInt(
      'permissionId',
      this,
    );
    resourceType = _i1.ColumnString(
      'resourceType',
      this,
    );
    resourceId = _i1.ColumnString(
      'resourceId',
      this,
    );
    organizationName = _i1.ColumnString(
      'organizationName',
      this,
    );
    conditions = _i1.ColumnString(
      'conditions',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    createdById = _i1.ColumnInt(
      'createdById',
      this,
    );
  }

  late final _i1.ColumnInt roleId;

  _i2.RoleTable? _role;

  late final _i1.ColumnInt permissionId;

  _i3.PermissionTable? _permission;

  late final _i1.ColumnString resourceType;

  late final _i1.ColumnString resourceId;

  late final _i1.ColumnString organizationName;

  late final _i1.ColumnString conditions;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnInt createdById;

  _i2.RoleTable get role {
    if (_role != null) return _role!;
    _role = _i1.createRelationTable(
      relationFieldName: 'role',
      field: ResourcePermission.t.roleId,
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
      field: ResourcePermission.t.permissionId,
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
        resourceType,
        resourceId,
        organizationName,
        conditions,
        createdAt,
        createdById,
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

class ResourcePermissionInclude extends _i1.IncludeObject {
  ResourcePermissionInclude._({
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
  _i1.Table<int?> get table => ResourcePermission.t;
}

class ResourcePermissionIncludeList extends _i1.IncludeList {
  ResourcePermissionIncludeList._({
    _i1.WhereExpressionBuilder<ResourcePermissionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ResourcePermission.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ResourcePermission.t;
}

class ResourcePermissionRepository {
  const ResourcePermissionRepository._();

  final attachRow = const ResourcePermissionAttachRowRepository._();

  /// Returns a list of [ResourcePermission]s matching the given query parameters.
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
  Future<List<ResourcePermission>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ResourcePermissionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ResourcePermissionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ResourcePermissionTable>? orderByList,
    _i1.Transaction? transaction,
    ResourcePermissionInclude? include,
  }) async {
    return session.db.find<ResourcePermission>(
      where: where?.call(ResourcePermission.t),
      orderBy: orderBy?.call(ResourcePermission.t),
      orderByList: orderByList?.call(ResourcePermission.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [ResourcePermission] matching the given query parameters.
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
  Future<ResourcePermission?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ResourcePermissionTable>? where,
    int? offset,
    _i1.OrderByBuilder<ResourcePermissionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ResourcePermissionTable>? orderByList,
    _i1.Transaction? transaction,
    ResourcePermissionInclude? include,
  }) async {
    return session.db.findFirstRow<ResourcePermission>(
      where: where?.call(ResourcePermission.t),
      orderBy: orderBy?.call(ResourcePermission.t),
      orderByList: orderByList?.call(ResourcePermission.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [ResourcePermission] by its [id] or null if no such row exists.
  Future<ResourcePermission?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ResourcePermissionInclude? include,
  }) async {
    return session.db.findById<ResourcePermission>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [ResourcePermission]s in the list and returns the inserted rows.
  ///
  /// The returned [ResourcePermission]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ResourcePermission>> insert(
    _i1.Session session,
    List<ResourcePermission> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ResourcePermission>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ResourcePermission] and returns the inserted row.
  ///
  /// The returned [ResourcePermission] will have its `id` field set.
  Future<ResourcePermission> insertRow(
    _i1.Session session,
    ResourcePermission row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ResourcePermission>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ResourcePermission]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ResourcePermission>> update(
    _i1.Session session,
    List<ResourcePermission> rows, {
    _i1.ColumnSelections<ResourcePermissionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ResourcePermission>(
      rows,
      columns: columns?.call(ResourcePermission.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ResourcePermission]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ResourcePermission> updateRow(
    _i1.Session session,
    ResourcePermission row, {
    _i1.ColumnSelections<ResourcePermissionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ResourcePermission>(
      row,
      columns: columns?.call(ResourcePermission.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ResourcePermission]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ResourcePermission>> delete(
    _i1.Session session,
    List<ResourcePermission> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ResourcePermission>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ResourcePermission].
  Future<ResourcePermission> deleteRow(
    _i1.Session session,
    ResourcePermission row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ResourcePermission>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ResourcePermission>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ResourcePermissionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ResourcePermission>(
      where: where(ResourcePermission.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ResourcePermissionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ResourcePermission>(
      where: where?.call(ResourcePermission.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ResourcePermissionAttachRowRepository {
  const ResourcePermissionAttachRowRepository._();

  /// Creates a relation between the given [ResourcePermission] and [Role]
  /// by setting the [ResourcePermission]'s foreign key `roleId` to refer to the [Role].
  Future<void> role(
    _i1.Session session,
    ResourcePermission resourcePermission,
    _i2.Role role, {
    _i1.Transaction? transaction,
  }) async {
    if (resourcePermission.id == null) {
      throw ArgumentError.notNull('resourcePermission.id');
    }
    if (role.id == null) {
      throw ArgumentError.notNull('role.id');
    }

    var $resourcePermission = resourcePermission.copyWith(roleId: role.id);
    await session.db.updateRow<ResourcePermission>(
      $resourcePermission,
      columns: [ResourcePermission.t.roleId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [ResourcePermission] and [Permission]
  /// by setting the [ResourcePermission]'s foreign key `permissionId` to refer to the [Permission].
  Future<void> permission(
    _i1.Session session,
    ResourcePermission resourcePermission,
    _i3.Permission permission, {
    _i1.Transaction? transaction,
  }) async {
    if (resourcePermission.id == null) {
      throw ArgumentError.notNull('resourcePermission.id');
    }
    if (permission.id == null) {
      throw ArgumentError.notNull('permission.id');
    }

    var $resourcePermission =
        resourcePermission.copyWith(permissionId: permission.id);
    await session.db.updateRow<ResourcePermission>(
      $resourcePermission,
      columns: [ResourcePermission.t.permissionId],
      transaction: transaction,
    );
  }
}
