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

/// Organization
abstract class Organization implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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
