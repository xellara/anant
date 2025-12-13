/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../user/user_role.dart' as _i2;

/// User
abstract class User implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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
