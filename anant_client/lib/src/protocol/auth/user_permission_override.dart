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
import '../auth/permission.dart' as _i3;

abstract class UserPermissionOverride implements _i1.SerializableModel {
  UserPermissionOverride._({
    this.id,
    required this.userId,
    this.user,
    required this.permissionId,
    this.permission,
    required this.isGranted,
  });

  factory UserPermissionOverride({
    int? id,
    required int userId,
    _i2.User? user,
    required int permissionId,
    _i3.Permission? permission,
    required bool isGranted,
  }) = _UserPermissionOverrideImpl;

  factory UserPermissionOverride.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return UserPermissionOverride(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      user: jsonSerialization['user'] == null
          ? null
          : _i2.User.fromJson(
              (jsonSerialization['user'] as Map<String, dynamic>)),
      permissionId: jsonSerialization['permissionId'] as int,
      permission: jsonSerialization['permission'] == null
          ? null
          : _i3.Permission.fromJson(
              (jsonSerialization['permission'] as Map<String, dynamic>)),
      isGranted: jsonSerialization['isGranted'] as bool,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  _i2.User? user;

  int permissionId;

  _i3.Permission? permission;

  bool isGranted;

  /// Returns a shallow copy of this [UserPermissionOverride]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserPermissionOverride copyWith({
    int? id,
    int? userId,
    _i2.User? user,
    int? permissionId,
    _i3.Permission? permission,
    bool? isGranted,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      if (user != null) 'user': user?.toJson(),
      'permissionId': permissionId,
      if (permission != null) 'permission': permission?.toJson(),
      'isGranted': isGranted,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserPermissionOverrideImpl extends UserPermissionOverride {
  _UserPermissionOverrideImpl({
    int? id,
    required int userId,
    _i2.User? user,
    required int permissionId,
    _i3.Permission? permission,
    required bool isGranted,
  }) : super._(
          id: id,
          userId: userId,
          user: user,
          permissionId: permissionId,
          permission: permission,
          isGranted: isGranted,
        );

  /// Returns a shallow copy of this [UserPermissionOverride]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserPermissionOverride copyWith({
    Object? id = _Undefined,
    int? userId,
    Object? user = _Undefined,
    int? permissionId,
    Object? permission = _Undefined,
    bool? isGranted,
  }) {
    return UserPermissionOverride(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i2.User? ? user : this.user?.copyWith(),
      permissionId: permissionId ?? this.permissionId,
      permission: permission is _i3.Permission?
          ? permission
          : this.permission?.copyWith(),
      isGranted: isGranted ?? this.isGranted,
    );
  }
}
