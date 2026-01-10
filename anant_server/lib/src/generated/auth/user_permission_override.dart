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
import '../user/user.dart' as _i2;
import '../auth/permission.dart' as _i3;

abstract class UserPermissionOverride
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UserPermissionOverride._({
    this.id,
    required this.userId,
    this.user,
    required this.permissionId,
    this.permission,
    required this.isGranted,
  });

  factory UserPermissionOverride({
    int? id,
    required int userId,
    _i2.User? user,
    required int permissionId,
    _i3.Permission? permission,
    required bool isGranted,
  }) = _UserPermissionOverrideImpl;

  factory UserPermissionOverride.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return UserPermissionOverride(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      user: jsonSerialization['user'] == null
          ? null
          : _i2.User.fromJson(
              (jsonSerialization['user'] as Map<String, dynamic>)),
      permissionId: jsonSerialization['permissionId'] as int,
      permission: jsonSerialization['permission'] == null
          ? null
          : _i3.Permission.fromJson(
              (jsonSerialization['permission'] as Map<String, dynamic>)),
      isGranted: jsonSerialization['isGranted'] as bool,
    );
  }

  static final t = UserPermissionOverrideTable();

  static const db = UserPermissionOverrideRepository._();

  @override
  int? id;

  int userId;

  _i2.User? user;

  int permissionId;

  _i3.Permission? permission;

  bool isGranted;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserPermissionOverride]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserPermissionOverride copyWith({
    int? id,
    int? userId,
    _i2.User? user,
    int? permissionId,
    _i3.Permission? permission,
    bool? isGranted,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      if (user != null) 'user': user?.toJson(),
      'permissionId': permissionId,
      if (permission != null) 'permission': permission?.toJson(),
      'isGranted': isGranted,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      if (user != null) 'user': user?.toJsonForProtocol(),
      'permissionId': permissionId,
      if (permission != null) 'permission': permission?.toJsonForProtocol(),
      'isGranted': isGranted,
    };
  }

  static UserPermissionOverrideInclude include({
    _i2.UserInclude? user,
    _i3.PermissionInclude? permission,
  }) {
    return UserPermissionOverrideInclude._(
      user: user,
      permission: permission,
    );
  }

  static UserPermissionOverrideIncludeList includeList({
    _i1.WhereExpressionBuilder<UserPermissionOverrideTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserPermissionOverrideTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserPermissionOverrideTable>? orderByList,
    UserPermissionOverrideInclude? include,
  }) {
    return UserPermissionOverrideIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserPermissionOverride.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserPermissionOverride.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserPermissionOverrideImpl extends UserPermissionOverride {
  _UserPermissionOverrideImpl({
    int? id,
    required int userId,
    _i2.User? user,
    required int permissionId,
    _i3.Permission? permission,
    required bool isGranted,
  }) : super._(
          id: id,
          userId: userId,
          user: user,
          permissionId: permissionId,
          permission: permission,
          isGranted: isGranted,
        );

  /// Returns a shallow copy of this [UserPermissionOverride]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserPermissionOverride copyWith({
    Object? id = _Undefined,
    int? userId,
    Object? user = _Undefined,
    int? permissionId,
    Object? permission = _Undefined,
    bool? isGranted,
  }) {
    return UserPermissionOverride(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i2.User? ? user : this.user?.copyWith(),
      permissionId: permissionId ?? this.permissionId,
      permission: permission is _i3.Permission?
          ? permission
          : this.permission?.copyWith(),
      isGranted: isGranted ?? this.isGranted,
    );
  }
}

class UserPermissionOverrideTable extends _i1.Table<int?> {
  UserPermissionOverrideTable({super.tableRelation})
      : super(tableName: 'user_permission_override') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    permissionId = _i1.ColumnInt(
      'permissionId',
      this,
    );
    isGranted = _i1.ColumnBool(
      'isGranted',
      this,
    );
  }

  late final _i1.ColumnInt userId;

  _i2.UserTable? _user;

  late final _i1.ColumnInt permissionId;

  _i3.PermissionTable? _permission;

  late final _i1.ColumnBool isGranted;

  _i2.UserTable get user {
    if (_user != null) return _user!;
    _user = _i1.createRelationTable(
      relationFieldName: 'user',
      field: UserPermissionOverride.t.userId,
      foreignField: _i2.User.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UserTable(tableRelation: foreignTableRelation),
    );
    return _user!;
  }

  _i3.PermissionTable get permission {
    if (_permission != null) return _permission!;
    _permission = _i1.createRelationTable(
      relationFieldName: 'permission',
      field: UserPermissionOverride.t.permissionId,
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
        userId,
        permissionId,
        isGranted,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'user') {
      return user;
    }
    if (relationField == 'permission') {
      return permission;
    }
    return null;
  }
}

class UserPermissionOverrideInclude extends _i1.IncludeObject {
  UserPermissionOverrideInclude._({
    _i2.UserInclude? user,
    _i3.PermissionInclude? permission,
  }) {
    _user = user;
    _permission = permission;
  }

  _i2.UserInclude? _user;

  _i3.PermissionInclude? _permission;

