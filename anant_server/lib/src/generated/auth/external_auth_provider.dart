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

/// External Authentication Provider Mapping
/// Maps external provider UIDs (Firebase, Google, etc.) to internal UID
abstract class ExternalAuthProvider
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ExternalAuthProvider._({
    this.id,
    required this.uid,
    required this.provider,
    required this.providerUid,
    this.providerEmail,
    this.metadata,
    this.createdAt,
    this.updatedAt,
  });

  factory ExternalAuthProvider({
    int? id,
    required String uid,
    required String provider,
    required String providerUid,
    String? providerEmail,
    String? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ExternalAuthProviderImpl;

  factory ExternalAuthProvider.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ExternalAuthProvider(
      id: jsonSerialization['id'] as int?,
      uid: jsonSerialization['uid'] as String,
      provider: jsonSerialization['provider'] as String,
      providerUid: jsonSerialization['providerUid'] as String,
      providerEmail: jsonSerialization['providerEmail'] as String?,
      metadata: jsonSerialization['metadata'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = ExternalAuthProviderTable();

  static const db = ExternalAuthProviderRepository._();

  @override
  int? id;

  String uid;

  String provider;

  String providerUid;

  String? providerEmail;

  String? metadata;

  DateTime? createdAt;

  DateTime? updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ExternalAuthProvider]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ExternalAuthProvider copyWith({
    int? id,
    String? uid,
    String? provider,
    String? providerUid,
    String? providerEmail,
    String? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ExternalAuthProvider',
      if (id != null) 'id': id,
      'uid': uid,
      'provider': provider,
      'providerUid': providerUid,
      if (providerEmail != null) 'providerEmail': providerEmail,
      if (metadata != null) 'metadata': metadata,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ExternalAuthProvider',
      if (id != null) 'id': id,
      'uid': uid,
      'provider': provider,
      'providerUid': providerUid,
      if (providerEmail != null) 'providerEmail': providerEmail,
      if (metadata != null) 'metadata': metadata,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  static ExternalAuthProviderInclude include() {
    return ExternalAuthProviderInclude._();
  }

  static ExternalAuthProviderIncludeList includeList({
    _i1.WhereExpressionBuilder<ExternalAuthProviderTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ExternalAuthProviderTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ExternalAuthProviderTable>? orderByList,
    ExternalAuthProviderInclude? include,
  }) {
    return ExternalAuthProviderIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ExternalAuthProvider.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ExternalAuthProvider.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ExternalAuthProviderImpl extends ExternalAuthProvider {
  _ExternalAuthProviderImpl({
    int? id,
    required String uid,
    required String provider,
    required String providerUid,
    String? providerEmail,
    String? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         uid: uid,
         provider: provider,
         providerUid: providerUid,
         providerEmail: providerEmail,
         metadata: metadata,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ExternalAuthProvider]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ExternalAuthProvider copyWith({
    Object? id = _Undefined,
    String? uid,
    String? provider,
    String? providerUid,
    Object? providerEmail = _Undefined,
    Object? metadata = _Undefined,
    Object? createdAt = _Undefined,
    Object? updatedAt = _Undefined,
  }) {
    return ExternalAuthProvider(
      id: id is int? ? id : this.id,
      uid: uid ?? this.uid,
      provider: provider ?? this.provider,
      providerUid: providerUid ?? this.providerUid,
      providerEmail: providerEmail is String?
          ? providerEmail
          : this.providerEmail,
      metadata: metadata is String? ? metadata : this.metadata,
      createdAt: createdAt is DateTime? ? createdAt : this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}

class ExternalAuthProviderUpdateTable
    extends _i1.UpdateTable<ExternalAuthProviderTable> {
  ExternalAuthProviderUpdateTable(super.table);

  _i1.ColumnValue<String, String> uid(String value) => _i1.ColumnValue(
    table.uid,
    value,
  );

  _i1.ColumnValue<String, String> provider(String value) => _i1.ColumnValue(
    table.provider,
    value,
  );

  _i1.ColumnValue<String, String> providerUid(String value) => _i1.ColumnValue(
    table.providerUid,
    value,
  );

  _i1.ColumnValue<String, String> providerEmail(String? value) =>
      _i1.ColumnValue(
        table.providerEmail,
        value,
      );

  _i1.ColumnValue<String, String> metadata(String? value) => _i1.ColumnValue(
    table.metadata,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime? value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class ExternalAuthProviderTable extends _i1.Table<int?> {
  ExternalAuthProviderTable({super.tableRelation})
    : super(tableName: 'external_auth_provider') {
    updateTable = ExternalAuthProviderUpdateTable(this);
    uid = _i1.ColumnString(
      'uid',
      this,
    );
    provider = _i1.ColumnString(
      'provider',
      this,
    );
    providerUid = _i1.ColumnString(
      'providerUid',
      this,
    );
    providerEmail = _i1.ColumnString(
      'providerEmail',
      this,
    );
    metadata = _i1.ColumnString(
      'metadata',
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

  late final ExternalAuthProviderUpdateTable updateTable;

  late final _i1.ColumnString uid;

  late final _i1.ColumnString provider;

  late final _i1.ColumnString providerUid;

  late final _i1.ColumnString providerEmail;

  late final _i1.ColumnString metadata;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    uid,
    provider,
    providerUid,
    providerEmail,
    metadata,
    createdAt,
    updatedAt,
  ];
}

class ExternalAuthProviderInclude extends _i1.IncludeObject {
  ExternalAuthProviderInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ExternalAuthProvider.t;
}

class ExternalAuthProviderIncludeList extends _i1.IncludeList {
  ExternalAuthProviderIncludeList._({
    _i1.WhereExpressionBuilder<ExternalAuthProviderTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ExternalAuthProvider.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ExternalAuthProvider.t;
}

class ExternalAuthProviderRepository {
  const ExternalAuthProviderRepository._();

  /// Returns a list of [ExternalAuthProvider]s matching the given query parameters.
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
  Future<List<ExternalAuthProvider>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ExternalAuthProviderTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ExternalAuthProviderTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ExternalAuthProviderTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ExternalAuthProvider>(
      where: where?.call(ExternalAuthProvider.t),
      orderBy: orderBy?.call(ExternalAuthProvider.t),
      orderByList: orderByList?.call(ExternalAuthProvider.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ExternalAuthProvider] matching the given query parameters.
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
  Future<ExternalAuthProvider?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ExternalAuthProviderTable>? where,
    int? offset,
    _i1.OrderByBuilder<ExternalAuthProviderTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ExternalAuthProviderTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ExternalAuthProvider>(
      where: where?.call(ExternalAuthProvider.t),
      orderBy: orderBy?.call(ExternalAuthProvider.t),
      orderByList: orderByList?.call(ExternalAuthProvider.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ExternalAuthProvider] by its [id] or null if no such row exists.
  Future<ExternalAuthProvider?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ExternalAuthProvider>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ExternalAuthProvider]s in the list and returns the inserted rows.
  ///
  /// The returned [ExternalAuthProvider]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ExternalAuthProvider>> insert(
    _i1.Session session,
    List<ExternalAuthProvider> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ExternalAuthProvider>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ExternalAuthProvider] and returns the inserted row.
  ///
  /// The returned [ExternalAuthProvider] will have its `id` field set.
  Future<ExternalAuthProvider> insertRow(
    _i1.Session session,
    ExternalAuthProvider row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ExternalAuthProvider>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ExternalAuthProvider]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ExternalAuthProvider>> update(
    _i1.Session session,
    List<ExternalAuthProvider> rows, {
    _i1.ColumnSelections<ExternalAuthProviderTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ExternalAuthProvider>(
      rows,
      columns: columns?.call(ExternalAuthProvider.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ExternalAuthProvider]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ExternalAuthProvider> updateRow(
    _i1.Session session,
    ExternalAuthProvider row, {
    _i1.ColumnSelections<ExternalAuthProviderTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ExternalAuthProvider>(
      row,
      columns: columns?.call(ExternalAuthProvider.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ExternalAuthProvider] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ExternalAuthProvider?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ExternalAuthProviderUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ExternalAuthProvider>(
      id,
      columnValues: columnValues(ExternalAuthProvider.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ExternalAuthProvider]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ExternalAuthProvider>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ExternalAuthProviderUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ExternalAuthProviderTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ExternalAuthProviderTable>? orderBy,
    _i1.OrderByListBuilder<ExternalAuthProviderTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ExternalAuthProvider>(
      columnValues: columnValues(ExternalAuthProvider.t.updateTable),
      where: where(ExternalAuthProvider.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ExternalAuthProvider.t),
      orderByList: orderByList?.call(ExternalAuthProvider.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ExternalAuthProvider]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ExternalAuthProvider>> delete(
    _i1.Session session,
    List<ExternalAuthProvider> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ExternalAuthProvider>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ExternalAuthProvider].
  Future<ExternalAuthProvider> deleteRow(
    _i1.Session session,
    ExternalAuthProvider row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ExternalAuthProvider>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ExternalAuthProvider>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ExternalAuthProviderTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ExternalAuthProvider>(
      where: where(ExternalAuthProvider.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ExternalAuthProviderTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ExternalAuthProvider>(
      where: where?.call(ExternalAuthProvider.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
