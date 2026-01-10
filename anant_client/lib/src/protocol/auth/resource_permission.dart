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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../auth/role.dart' as _i2;
import '../auth/permission.dart' as _i3;
import 'package:anant_client/src/protocol/protocol.dart' as _i4;

/// Resource-based access control for fine-grained permissions
abstract class ResourcePermission implements _i1.SerializableModel {
  ResourcePermission._({
    this.id,
    required this.roleId,
    this.role,
    required this.permissionId,
    this.permission,
    required this.resourceType,
    required this.resourceId,
    this.organizationName,
    this.conditions,
    DateTime? createdAt,
    this.createdById,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ResourcePermission({
    int? id,
    required int roleId,
    _i2.Role? role,
    required int permissionId,
    _i3.Permission? permission,
    required String resourceType,
    required String resourceId,
    String? organizationName,
    String? conditions,
    DateTime? createdAt,
    int? createdById,
  }) = _ResourcePermissionImpl;

  factory ResourcePermission.fromJson(Map<String, dynamic> jsonSerialization) {
    return ResourcePermission(
      id: jsonSerialization['id'] as int?,
      roleId: jsonSerialization['roleId'] as int,
      role: jsonSerialization['role'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.Role>(jsonSerialization['role']),
      permissionId: jsonSerialization['permissionId'] as int,
      permission: jsonSerialization['permission'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.Permission>(
              jsonSerialization['permission'],
            ),
      resourceType: jsonSerialization['resourceType'] as String,
      resourceId: jsonSerialization['resourceId'] as String,
      organizationName: jsonSerialization['organizationName'] as String?,
      conditions: jsonSerialization['conditions'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      createdById: jsonSerialization['createdById'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int roleId;

  _i2.Role? role;

  int permissionId;

  _i3.Permission? permission;

  String resourceType;

  String resourceId;

  String? organizationName;

  String? conditions;

  DateTime createdAt;

  int? createdById;

  /// Returns a shallow copy of this [ResourcePermission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ResourcePermission copyWith({
    int? id,
    int? roleId,
    _i2.Role? role,
    int? permissionId,
    _i3.Permission? permission,
    String? resourceType,
    String? resourceId,
    String? organizationName,
    String? conditions,
    DateTime? createdAt,
    int? createdById,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ResourcePermission',
      if (id != null) 'id': id,
      'roleId': roleId,
      if (role != null) 'role': role?.toJson(),
      'permissionId': permissionId,
      if (permission != null) 'permission': permission?.toJson(),
      'resourceType': resourceType,
      'resourceId': resourceId,
      if (organizationName != null) 'organizationName': organizationName,
      if (conditions != null) 'conditions': conditions,
      'createdAt': createdAt.toJson(),
      if (createdById != null) 'createdById': createdById,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ResourcePermissionImpl extends ResourcePermission {
  _ResourcePermissionImpl({
    int? id,
    required int roleId,
    _i2.Role? role,
    required int permissionId,
    _i3.Permission? permission,
    required String resourceType,
    required String resourceId,
    String? organizationName,
    String? conditions,
    DateTime? createdAt,
    int? createdById,
  }) : super._(
         id: id,
         roleId: roleId,
         role: role,
         permissionId: permissionId,
         permission: permission,
         resourceType: resourceType,
         resourceId: resourceId,
         organizationName: organizationName,
         conditions: conditions,
         createdAt: createdAt,
         createdById: createdById,
       );

  /// Returns a shallow copy of this [ResourcePermission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ResourcePermission copyWith({
    Object? id = _Undefined,
    int? roleId,
    Object? role = _Undefined,
    int? permissionId,
    Object? permission = _Undefined,
    String? resourceType,
    String? resourceId,
    Object? organizationName = _Undefined,
    Object? conditions = _Undefined,
    DateTime? createdAt,
    Object? createdById = _Undefined,
  }) {
    return ResourcePermission(
      id: id is int? ? id : this.id,
      roleId: roleId ?? this.roleId,
      role: role is _i2.Role? ? role : this.role?.copyWith(),
      permissionId: permissionId ?? this.permissionId,
      permission: permission is _i3.Permission?
          ? permission
          : this.permission?.copyWith(),
      resourceType: resourceType ?? this.resourceType,
      resourceId: resourceId ?? this.resourceId,
      organizationName: organizationName is String?
          ? organizationName
          : this.organizationName,
      conditions: conditions is String? ? conditions : this.conditions,
      createdAt: createdAt ?? this.createdAt,
      createdById: createdById is int? ? createdById : this.createdById,
    );
  }
}
