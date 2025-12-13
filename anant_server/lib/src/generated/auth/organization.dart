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

/// Organization
abstract class Organization
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Organization._({
    this.id,
    required this.name,
    required this.organizationName,
    this.code,
    required this.type,
    this.address,
    this.city,
    this.state,
    String? country,
    this.pincode,
    this.contactNumber,
    this.email,
    this.website,
    this.logoUrl,
    bool? isActive,
    required this.createdAt,
    this.monthlyFees,
    this.feeStartAndEndMonth,
    this.admissionFee,
    this.gstNumber,
    this.panNumber,
  })  : country = country ?? 'India',
        isActive = isActive ?? true;

  factory Organization({
    int? id,
    required String name,
    required String organizationName,
    String? code,
    required String type,
    String? address,
    String? city,
    String? state,
    String? country,
    String? pincode,
    String? contactNumber,
    String? email,
    String? website,
    String? logoUrl,
    bool? isActive,
    required DateTime createdAt,
    Map<String, double>? monthlyFees,
    Map<String, String>? feeStartAndEndMonth,
    double? admissionFee,
    String? gstNumber,
    String? panNumber,
  }) = _OrganizationImpl;

  factory Organization.fromJson(Map<String, dynamic> jsonSerialization) {
    return Organization(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      organizationName: jsonSerialization['organizationName'] as String,
      code: jsonSerialization['code'] as String?,
      type: jsonSerialization['type'] as String,
      address: jsonSerialization['address'] as String?,
      city: jsonSerialization['city'] as String?,
      state: jsonSerialization['state'] as String?,
      country: jsonSerialization['country'] as String,
      pincode: jsonSerialization['pincode'] as String?,
      contactNumber: jsonSerialization['contactNumber'] as String?,
      email: jsonSerialization['email'] as String?,
      website: jsonSerialization['website'] as String?,
      logoUrl: jsonSerialization['logoUrl'] as String?,
      isActive: jsonSerialization['isActive'] as bool,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      monthlyFees:
          (jsonSerialization['monthlyFees'] as Map?)?.map((k, v) => MapEntry(
                k as String,
                (v as num).toDouble(),
              )),
      feeStartAndEndMonth: (jsonSerialization['feeStartAndEndMonth'] as Map?)
          ?.map((k, v) => MapEntry(
                k as String,
                v as String,
              )),
      admissionFee: (jsonSerialization['admissionFee'] as num?)?.toDouble(),
      gstNumber: jsonSerialization['gstNumber'] as String?,
      panNumber: jsonSerialization['panNumber'] as String?,
    );
  }

  static final t = OrganizationTable();

  static const db = OrganizationRepository._();

  @override
  int? id;

  String name;

  String organizationName;

  String? code;

  String type;

  String? address;

  String? city;

  String? state;

  String country;

  String? pincode;

  String? contactNumber;

  String? email;

  String? website;

  String? logoUrl;

  bool isActive;

  DateTime createdAt;

  Map<String, double>? monthlyFees;

  Map<String, String>? feeStartAndEndMonth;

  double? admissionFee;

  String? gstNumber;

  String? panNumber;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Organization]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Organization copyWith({
    int? id,
    String? name,
    String? organizationName,
    String? code,
    String? type,
    String? address,
    String? city,
    String? state,
    String? country,
    String? pincode,
    String? contactNumber,
    String? email,
    String? website,
    String? logoUrl,
    bool? isActive,
    DateTime? createdAt,
    Map<String, double>? monthlyFees,
    Map<String, String>? feeStartAndEndMonth,
    double? admissionFee,
    String? gstNumber,
    String? panNumber,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'organizationName': organizationName,
      if (code != null) 'code': code,
      'type': type,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      'country': country,
      if (pincode != null) 'pincode': pincode,
      if (contactNumber != null) 'contactNumber': contactNumber,
      if (email != null) 'email': email,
      if (website != null) 'website': website,
      if (logoUrl != null) 'logoUrl': logoUrl,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
      if (monthlyFees != null) 'monthlyFees': monthlyFees?.toJson(),
      if (feeStartAndEndMonth != null)
        'feeStartAndEndMonth': feeStartAndEndMonth?.toJson(),
      if (admissionFee != null) 'admissionFee': admissionFee,
      if (gstNumber != null) 'gstNumber': gstNumber,
      if (panNumber != null) 'panNumber': panNumber,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'organizationName': organizationName,
      if (code != null) 'code': code,
      'type': type,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      'country': country,
      if (pincode != null) 'pincode': pincode,
      if (contactNumber != null) 'contactNumber': contactNumber,
      if (email != null) 'email': email,
      if (website != null) 'website': website,
      if (logoUrl != null) 'logoUrl': logoUrl,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
      if (monthlyFees != null) 'monthlyFees': monthlyFees?.toJson(),
      if (feeStartAndEndMonth != null)
        'feeStartAndEndMonth': feeStartAndEndMonth?.toJson(),
      if (admissionFee != null) 'admissionFee': admissionFee,
      if (gstNumber != null) 'gstNumber': gstNumber,
      if (panNumber != null) 'panNumber': panNumber,
    };
  }

  static OrganizationInclude include() {
    return OrganizationInclude._();
  }

  static OrganizationIncludeList includeList({
    _i1.WhereExpressionBuilder<OrganizationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrganizationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrganizationTable>? orderByList,
    OrganizationInclude? include,
  }) {
    return OrganizationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Organization.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Organization.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrganizationImpl extends Organization {
  _OrganizationImpl({
    int? id,
    required String name,
    required String organizationName,
    String? code,
    required String type,
    String? address,
    String? city,
    String? state,
    String? country,
    String? pincode,
    String? contactNumber,
    String? email,
    String? website,
    String? logoUrl,
    bool? isActive,
    required DateTime createdAt,
    Map<String, double>? monthlyFees,
    Map<String, String>? feeStartAndEndMonth,
    double? admissionFee,
    String? gstNumber,
    String? panNumber,
  }) : super._(
          id: id,
          name: name,
          organizationName: organizationName,
          code: code,
          type: type,
          address: address,
          city: city,
          state: state,
          country: country,
          pincode: pincode,
          contactNumber: contactNumber,
          email: email,
          website: website,
          logoUrl: logoUrl,
          isActive: isActive,
          createdAt: createdAt,
          monthlyFees: monthlyFees,
          feeStartAndEndMonth: feeStartAndEndMonth,
          admissionFee: admissionFee,
          gstNumber: gstNumber,
          panNumber: panNumber,
        );

  /// Returns a shallow copy of this [Organization]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Organization copyWith({
    Object? id = _Undefined,
    String? name,
    String? organizationName,
    Object? code = _Undefined,
    String? type,
    Object? address = _Undefined,
    Object? city = _Undefined,
    Object? state = _Undefined,
    String? country,
    Object? pincode = _Undefined,
    Object? contactNumber = _Undefined,
    Object? email = _Undefined,
    Object? website = _Undefined,
    Object? logoUrl = _Undefined,
    bool? isActive,
    DateTime? createdAt,
    Object? monthlyFees = _Undefined,
    Object? feeStartAndEndMonth = _Undefined,
    Object? admissionFee = _Undefined,
    Object? gstNumber = _Undefined,
    Object? panNumber = _Undefined,
  }) {
    return Organization(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      organizationName: organizationName ?? this.organizationName,
      code: code is String? ? code : this.code,
      type: type ?? this.type,
      address: address is String? ? address : this.address,
      city: city is String? ? city : this.city,
      state: state is String? ? state : this.state,
      country: country ?? this.country,
      pincode: pincode is String? ? pincode : this.pincode,
      contactNumber:
          contactNumber is String? ? contactNumber : this.contactNumber,
      email: email is String? ? email : this.email,
      website: website is String? ? website : this.website,
      logoUrl: logoUrl is String? ? logoUrl : this.logoUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      monthlyFees: monthlyFees is Map<String, double>?
          ? monthlyFees
          : this.monthlyFees?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      feeStartAndEndMonth: feeStartAndEndMonth is Map<String, String>?
          ? feeStartAndEndMonth
          : this.feeStartAndEndMonth?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      admissionFee: admissionFee is double? ? admissionFee : this.admissionFee,
      gstNumber: gstNumber is String? ? gstNumber : this.gstNumber,
      panNumber: panNumber is String? ? panNumber : this.panNumber,
    );
  }
}

