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

/// Audit log for permission checks and usage
abstract class PermissionAudit
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  PermissionAudit._({
    this.id,
    required this.userId,
    this.user,
    required this.permissionSlug,
    required this.action,
    this.resourceType,
    this.resourceId,
    this.organizationName,
    required this.success,
    this.failureReason,
    this.ipAddress,
    this.userAgent,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory PermissionAudit({
    int? id,
    required int userId,
    _i2.User? user,
    required String permissionSlug,
    required String action,
    String? resourceType,
    String? resourceId,
    String? organizationName,
    required bool success,
    String? failureReason,
    String? ipAddress,
    String? userAgent,
    DateTime? timestamp,
  }) = _PermissionAuditImpl;

  factory PermissionAudit.fromJson(Map<String, dynamic> jsonSerialization) {
    return PermissionAudit(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      user: jsonSerialization['user'] == null
          ? null
          : _i2.User.fromJson(
              (jsonSerialization['user'] as Map<String, dynamic>)),
      permissionSlug: jsonSerialization['permissionSlug'] as String,
      action: jsonSerialization['action'] as String,
      resourceType: jsonSerialization['resourceType'] as String?,
      resourceId: jsonSerialization['resourceId'] as String?,
      organizationName: jsonSerialization['organizationName'] as String?,
      success: jsonSerialization['success'] as bool,
      failureReason: jsonSerialization['failureReason'] as String?,
      ipAddress: jsonSerialization['ipAddress'] as String?,
      userAgent: jsonSerialization['userAgent'] as String?,
      timestamp:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['timestamp']),
    );
  }

  static final t = PermissionAuditTable();

  static const db = PermissionAuditRepository._();

  @override
  int? id;

  int userId;

  _i2.User? user;

  String permissionSlug;

  String action;

  String? resourceType;

  String? resourceId;

  String? organizationName;

  bool success;

  String? failureReason;

  String? ipAddress;

  String? userAgent;

  DateTime timestamp;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [PermissionAudit]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PermissionAudit copyWith({
    int? id,
    int? userId,
    _i2.User? user,
    String? permissionSlug,
    String? action,
    String? resourceType,
    String? resourceId,
    String? organizationName,
    bool? success,
    String? failureReason,
    String? ipAddress,
    String? userAgent,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      if (user != null) 'user': user?.toJson(),
      'permissionSlug': permissionSlug,
      'action': action,
      if (resourceType != null) 'resourceType': resourceType,
      if (resourceId != null) 'resourceId': resourceId,
      if (organizationName != null) 'organizationName': organizationName,
      'success': success,
      if (failureReason != null) 'failureReason': failureReason,
      if (ipAddress != null) 'ipAddress': ipAddress,
      if (userAgent != null) 'userAgent': userAgent,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      if (user != null) 'user': user?.toJsonForProtocol(),
      'permissionSlug': permissionSlug,
      'action': action,
      if (resourceType != null) 'resourceType': resourceType,
      if (resourceId != null) 'resourceId': resourceId,
      if (organizationName != null) 'organizationName': organizationName,
      'success': success,
      if (failureReason != null) 'failureReason': failureReason,
      if (ipAddress != null) 'ipAddress': ipAddress,
      if (userAgent != null) 'userAgent': userAgent,
      'timestamp': timestamp.toJson(),
    };
  }

  static PermissionAuditInclude include({_i2.UserInclude? user}) {
    return PermissionAuditInclude._(user: user);
  }

  static PermissionAuditIncludeList includeList({
    _i1.WhereExpressionBuilder<PermissionAuditTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PermissionAuditTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PermissionAuditTable>? orderByList,
    PermissionAuditInclude? include,
  }) {
    return PermissionAuditIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PermissionAudit.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PermissionAudit.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PermissionAuditImpl extends PermissionAudit {
  _PermissionAuditImpl({
    int? id,
    required int userId,
    _i2.User? user,
    required String permissionSlug,
    required String action,
    String? resourceType,
    String? resourceId,
    String? organizationName,
    required bool success,
    String? failureReason,
    String? ipAddress,
    String? userAgent,
    DateTime? timestamp,
  }) : super._(
          id: id,
          userId: userId,
          user: user,
          permissionSlug: permissionSlug,
          action: action,
          resourceType: resourceType,
          resourceId: resourceId,
          organizationName: organizationName,
          success: success,
          failureReason: failureReason,
          ipAddress: ipAddress,
          userAgent: userAgent,
          timestamp: timestamp,
        );

  /// Returns a shallow copy of this [PermissionAudit]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PermissionAudit copyWith({
    Object? id = _Undefined,
    int? userId,
    Object? user = _Undefined,
    String? permissionSlug,
    String? action,
    Object? resourceType = _Undefined,
    Object? resourceId = _Undefined,
    Object? organizationName = _Undefined,
    bool? success,
    Object? failureReason = _Undefined,
    Object? ipAddress = _Undefined,
    Object? userAgent = _Undefined,
    DateTime? timestamp,
  }) {
    return PermissionAudit(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i2.User? ? user : this.user?.copyWith(),
      permissionSlug: permissionSlug ?? this.permissionSlug,
      action: action ?? this.action,
      resourceType: resourceType is String? ? resourceType : this.resourceType,
      resourceId: resourceId is String? ? resourceId : this.resourceId,
      organizationName: organizationName is String?
          ? organizationName
          : this.organizationName,
      success: success ?? this.success,
      failureReason:
          failureReason is String? ? failureReason : this.failureReason,
      ipAddress: ipAddress is String? ? ipAddress : this.ipAddress,
      userAgent: userAgent is String? ? userAgent : this.userAgent,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class PermissionAuditTable extends _i1.Table<int?> {
  PermissionAuditTable({super.tableRelation})
      : super(tableName: 'permission_audit') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    permissionSlug = _i1.ColumnString(
      'permissionSlug',
      this,
    );
    action = _i1.ColumnString(
      'action',
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
    success = _i1.ColumnBool(
      'success',
      this,
    );
    failureReason = _i1.ColumnString(
      'failureReason',
      this,
    );
    ipAddress = _i1.ColumnString(
      'ipAddress',
      this,
    );
    userAgent = _i1.ColumnString(
      'userAgent',
      this,
    );
    timestamp = _i1.ColumnDateTime(
      'timestamp',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnInt userId;

  _i2.UserTable? _user;

  late final _i1.ColumnString permissionSlug;

  late final _i1.ColumnString action;

  late final _i1.ColumnString resourceType;

  late final _i1.ColumnString resourceId;

  late final _i1.ColumnString organizationName;

  late final _i1.ColumnBool success;

  late final _i1.ColumnString failureReason;

  late final _i1.ColumnString ipAddress;

  late final _i1.ColumnString userAgent;

  late final _i1.ColumnDateTime timestamp;

  _i2.UserTable get user {
    if (_user != null) return _user!;
    _user = _i1.createRelationTable(
      relationFieldName: 'user',
      field: PermissionAudit.t.userId,
      foreignField: _i2.User.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UserTable(tableRelation: foreignTableRelation),
    );
    return _user!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        permissionSlug,
        action,
        resourceType,
        resourceId,
        organizationName,
        success,
        failureReason,
        ipAddress,
        userAgent,
        timestamp,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'user') {
      return user;
    }
    return null;
  }
}

class PermissionAuditInclude extends _i1.IncludeObject {
  PermissionAuditInclude._({_i2.UserInclude? user}) {
    _user = user;
  }

  _i2.UserInclude? _user;

  @override
  Map<String, _i1.Include?> get includes => {'user': _user};

  @override
  _i1.Table<int?> get table => PermissionAudit.t;
}

class PermissionAuditIncludeList extends _i1.IncludeList {
  PermissionAuditIncludeList._({
    _i1.WhereExpressionBuilder<PermissionAuditTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PermissionAudit.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => PermissionAudit.t;
}

class PermissionAuditRepository {
  const PermissionAuditRepository._();

  final attachRow = const PermissionAuditAttachRowRepository._();

  /// Returns a list of [PermissionAudit]s matching the given query parameters.
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
  Future<List<PermissionAudit>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PermissionAuditTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PermissionAuditTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PermissionAuditTable>? orderByList,
    _i1.Transaction? transaction,
    PermissionAuditInclude? include,
  }) async {
    return session.db.find<PermissionAudit>(
      where: where?.call(PermissionAudit.t),
      orderBy: orderBy?.call(PermissionAudit.t),
      orderByList: orderByList?.call(PermissionAudit.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [PermissionAudit] matching the given query parameters.
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
  Future<PermissionAudit?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PermissionAuditTable>? where,
    int? offset,
    _i1.OrderByBuilder<PermissionAuditTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PermissionAuditTable>? orderByList,
    _i1.Transaction? transaction,
    PermissionAuditInclude? include,
  }) async {
    return session.db.findFirstRow<PermissionAudit>(
      where: where?.call(PermissionAudit.t),
      orderBy: orderBy?.call(PermissionAudit.t),
      orderByList: orderByList?.call(PermissionAudit.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [PermissionAudit] by its [id] or null if no such row exists.
  Future<PermissionAudit?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    PermissionAuditInclude? include,
  }) async {
    return session.db.findById<PermissionAudit>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [PermissionAudit]s in the list and returns the inserted rows.
  ///
  /// The returned [PermissionAudit]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<PermissionAudit>> insert(
    _i1.Session session,
    List<PermissionAudit> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<PermissionAudit>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [PermissionAudit] and returns the inserted row.
  ///
  /// The returned [PermissionAudit] will have its `id` field set.
  Future<PermissionAudit> insertRow(
    _i1.Session session,
    PermissionAudit row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PermissionAudit>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PermissionAudit]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PermissionAudit>> update(
    _i1.Session session,
    List<PermissionAudit> rows, {
    _i1.ColumnSelections<PermissionAuditTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PermissionAudit>(
      rows,
      columns: columns?.call(PermissionAudit.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PermissionAudit]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PermissionAudit> updateRow(
    _i1.Session session,
    PermissionAudit row, {
    _i1.ColumnSelections<PermissionAuditTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PermissionAudit>(
      row,
      columns: columns?.call(PermissionAudit.t),
      transaction: transaction,
    );
  }

  /// Deletes all [PermissionAudit]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PermissionAudit>> delete(
    _i1.Session session,
    List<PermissionAudit> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PermissionAudit>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PermissionAudit].
  Future<PermissionAudit> deleteRow(
    _i1.Session session,
    PermissionAudit row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PermissionAudit>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PermissionAudit>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PermissionAuditTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PermissionAudit>(
      where: where(PermissionAudit.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PermissionAuditTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PermissionAudit>(
      where: where?.call(PermissionAudit.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class PermissionAuditAttachRowRepository {
  const PermissionAuditAttachRowRepository._();

  /// Creates a relation between the given [PermissionAudit] and [User]
  /// by setting the [PermissionAudit]'s foreign key `userId` to refer to the [User].
  Future<void> user(
    _i1.Session session,
    PermissionAudit permissionAudit,
    _i2.User user, {
    _i1.Transaction? transaction,
  }) async {
    if (permissionAudit.id == null) {
      throw ArgumentError.notNull('permissionAudit.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $permissionAudit = permissionAudit.copyWith(userId: user.id);
    await session.db.updateRow<PermissionAudit>(
      $permissionAudit,
      columns: [PermissionAudit.t.userId],
      transaction: transaction,
    );
  }
}
