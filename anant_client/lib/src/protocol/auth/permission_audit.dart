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
import '../user/user.dart' as _i2;

/// Audit log for permission checks and usage
abstract class PermissionAudit implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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