class OrganizationTable extends _i1.Table<int?> {
  OrganizationTable({super.tableRelation}) : super(tableName: 'organization') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    organizationName = _i1.ColumnString(
      'organizationName',
      this,
    );
    code = _i1.ColumnString(
      'code',
      this,
    );
    type = _i1.ColumnString(
      'type',
      this,
    );
    address = _i1.ColumnString(
      'address',
      this,
    );
    city = _i1.ColumnString(
      'city',
      this,
    );
    state = _i1.ColumnString(
      'state',
      this,
    );
    country = _i1.ColumnString(
      'country',
      this,
      hasDefault: true,
    );
    pincode = _i1.ColumnString(
      'pincode',
      this,
    );
    contactNumber = _i1.ColumnString(
      'contactNumber',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    website = _i1.ColumnString(
      'website',
      this,
    );
    logoUrl = _i1.ColumnString(
      'logoUrl',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
      hasDefault: true,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    monthlyFees = _i1.ColumnSerializable(
      'monthlyFees',
      this,
    );
    feeStartAndEndMonth = _i1.ColumnSerializable(
      'feeStartAndEndMonth',
      this,
    );
    admissionFee = _i1.ColumnDouble(
      'admissionFee',
      this,
    );
    gstNumber = _i1.ColumnString(
      'gstNumber',
      this,
    );
    panNumber = _i1.ColumnString(
      'panNumber',
      this,
    );
  }

  late final _i1.ColumnString name;

  late final _i1.ColumnString organizationName;

  late final _i1.ColumnString code;

  late final _i1.ColumnString type;

  late final _i1.ColumnString address;

  late final _i1.ColumnString city;

  late final _i1.ColumnString state;

  late final _i1.ColumnString country;

  late final _i1.ColumnString pincode;

  late final _i1.ColumnString contactNumber;

  late final _i1.ColumnString email;

  late final _i1.ColumnString website;

  late final _i1.ColumnString logoUrl;

  late final _i1.ColumnBool isActive;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnSerializable monthlyFees;

  late final _i1.ColumnSerializable feeStartAndEndMonth;

  late final _i1.ColumnDouble admissionFee;

  late final _i1.ColumnString gstNumber;

  late final _i1.ColumnString panNumber;

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        organizationName,
        code,
        type,
        address,
        city,
        state,
        country,
        pincode,
        contactNumber,
        email,
        website,
        logoUrl,
        isActive,
        createdAt,
        monthlyFees,
        feeStartAndEndMonth,
        admissionFee,
        gstNumber,
        panNumber,
      ];
}

