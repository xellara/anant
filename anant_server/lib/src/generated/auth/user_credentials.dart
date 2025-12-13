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

abstract class UserCredentials
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UserCredentials._({
    this.id,
    required this.uid,
    this.userId,
    required this.passwordHash,
    this.anantId,
    this.createdAt,
    this.updatedAt,
  });

  factory UserCredentials({
    int? id,
    required String uid,
    int? userId,
    required String passwordHash,
    String? anantId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserCredentialsImpl;

  factory UserCredentials.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserCredentials(
      id: jsonSerialization['id'] as int?,
      uid: jsonSerialization['uid'] as String,
      userId: jsonSerialization['userId'] as int?,
      passwordHash: jsonSerialization['passwordHash'] as String,
      anantId: jsonSerialization['anantId'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = UserCredentialsTable();

  static const db = UserCredentialsRepository._();

  @override
  int? id;

  String uid;

  int? userId;

  String passwordHash;

  String? anantId;

  DateTime? createdAt;

  DateTime? updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserCredentials]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserCredentials copyWith({
    int? id,
    String? uid,
    int? userId,
    String? passwordHash,
    String? anantId,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'uid': uid,
      if (userId != null) 'userId': userId,
      'passwordHash': passwordHash,
      if (anantId != null) 'anantId': anantId,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'uid': uid,
      if (userId != null) 'userId': userId,
      'passwordHash': passwordHash,
      if (anantId != null) 'anantId': anantId,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  static UserCredentialsInclude include() {
    return UserCredentialsInclude._();
  }

  static UserCredentialsIncludeList includeList({
    _i1.WhereExpressionBuilder<UserCredentialsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserCredentialsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserCredentialsTable>? orderByList,
    UserCredentialsInclude? include,
  }) {
    return UserCredentialsIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserCredentials.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserCredentials.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserCredentialsImpl extends UserCredentials {
  _UserCredentialsImpl({
    int? id,
    required String uid,
    int? userId,
    required String passwordHash,
    String? anantId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
          id: id,
          uid: uid,
          userId: userId,
          passwordHash: passwordHash,
          anantId: anantId,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Returns a shallow copy of this [UserCredentials]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserCredentials copyWith({
    Object? id = _Undefined,
    String? uid,
    Object? userId = _Undefined,
    String? passwordHash,
    Object? anantId = _Undefined,
    Object? createdAt = _Undefined,
    Object? updatedAt = _Undefined,
  }) {
    return UserCredentials(
      id: id is int? ? id : this.id,
      uid: uid ?? this.uid,
      userId: userId is int? ? userId : this.userId,
      passwordHash: passwordHash ?? this.passwordHash,
      anantId: anantId is String? ? anantId : this.anantId,
      createdAt: createdAt is DateTime? ? createdAt : this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}

class UserCredentialsTable extends _i1.Table<int?> {
  UserCredentialsTable({super.tableRelation})
      : super(tableName: 'user_credentials') {
    uid = _i1.ColumnString(
      'uid',
      this,
    );
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    passwordHash = _i1.ColumnString(
      'passwordHash',
      this,
    );
    anantId = _i1.ColumnString(
      'anantId',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final _i1.ColumnString uid;

  late final _i1.ColumnInt userId;

  late final _i1.ColumnString passwordHash;

  late final _i1.ColumnString anantId;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
        id,
        uid,
        userId,
        passwordHash,
        anantId,
        createdAt,
        updatedAt,
      ];
}

class UserCredentialsInclude extends _i1.IncludeObject {
  UserCredentialsInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UserCredentials.t;
}

class UserCredentialsIncludeList extends _i1.IncludeList {
  UserCredentialsIncludeList._({
    _i1.WhereExpressionBuilder<UserCredentialsTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserCredentials.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UserCredentials.t;
}

class UserCredentialsRepository {
  const UserCredentialsRepository._();

  /// Returns a list of [UserCredentials]s matching the given query parameters.
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
  Future<List<UserCredentials>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserCredentialsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserCredentialsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserCredentialsTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UserCredentials>(
      where: where?.call(UserCredentials.t),
      orderBy: orderBy?.call(UserCredentials.t),
      orderByList: orderByList?.call(UserCredentials.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [UserCredentials] matching the given query parameters.
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
  Future<UserCredentials?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserCredentialsTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserCredentialsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserCredentialsTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UserCredentials>(
      where: where?.call(UserCredentials.t),
      orderBy: orderBy?.call(UserCredentials.t),
      orderByList: orderByList?.call(UserCredentials.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [UserCredentials] by its [id] or null if no such row exists.
  Future<UserCredentials?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UserCredentials>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [UserCredentials]s in the list and returns the inserted rows.
  ///
  /// The returned [UserCredentials]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UserCredentials>> insert(
    _i1.Session session,
    List<UserCredentials> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserCredentials>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UserCredentials] and returns the inserted row.
  ///
  /// The returned [UserCredentials] will have its `id` field set.
  Future<UserCredentials> insertRow(
    _i1.Session session,
    UserCredentials row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserCredentials>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserCredentials]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserCredentials>> update(
    _i1.Session session,
    List<UserCredentials> rows, {
    _i1.ColumnSelections<UserCredentialsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserCredentials>(
      rows,
      columns: columns?.call(UserCredentials.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserCredentials]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserCredentials> updateRow(
    _i1.Session session,
    UserCredentials row, {
    _i1.ColumnSelections<UserCredentialsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserCredentials>(
      row,
      columns: columns?.call(UserCredentials.t),
      transaction: transaction,
    );
  }

  /// Deletes all [UserCredentials]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserCredentials>> delete(
    _i1.Session session,
    List<UserCredentials> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserCredentials>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserCredentials].
  Future<UserCredentials> deleteRow(
    _i1.Session session,
    UserCredentials row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserCredentials>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserCredentials>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserCredentialsTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserCredentials>(
      where: where(UserCredentials.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserCredentialsTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserCredentials>(
      where: where?.call(UserCredentials.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
