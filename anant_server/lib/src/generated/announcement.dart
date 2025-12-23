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

abstract class Announcement
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Announcement._({
    this.id,
    required this.organizationId,
    required this.title,
    required this.content,
    required this.priority,
    required this.targetAudience,
    this.targetClasses,
    required this.createdBy,
    DateTime? createdAt,
    this.updatedAt,
    bool? isActive,
  })  : createdAt = createdAt ?? DateTime.now(),
        isActive = isActive ?? true;

  factory Announcement({
    int? id,
    required int organizationId,
    required String title,
    required String content,
    required String priority,
    required String targetAudience,
    String? targetClasses,
    required String createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) = _AnnouncementImpl;

  factory Announcement.fromJson(Map<String, dynamic> jsonSerialization) {
    return Announcement(
      id: jsonSerialization['id'] as int?,
      organizationId: jsonSerialization['organizationId'] as int,
      title: jsonSerialization['title'] as String,
      content: jsonSerialization['content'] as String,
      priority: jsonSerialization['priority'] as String,
      targetAudience: jsonSerialization['targetAudience'] as String,
      targetClasses: jsonSerialization['targetClasses'] as String?,
      createdBy: jsonSerialization['createdBy'] as String,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      isActive: jsonSerialization['isActive'] as bool,
    );
  }

  static final t = AnnouncementTable();

  static const db = AnnouncementRepository._();

  @override
  int? id;

  int organizationId;

  String title;

  String content;

  String priority;

  String targetAudience;

  String? targetClasses;

  String createdBy;

  DateTime createdAt;

  DateTime? updatedAt;

  bool isActive;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Announcement]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Announcement copyWith({
    int? id,
    int? organizationId,
    String? title,
    String? content,
    String? priority,
    String? targetAudience,
    String? targetClasses,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'organizationId': organizationId,
      'title': title,
      'content': content,
      'priority': priority,
      'targetAudience': targetAudience,
      if (targetClasses != null) 'targetClasses': targetClasses,
      'createdBy': createdBy,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      'isActive': isActive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'organizationId': organizationId,
      'title': title,
      'content': content,
      'priority': priority,
      'targetAudience': targetAudience,
      if (targetClasses != null) 'targetClasses': targetClasses,
      'createdBy': createdBy,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      'isActive': isActive,
    };
  }

  static AnnouncementInclude include() {
    return AnnouncementInclude._();
  }

  static AnnouncementIncludeList includeList({
    _i1.WhereExpressionBuilder<AnnouncementTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AnnouncementTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AnnouncementTable>? orderByList,
    AnnouncementInclude? include,
  }) {
    return AnnouncementIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Announcement.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Announcement.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AnnouncementImpl extends Announcement {
  _AnnouncementImpl({
    int? id,
    required int organizationId,
    required String title,
    required String content,
    required String priority,
    required String targetAudience,
    String? targetClasses,
    required String createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) : super._(
          id: id,
          organizationId: organizationId,
          title: title,
          content: content,
          priority: priority,
          targetAudience: targetAudience,
          targetClasses: targetClasses,
          createdBy: createdBy,
          createdAt: createdAt,
          updatedAt: updatedAt,
          isActive: isActive,
        );

  /// Returns a shallow copy of this [Announcement]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Announcement copyWith({
    Object? id = _Undefined,
    int? organizationId,
    String? title,
    String? content,
    String? priority,
    String? targetAudience,
    Object? targetClasses = _Undefined,
    String? createdBy,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    bool? isActive,
  }) {
    return Announcement(
      id: id is int? ? id : this.id,
      organizationId: organizationId ?? this.organizationId,
      title: title ?? this.title,
      content: content ?? this.content,
      priority: priority ?? this.priority,
      targetAudience: targetAudience ?? this.targetAudience,
      targetClasses:
          targetClasses is String? ? targetClasses : this.targetClasses,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

class AnnouncementTable extends _i1.Table<int?> {
  AnnouncementTable({super.tableRelation}) : super(tableName: 'announcements') {
    organizationId = _i1.ColumnInt(
      'organizationId',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    content = _i1.ColumnString(
      'content',
      this,
    );
    priority = _i1.ColumnString(
      'priority',
      this,
    );
    targetAudience = _i1.ColumnString(
      'targetAudience',
      this,
    );
    targetClasses = _i1.ColumnString(
      'targetClasses',
      this,
    );
    createdBy = _i1.ColumnString(
      'createdBy',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnInt organizationId;

  late final _i1.ColumnString title;

  late final _i1.ColumnString content;

  late final _i1.ColumnString priority;

  late final _i1.ColumnString targetAudience;

  late final _i1.ColumnString targetClasses;

  late final _i1.ColumnString createdBy;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnBool isActive;

  @override
  List<_i1.Column> get columns => [
        id,
        organizationId,
        title,
        content,
        priority,
        targetAudience,
        targetClasses,
        createdBy,
        createdAt,
        updatedAt,
        isActive,
      ];
}

class AnnouncementInclude extends _i1.IncludeObject {
  AnnouncementInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Announcement.t;
}

class AnnouncementIncludeList extends _i1.IncludeList {
  AnnouncementIncludeList._({
    _i1.WhereExpressionBuilder<AnnouncementTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Announcement.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Announcement.t;
}

class AnnouncementRepository {
  const AnnouncementRepository._();

  /// Returns a list of [Announcement]s matching the given query parameters.
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
  Future<List<Announcement>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AnnouncementTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AnnouncementTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AnnouncementTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Announcement>(
      where: where?.call(Announcement.t),
      orderBy: orderBy?.call(Announcement.t),
      orderByList: orderByList?.call(Announcement.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Announcement] matching the given query parameters.
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
  Future<Announcement?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AnnouncementTable>? where,
    int? offset,
    _i1.OrderByBuilder<AnnouncementTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AnnouncementTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Announcement>(
      where: where?.call(Announcement.t),
      orderBy: orderBy?.call(Announcement.t),
      orderByList: orderByList?.call(Announcement.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Announcement] by its [id] or null if no such row exists.
  Future<Announcement?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Announcement>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Announcement]s in the list and returns the inserted rows.
  ///
  /// The returned [Announcement]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Announcement>> insert(
    _i1.Session session,
    List<Announcement> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Announcement>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Announcement] and returns the inserted row.
  ///
  /// The returned [Announcement] will have its `id` field set.
  Future<Announcement> insertRow(
    _i1.Session session,
    Announcement row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Announcement>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Announcement]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Announcement>> update(
    _i1.Session session,
    List<Announcement> rows, {
    _i1.ColumnSelections<AnnouncementTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Announcement>(
      rows,
      columns: columns?.call(Announcement.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Announcement]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Announcement> updateRow(
    _i1.Session session,
    Announcement row, {
    _i1.ColumnSelections<AnnouncementTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Announcement>(
      row,
      columns: columns?.call(Announcement.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Announcement]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Announcement>> delete(
    _i1.Session session,
    List<Announcement> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Announcement>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Announcement].
  Future<Announcement> deleteRow(
    _i1.Session session,
    Announcement row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Announcement>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Announcement>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AnnouncementTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Announcement>(
      where: where(Announcement.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AnnouncementTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Announcement>(
      where: where?.call(Announcement.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
