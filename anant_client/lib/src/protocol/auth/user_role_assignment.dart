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
import '../auth/role.dart' as _i3;

/// User-Role assignment table for multi-role support
abstract class UserRoleAssignment implements _i1.SerializableModel {
  UserRoleAssignment._({
    this.id,
    required this.userId,
    this.user,
    required this.roleId,
    this.role,
    DateTime? assignedAt,
    this.assignedById,
    bool? isActive,
    this.validFrom,
    this.validUntil,
  })  : assignedAt = assignedAt ?? DateTime.now(),
        isActive = isActive ?? true;

  factory UserRoleAssignment({
    int? id,
    required int userId,
    _i2.User? user,
    required int roleId,
    _i3.Role? role,
    DateTime? assignedAt,
    int? assignedById,
    bool? isActive,
    DateTime? validFrom,
    DateTime? validUntil,
  }) = _UserRoleAssignmentImpl;

  factory UserRoleAssignment.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserRoleAssignment(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      user: jsonSerialization['user'] == null
          ? null
          : _i2.User.fromJson(
              (jsonSerialization['user'] as Map<String, dynamic>)),
      roleId: jsonSerialization['roleId'] as int,
      role: jsonSerialization['role'] == null
          ? null
          : _i3.Role.fromJson(
              (jsonSerialization['role'] as Map<String, dynamic>)),
      assignedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['assignedAt']),
      assignedById: jsonSerialization['assignedById'] as int?,
      isActive: jsonSerialization['isActive'] as bool,
      validFrom: jsonSerialization['validFrom'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['validFrom']),
      validUntil: jsonSerialization['validUntil'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['validUntil']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  _i2.User? user;

  int roleId;

  _i3.Role? role;

  DateTime assignedAt;

  int? assignedById;

  bool isActive;

  DateTime? validFrom;

  DateTime? validUntil;

  /// Returns a shallow copy of this [UserRoleAssignment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserRoleAssignment copyWith({
    int? id,
    int? userId,
    _i2.User? user,
    int? roleId,
    _i3.Role? role,
    DateTime? assignedAt,
    int? assignedById,
    bool? isActive,
    DateTime? validFrom,
    DateTime? validUntil,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      if (user != null) 'user': user?.toJson(),
      'roleId': roleId,
      if (role != null) 'role': role?.toJson(),
      'assignedAt': assignedAt.toJson(),
      if (assignedById != null) 'assignedById': assignedById,
      'isActive': isActive,
      if (validFrom != null) 'validFrom': validFrom?.toJson(),
      if (validUntil != null) 'validUntil': validUntil?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserRoleAssignmentImpl extends UserRoleAssignment {
  _UserRoleAssignmentImpl({
    int? id,
    required int userId,
    _i2.User? user,
    required int roleId,
    _i3.Role? role,
    DateTime? assignedAt,
    int? assignedById,
    bool? isActive,
    DateTime? validFrom,
    DateTime? validUntil,
  }) : super._(
          id: id,
          userId: userId,
          user: user,
          roleId: roleId,
          role: role,
          assignedAt: assignedAt,
          assignedById: assignedById,
          isActive: isActive,
          validFrom: validFrom,
          validUntil: validUntil,
        );

  /// Returns a shallow copy of this [UserRoleAssignment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserRoleAssignment copyWith({
    Object? id = _Undefined,
    int? userId,
    Object? user = _Undefined,
    int? roleId,
    Object? role = _Undefined,
    DateTime? assignedAt,
    Object? assignedById = _Undefined,
    bool? isActive,
    Object? validFrom = _Undefined,
    Object? validUntil = _Undefined,
  }) {
    return UserRoleAssignment(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i2.User? ? user : this.user?.copyWith(),
      roleId: roleId ?? this.roleId,
      role: role is _i3.Role? ? role : this.role?.copyWith(),
      assignedAt: assignedAt ?? this.assignedAt,
      assignedById: assignedById is int? ? assignedById : this.assignedById,
      isActive: isActive ?? this.isActive,
      validFrom: validFrom is DateTime? ? validFrom : this.validFrom,
      validUntil: validUntil is DateTime? ? validUntil : this.validUntil,
    );
  }
}
