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
import '../user/user_role.dart' as _i2;

/// User
abstract class User implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  User._({
    this.id,
    this.uid,
    this.anantId,
    this.email,
    this.mobileNumber,
    required this.role,
    this.fullName,
    this.profileImageUrl,
    required this.organizationName,
    this.className,
    this.sectionName,
    this.rollNumber,
    this.admissionNumber,
    this.gender,
    this.dob,
    this.bloodGroup,
    this.aadharNumber,
    this.address,
    this.city,
    this.state,
    String? country,
    this.pincode,
    this.parentMobileNumber,
    this.parentEmail,
    this.subjectTeaching,
    this.classAndSectionTeaching,
    bool? isPasswordCreated,
    bool? isActive,
    bool? isPremiumUser,
    this.createdAt,
    this.updatedAt,
  })  : country = country ?? 'India',
        isPasswordCreated = isPasswordCreated ?? false,
        isActive = isActive ?? false,
        isPremiumUser = isPremiumUser ?? false;

  factory User({
    int? id,
    String? uid,
    String? anantId,
    String? email,
    String? mobileNumber,
    required _i2.UserRole role,
    String? fullName,
    String? profileImageUrl,
    required String organizationName,
    String? className,
    String? sectionName,
    String? rollNumber,
    String? admissionNumber,
    String? gender,
    String? dob,
    String? bloodGroup,
    String? aadharNumber,
    String? address,
    String? city,
    String? state,
    String? country,
    String? pincode,
    String? parentMobileNumber,
    String? parentEmail,
    List<String>? subjectTeaching,
    List<String>? classAndSectionTeaching,
    bool? isPasswordCreated,
    bool? isActive,
    bool? isPremiumUser,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserImpl;

  factory User.fromJson(Map<String, dynamic> jsonSerialization) {
    return User(
      id: jsonSerialization['id'] as int?,
      uid: jsonSerialization['uid'] as String?,
      anantId: jsonSerialization['anantId'] as String?,
      email: jsonSerialization['email'] as String?,
      mobileNumber: jsonSerialization['mobileNumber'] as String?,
      role: _i2.UserRole.fromJson((jsonSerialization['role'] as String)),
      fullName: jsonSerialization['fullName'] as String?,
      profileImageUrl: jsonSerialization['profileImageUrl'] as String?,
      organizationName: jsonSerialization['organizationName'] as String,
      className: jsonSerialization['className'] as String?,
      sectionName: jsonSerialization['sectionName'] as String?,
      rollNumber: jsonSerialization['rollNumber'] as String?,
      admissionNumber: jsonSerialization['admissionNumber'] as String?,
      gender: jsonSerialization['gender'] as String?,
      dob: jsonSerialization['dob'] as String?,
      bloodGroup: jsonSerialization['bloodGroup'] as String?,
      aadharNumber: jsonSerialization['aadharNumber'] as String?,
      address: jsonSerialization['address'] as String?,
      city: jsonSerialization['city'] as String?,
      state: jsonSerialization['state'] as String?,
      country: jsonSerialization['country'] as String,
      pincode: jsonSerialization['pincode'] as String?,
      parentMobileNumber: jsonSerialization['parentMobileNumber'] as String?,
      parentEmail: jsonSerialization['parentEmail'] as String?,
      subjectTeaching: (jsonSerialization['subjectTeaching'] as List?)
          ?.map((e) => e as String)
          .toList(),
      classAndSectionTeaching:
          (jsonSerialization['classAndSectionTeaching'] as List?)
              ?.map((e) => e as String)
              .toList(),
      isPasswordCreated: jsonSerialization['isPasswordCreated'] as bool,
      isActive: jsonSerialization['isActive'] as bool,
      isPremiumUser: jsonSerialization['isPremiumUser'] as bool,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = UserTable();

  static const db = UserRepository._();

  @override
  int? id;

  String? uid;

  String? anantId;

  String? email;

  String? mobileNumber;

  _i2.UserRole role;

  String? fullName;

  String? profileImageUrl;

  String organizationName;

  String? className;

  String? sectionName;

  String? rollNumber;

  String? admissionNumber;

  String? gender;

  String? dob;

  String? bloodGroup;

  String? aadharNumber;

  String? address;

  String? city;

  String? state;

  String country;

  String? pincode;

  String? parentMobileNumber;

  String? parentEmail;

  List<String>? subjectTeaching;

  List<String>? classAndSectionTeaching;

  bool isPasswordCreated;

  bool isActive;

  bool isPremiumUser;

  DateTime? createdAt;

  DateTime? updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [User]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  User copyWith({
    int? id,
    String? uid,
    String? anantId,
    String? email,
    String? mobileNumber,
    _i2.UserRole? role,
    String? fullName,
    String? profileImageUrl,
    String? organizationName,
    String? className,
    String? sectionName,
    String? rollNumber,
    String? admissionNumber,
    String? gender,
    String? dob,
    String? bloodGroup,
    String? aadharNumber,
    String? address,
    String? city,
    String? state,
    String? country,
    String? pincode,
    String? parentMobileNumber,
    String? parentEmail,
    List<String>? subjectTeaching,
    List<String>? classAndSectionTeaching,
    bool? isPasswordCreated,
    bool? isActive,
    bool? isPremiumUser,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (uid != null) 'uid': uid,
      if (anantId != null) 'anantId': anantId,
      if (email != null) 'email': email,
      if (mobileNumber != null) 'mobileNumber': mobileNumber,
      'role': role.toJson(),
      if (fullName != null) 'fullName': fullName,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      'organizationName': organizationName,
      if (className != null) 'className': className,
      if (sectionName != null) 'sectionName': sectionName,
      if (rollNumber != null) 'rollNumber': rollNumber,
      if (admissionNumber != null) 'admissionNumber': admissionNumber,
      if (gender != null) 'gender': gender,
      if (dob != null) 'dob': dob,
      if (bloodGroup != null) 'bloodGroup': bloodGroup,
      if (aadharNumber != null) 'aadharNumber': aadharNumber,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      'country': country,
      if (pincode != null) 'pincode': pincode,
      if (parentMobileNumber != null) 'parentMobileNumber': parentMobileNumber,
      if (parentEmail != null) 'parentEmail': parentEmail,
      if (subjectTeaching != null) 'subjectTeaching': subjectTeaching?.toJson(),
      if (classAndSectionTeaching != null)
        'classAndSectionTeaching': classAndSectionTeaching?.toJson(),
      'isPasswordCreated': isPasswordCreated,
      'isActive': isActive,
      'isPremiumUser': isPremiumUser,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      if (uid != null) 'uid': uid,
      if (anantId != null) 'anantId': anantId,
      if (email != null) 'email': email,
      if (mobileNumber != null) 'mobileNumber': mobileNumber,
      'role': role.toJson(),
      if (fullName != null) 'fullName': fullName,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      'organizationName': organizationName,
      if (className != null) 'className': className,
      if (sectionName != null) 'sectionName': sectionName,
      if (rollNumber != null) 'rollNumber': rollNumber,
      if (admissionNumber != null) 'admissionNumber': admissionNumber,
      if (gender != null) 'gender': gender,
      if (dob != null) 'dob': dob,
      if (bloodGroup != null) 'bloodGroup': bloodGroup,
      if (aadharNumber != null) 'aadharNumber': aadharNumber,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      'country': country,
      if (pincode != null) 'pincode': pincode,
      if (parentMobileNumber != null) 'parentMobileNumber': parentMobileNumber,
      if (parentEmail != null) 'parentEmail': parentEmail,
      if (subjectTeaching != null) 'subjectTeaching': subjectTeaching?.toJson(),
      if (classAndSectionTeaching != null)
        'classAndSectionTeaching': classAndSectionTeaching?.toJson(),
      'isPasswordCreated': isPasswordCreated,
      'isActive': isActive,
      'isPremiumUser': isPremiumUser,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  static UserInclude include() {
    return UserInclude._();
  }

  static UserIncludeList includeList({
    _i1.WhereExpressionBuilder<UserTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserTable>? orderByList,
    UserInclude? include,
  }) {
    return UserIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(User.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(User.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserImpl extends User {
  _UserImpl({
    int? id,
    String? uid,
    String? anantId,
    String? email,
    String? mobileNumber,
    required _i2.UserRole role,
    String? fullName,
    String? profileImageUrl,
    required String organizationName,
    String? className,
    String? sectionName,
    String? rollNumber,
    String? admissionNumber,
    String? gender,
    String? dob,
    String? bloodGroup,
    String? aadharNumber,
    String? address,
    String? city,
    String? state,
    String? country,
    String? pincode,
    String? parentMobileNumber,
    String? parentEmail,
    List<String>? subjectTeaching,
    List<String>? classAndSectionTeaching,
    bool? isPasswordCreated,
    bool? isActive,
    bool? isPremiumUser,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
          id: id,
          uid: uid,
          anantId: anantId,
          email: email,
          mobileNumber: mobileNumber,
          role: role,
          fullName: fullName,
          profileImageUrl: profileImageUrl,
          organizationName: organizationName,
          className: className,
          sectionName: sectionName,
          rollNumber: rollNumber,
          admissionNumber: admissionNumber,
          gender: gender,
          dob: dob,
          bloodGroup: bloodGroup,
          aadharNumber: aadharNumber,
          address: address,
          city: city,
          state: state,
          country: country,
          pincode: pincode,
          parentMobileNumber: parentMobileNumber,
          parentEmail: parentEmail,
          subjectTeaching: subjectTeaching,
          classAndSectionTeaching: classAndSectionTeaching,
          isPasswordCreated: isPasswordCreated,
          isActive: isActive,
          isPremiumUser: isPremiumUser,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Returns a shallow copy of this [User]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  User copyWith({
    Object? id = _Undefined,
    Object? uid = _Undefined,
    Object? anantId = _Undefined,
    Object? email = _Undefined,
    Object? mobileNumber = _Undefined,
    _i2.UserRole? role,
    Object? fullName = _Undefined,
    Object? profileImageUrl = _Undefined,
    String? organizationName,
    Object? className = _Undefined,
    Object? sectionName = _Undefined,
    Object? rollNumber = _Undefined,
    Object? admissionNumber = _Undefined,
    Object? gender = _Undefined,
    Object? dob = _Undefined,
    Object? bloodGroup = _Undefined,
    Object? aadharNumber = _Undefined,
    Object? address = _Undefined,
    Object? city = _Undefined,
    Object? state = _Undefined,
    String? country,
    Object? pincode = _Undefined,
    Object? parentMobileNumber = _Undefined,
    Object? parentEmail = _Undefined,
    Object? subjectTeaching = _Undefined,
    Object? classAndSectionTeaching = _Undefined,
    bool? isPasswordCreated,
    bool? isActive,
    bool? isPremiumUser,
    Object? createdAt = _Undefined,
    Object? updatedAt = _Undefined,
  }) {
    return User(
      id: id is int? ? id : this.id,
      uid: uid is String? ? uid : this.uid,
      anantId: anantId is String? ? anantId : this.anantId,
      email: email is String? ? email : this.email,
      mobileNumber: mobileNumber is String? ? mobileNumber : this.mobileNumber,
      role: role ?? this.role,
      fullName: fullName is String? ? fullName : this.fullName,
      profileImageUrl:
          profileImageUrl is String? ? profileImageUrl : this.profileImageUrl,
      organizationName: organizationName ?? this.organizationName,
      className: className is String? ? className : this.className,
      sectionName: sectionName is String? ? sectionName : this.sectionName,
      rollNumber: rollNumber is String? ? rollNumber : this.rollNumber,
      admissionNumber:
          admissionNumber is String? ? admissionNumber : this.admissionNumber,
      gender: gender is String? ? gender : this.gender,
      dob: dob is String? ? dob : this.dob,
      bloodGroup: bloodGroup is String? ? bloodGroup : this.bloodGroup,
      aadharNumber: aadharNumber is String? ? aadharNumber : this.aadharNumber,
      address: address is String? ? address : this.address,
      city: city is String? ? city : this.city,
      state: state is String? ? state : this.state,
      country: country ?? this.country,
      pincode: pincode is String? ? pincode : this.pincode,
      parentMobileNumber: parentMobileNumber is String?
          ? parentMobileNumber
          : this.parentMobileNumber,
      parentEmail: parentEmail is String? ? parentEmail : this.parentEmail,
      subjectTeaching: subjectTeaching is List<String>?
          ? subjectTeaching
          : this.subjectTeaching?.map((e0) => e0).toList(),
      classAndSectionTeaching: classAndSectionTeaching is List<String>?
          ? classAndSectionTeaching
          : this.classAndSectionTeaching?.map((e0) => e0).toList(),
      isPasswordCreated: isPasswordCreated ?? this.isPasswordCreated,
      isActive: isActive ?? this.isActive,
      isPremiumUser: isPremiumUser ?? this.isPremiumUser,
      createdAt: createdAt is DateTime? ? createdAt : this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}

class UserTable extends _i1.Table<int?> {
  UserTable({super.tableRelation}) : super(tableName: 'user') {
    uid = _i1.ColumnString(
      'uid',
      this,
    );
    anantId = _i1.ColumnString(
      'anantId',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    mobileNumber = _i1.ColumnString(
      'mobileNumber',
      this,
    );
    role = _i1.ColumnEnum(
      'role',
      this,
      _i1.EnumSerialization.byName,
    );
    fullName = _i1.ColumnString(
      'fullName',
      this,
    );
    profileImageUrl = _i1.ColumnString(
      'profileImageUrl',
      this,
    );
    organizationName = _i1.ColumnString(
      'organizationName',
      this,
    );
    className = _i1.ColumnString(
      'className',
      this,
    );
    sectionName = _i1.ColumnString(
      'sectionName',
      this,
    );
    rollNumber = _i1.ColumnString(
      'rollNumber',
      this,
    );
    admissionNumber = _i1.ColumnString(
      'admissionNumber',
      this,
    );
    gender = _i1.ColumnString(
      'gender',
      this,
    );
    dob = _i1.ColumnString(
      'dob',
      this,
    );
    bloodGroup = _i1.ColumnString(
      'bloodGroup',
      this,
    );
    aadharNumber = _i1.ColumnString(
      'aadharNumber',
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
    parentMobileNumber = _i1.ColumnString(
      'parentMobileNumber',
      this,
    );
    parentEmail = _i1.ColumnString(
      'parentEmail',
      this,
    );
    subjectTeaching = _i1.ColumnSerializable(
      'subjectTeaching',
      this,
    );
    classAndSectionTeaching = _i1.ColumnSerializable(
      'classAndSectionTeaching',
      this,
    );
    isPasswordCreated = _i1.ColumnBool(
      'isPasswordCreated',
      this,
      hasDefault: true,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
      hasDefault: true,
    );
    isPremiumUser = _i1.ColumnBool(
      'isPremiumUser',
      this,
      hasDefault: true,
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

  late final _i1.ColumnString anantId;

  late final _i1.ColumnString email;

  late final _i1.ColumnString mobileNumber;

  late final _i1.ColumnEnum<_i2.UserRole> role;

  late final _i1.ColumnString fullName;

  late final _i1.ColumnString profileImageUrl;

  late final _i1.ColumnString organizationName;

  late final _i1.ColumnString className;

  late final _i1.ColumnString sectionName;

  late final _i1.ColumnString rollNumber;

  late final _i1.ColumnString admissionNumber;

  late final _i1.ColumnString gender;

  late final _i1.ColumnString dob;

  late final _i1.ColumnString bloodGroup;

  late final _i1.ColumnString aadharNumber;

  late final _i1.ColumnString address;

  late final _i1.ColumnString city;

  late final _i1.ColumnString state;

  late final _i1.ColumnString country;

  late final _i1.ColumnString pincode;

  late final _i1.ColumnString parentMobileNumber;

  late final _i1.ColumnString parentEmail;

  late final _i1.ColumnSerializable subjectTeaching;

  late final _i1.ColumnSerializable classAndSectionTeaching;

  late final _i1.ColumnBool isPasswordCreated;

  late final _i1.ColumnBool isActive;

  late final _i1.ColumnBool isPremiumUser;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
        id,
        uid,
        anantId,
        email,
        mobileNumber,
        role,
        fullName,
        profileImageUrl,
        organizationName,
        className,
        sectionName,
        rollNumber,
        admissionNumber,
        gender,
        dob,
        bloodGroup,
        aadharNumber,
        address,
        city,
        state,
        country,
        pincode,
        parentMobileNumber,
        parentEmail,
        subjectTeaching,
        classAndSectionTeaching,
        isPasswordCreated,
        isActive,
        isPremiumUser,
        createdAt,
        updatedAt,
      ];
}

class UserInclude extends _i1.IncludeObject {
  UserInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => User.t;
}

class UserIncludeList extends _i1.IncludeList {
  UserIncludeList._({
    _i1.WhereExpressionBuilder<UserTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(User.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => User.t;
}

class UserRepository {
  const UserRepository._();

  /// Returns a list of [User]s matching the given query parameters.
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
  Future<List<User>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<User>(
      where: where?.call(User.t),
      orderBy: orderBy?.call(User.t),
      orderByList: orderByList?.call(User.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [User] matching the given query parameters.
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
  Future<User?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<User>(
      where: where?.call(User.t),
      orderBy: orderBy?.call(User.t),
      orderByList: orderByList?.call(User.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [User] by its [id] or null if no such row exists.
  Future<User?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<User>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [User]s in the list and returns the inserted rows.
  ///
  /// The returned [User]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<User>> insert(
    _i1.Session session,
    List<User> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<User>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [User] and returns the inserted row.
  ///
  /// The returned [User] will have its `id` field set.
  Future<User> insertRow(
    _i1.Session session,
    User row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<User>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [User]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<User>> update(
    _i1.Session session,
    List<User> rows, {
    _i1.ColumnSelections<UserTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<User>(
      rows,
      columns: columns?.call(User.t),
      transaction: transaction,
    );
  }

  /// Updates a single [User]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<User> updateRow(
    _i1.Session session,
    User row, {
    _i1.ColumnSelections<UserTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<User>(
      row,
      columns: columns?.call(User.t),
      transaction: transaction,
    );
  }

  /// Deletes all [User]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<User>> delete(
    _i1.Session session,
    List<User> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<User>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [User].
  Future<User> deleteRow(
    _i1.Session session,
    User row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<User>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<User>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<User>(
      where: where(User.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<User>(
      where: where?.call(User.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
