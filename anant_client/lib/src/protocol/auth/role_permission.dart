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
import '../auth/role.dart' as _i2;
import '../auth/permission.dart' as _i3;

abstract class RolePermission implements _i1.SerializableModel {
  RolePermission._({
    this.id,
    required this.roleId,
    this.role,
    required this.permissionId,
    this.permission,
  });

  factory RolePermission({
    int? id,
    required int roleId,
    _i2.Role? role,
    required int permissionId,
    _i3.Permission? permission,
  }) = _RolePermissionImpl;

  factory RolePermission.fromJson(Map<String, dynamic> jsonSerialization) {
    return RolePermission(
      id: jsonSerialization['id'] as int?,
      roleId: jsonSerialization['roleId'] as int,
      role: jsonSerialization['role'] == null
          ? null
          : _i2.Role.fromJson(
              (jsonSerialization['role'] as Map<String, dynamic>)),
      permissionId: jsonSerialization['permissionId'] as int,
      permission: jsonSerialization['permission'] == null
          ? null
          : _i3.Permission.fromJson(
              (jsonSerialization['permission'] as Map<String, dynamic>)),
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

  /// Returns a shallow copy of this [RolePermission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RolePermission copyWith({
    int? id,
    int? roleId,
    _i2.Role? role,
    int? permissionId,
    _i3.Permission? permission,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'roleId': roleId,
      if (role != null) 'role': role?.toJson(),
      'permissionId': permissionId,
      if (permission != null) 'permission': permission?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RolePermissionImpl extends RolePermission {
  _RolePermissionImpl({
    int? id,
    required int roleId,
    _i2.Role? role,
    required int permissionId,
    _i3.Permission? permission,
  }) : super._(
          id: id,
          roleId: roleId,
          role: role,
          permissionId: permissionId,
          permission: permission,
        );

  /// Returns a shallow copy of this [RolePermission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RolePermission copyWith({
    Object? id = _Undefined,
    int? roleId,
    Object? role = _Undefined,
    int? permissionId,
    Object? permission = _Undefined,
  }) {
    return RolePermission(
      id: id is int? ? id : this.id,
      roleId: roleId ?? this.roleId,
      role: role is _i2.Role? ? role : this.role?.copyWith(),
      permissionId: permissionId ?? this.permissionId,
      permission: permission is _i3.Permission?
          ? permission
          : this.permission?.copyWith(),
    );
  }
}
