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

abstract class Role implements _i1.SerializableModel {
  Role._({
    this.id,
    required this.name,
    required this.slug,
    this.description,
    this.organizationName,
    bool? isSystemRole,
  }) : isSystemRole = isSystemRole ?? false;

  factory Role({
    int? id,
    required String name,
    required String slug,
    String? description,
    String? organizationName,
    bool? isSystemRole,
  }) = _RoleImpl;

  factory Role.fromJson(Map<String, dynamic> jsonSerialization) {
    return Role(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      slug: jsonSerialization['slug'] as String,
      description: jsonSerialization['description'] as String?,
      organizationName: jsonSerialization['organizationName'] as String?,
      isSystemRole: jsonSerialization['isSystemRole'] as bool?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String slug;

  String? description;

  String? organizationName;

  bool isSystemRole;

  /// Returns a shallow copy of this [Role]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Role copyWith({
    int? id,
    String? name,
    String? slug,
    String? description,
    String? organizationName,
    bool? isSystemRole,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Role',
      if (id != null) 'id': id,
      'name': name,
      'slug': slug,
      if (description != null) 'description': description,
      if (organizationName != null) 'organizationName': organizationName,
      'isSystemRole': isSystemRole,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RoleImpl extends Role {
  _RoleImpl({
    int? id,
    required String name,
    required String slug,
    String? description,
    String? organizationName,
    bool? isSystemRole,
  }) : super._(
         id: id,
         name: name,
         slug: slug,
         description: description,
         organizationName: organizationName,
         isSystemRole: isSystemRole,
       );

  /// Returns a shallow copy of this [Role]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Role copyWith({
    Object? id = _Undefined,
    String? name,
    String? slug,
    Object? description = _Undefined,
    Object? organizationName = _Undefined,
    bool? isSystemRole,
  }) {
    return Role(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description is String? ? description : this.description,
      organizationName: organizationName is String?
          ? organizationName
          : this.organizationName,
      isSystemRole: isSystemRole ?? this.isSystemRole,
    );
  }
}