class OrganizationInclude extends _i1.IncludeObject {
  OrganizationInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Organization.t;
}

class OrganizationIncludeList extends _i1.IncludeList {
  OrganizationIncludeList._({
    _i1.WhereExpressionBuilder<OrganizationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Organization.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Organization.t;
}

class OrganizationRepository {
  const OrganizationRepository._();

  /// Returns a list of [Organization]s matching the given query parameters.
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
  Future<List<Organization>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<OrganizationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrganizationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrganizationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Organization>(
      where: where?.call(Organization.t),
      orderBy: orderBy?.call(Organization.t),
      orderByList: orderByList?.call(Organization.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Organization] matching the given query parameters.
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
  Future<Organization?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<OrganizationTable>? where,
    int? offset,
    _i1.OrderByBuilder<OrganizationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrganizationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Organization>(
      where: where?.call(Organization.t),
      orderBy: orderBy?.call(Organization.t),
      orderByList: orderByList?.call(Organization.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Organization] by its [id] or null if no such row exists.
  Future<Organization?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Organization>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Organization]s in the list and returns the inserted rows.
  ///
  /// The returned [Organization]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Organization>> insert(
    _i1.Session session,
    List<Organization> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Organization>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Organization] and returns the inserted row.
  ///
  /// The returned [Organization] will have its `id` field set.
  Future<Organization> insertRow(
    _i1.Session session,
    Organization row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Organization>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Organization]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Organization>> update(
    _i1.Session session,
    List<Organization> rows, {
    _i1.ColumnSelections<OrganizationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Organization>(
      rows,
      columns: columns?.call(Organization.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Organization]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Organization> updateRow(
    _i1.Session session,
    Organization row, {
    _i1.ColumnSelections<OrganizationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Organization>(
      row,
      columns: columns?.call(Organization.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Organization]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Organization>> delete(
    _i1.Session session,
    List<Organization> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Organization>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Organization].
  Future<Organization> deleteRow(
    _i1.Session session,
    Organization row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Organization>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Organization>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<OrganizationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Organization>(
      where: where(Organization.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<OrganizationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Organization>(
      where: where?.call(Organization.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