  @override
  Map<String, _i1.Include?> get includes => {
        'user': _user,
        'permission': _permission,
      };

  @override
  _i1.Table<int?> get table => UserPermissionOverride.t;
}

class UserPermissionOverrideIncludeList extends _i1.IncludeList {
  UserPermissionOverrideIncludeList._({
    _i1.WhereExpressionBuilder<UserPermissionOverrideTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserPermissionOverride.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UserPermissionOverride.t;
}

class UserPermissionOverrideRepository {
  const UserPermissionOverrideRepository._();

  final attachRow = const UserPermissionOverrideAttachRowRepository._();

  /// Returns a list of [UserPermissionOverride]s matching the given query parameters.
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
  Future<List<UserPermissionOverride>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserPermissionOverrideTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserPermissionOverrideTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserPermissionOverrideTable>? orderByList,
    _i1.Transaction? transaction,
    UserPermissionOverrideInclude? include,
  }) async {
    return session.db.find<UserPermissionOverride>(
      where: where?.call(UserPermissionOverride.t),
      orderBy: orderBy?.call(UserPermissionOverride.t),
      orderByList: orderByList?.call(UserPermissionOverride.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [UserPermissionOverride] matching the given query parameters.
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
  Future<UserPermissionOverride?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserPermissionOverrideTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserPermissionOverrideTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserPermissionOverrideTable>? orderByList,
    _i1.Transaction? transaction,
    UserPermissionOverrideInclude? include,
  }) async {
    return session.db.findFirstRow<UserPermissionOverride>(
      where: where?.call(UserPermissionOverride.t),
      orderBy: orderBy?.call(UserPermissionOverride.t),
      orderByList: orderByList?.call(UserPermissionOverride.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [UserPermissionOverride] by its [id] or null if no such row exists.
  Future<UserPermissionOverride?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    UserPermissionOverrideInclude? include,
  }) async {
    return session.db.findById<UserPermissionOverride>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [UserPermissionOverride]s in the list and returns the inserted rows.
  ///
  /// The returned [UserPermissionOverride]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UserPermissionOverride>> insert(
    _i1.Session session,
    List<UserPermissionOverride> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserPermissionOverride>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UserPermissionOverride] and returns the inserted row.
  ///
  /// The returned [UserPermissionOverride] will have its `id` field set.
  Future<UserPermissionOverride> insertRow(
    _i1.Session session,
    UserPermissionOverride row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserPermissionOverride>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserPermissionOverride]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserPermissionOverride>> update(
    _i1.Session session,
    List<UserPermissionOverride> rows, {
    _i1.ColumnSelections<UserPermissionOverrideTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserPermissionOverride>(
      rows,
      columns: columns?.call(UserPermissionOverride.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserPermissionOverride]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserPermissionOverride> updateRow(
    _i1.Session session,
    UserPermissionOverride row, {
    _i1.ColumnSelections<UserPermissionOverrideTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserPermissionOverride>(
      row,
      columns: columns?.call(UserPermissionOverride.t),
      transaction: transaction,
    );
  }

  /// Deletes all [UserPermissionOverride]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserPermissionOverride>> delete(
    _i1.Session session,
    List<UserPermissionOverride> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserPermissionOverride>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserPermissionOverride].
  Future<UserPermissionOverride> deleteRow(
    _i1.Session session,
    UserPermissionOverride row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserPermissionOverride>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserPermissionOverride>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserPermissionOverrideTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserPermissionOverride>(
      where: where(UserPermissionOverride.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserPermissionOverrideTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserPermissionOverride>(
      where: where?.call(UserPermissionOverride.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class UserPermissionOverrideAttachRowRepository {
  const UserPermissionOverrideAttachRowRepository._();

  /// Creates a relation between the given [UserPermissionOverride] and [User]
  /// by setting the [UserPermissionOverride]'s foreign key `userId` to refer to the [User].
  Future<void> user(
    _i1.Session session,
    UserPermissionOverride userPermissionOverride,
    _i2.User user, {
    _i1.Transaction? transaction,
  }) async {
    if (userPermissionOverride.id == null) {
      throw ArgumentError.notNull('userPermissionOverride.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $userPermissionOverride =
        userPermissionOverride.copyWith(userId: user.id);
    await session.db.updateRow<UserPermissionOverride>(
      $userPermissionOverride,
      columns: [UserPermissionOverride.t.userId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [UserPermissionOverride] and [Permission]
  /// by setting the [UserPermissionOverride]'s foreign key `permissionId` to refer to the [Permission].
  Future<void> permission(
    _i1.Session session,
    UserPermissionOverride userPermissionOverride,
    _i3.Permission permission, {
    _i1.Transaction? transaction,
  }) async {
    if (userPermissionOverride.id == null) {
      throw ArgumentError.notNull('userPermissionOverride.id');
    }
    if (permission.id == null) {
      throw ArgumentError.notNull('permission.id');
    }

    var $userPermissionOverride =
        userPermissionOverride.copyWith(permissionId: permission.id);
    await session.db.updateRow<UserPermissionOverride>(
      $userPermissionOverride,
      columns: [UserPermissionOverride.t.permissionId],
      transaction: transaction,
    );
  }
}
