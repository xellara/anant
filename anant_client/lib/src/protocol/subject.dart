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

abstract class Subject implements _i1.SerializableModel {
  Subject._({
    this.id,
    required this.organizationId,
    required this.name,
    this.description,
  });

  factory Subject({
    int? id,
    required int organizationId,
    required String name,
    String? description,
  }) = _SubjectImpl;

  factory Subject.fromJson(Map<String, dynamic> jsonSerialization) {
    return Subject(
      id: jsonSerialization['id'] as int?,
      organizationId: jsonSerialization['organizationId'] as int,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int organizationId;

  String name;

  String? description;

  /// Returns a shallow copy of this [Subject]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Subject copyWith({
    int? id,
    int? organizationId,
    String? name,
    String? description,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'organizationId': organizationId,
      'name': name,
      if (description != null) 'description': description,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SubjectImpl extends Subject {
  _SubjectImpl({
    int? id,
    required int organizationId,
    required String name,
    String? description,
  }) : super._(
          id: id,
          organizationId: organizationId,
          name: name,
          description: description,
        );

  /// Returns a shallow copy of this [Subject]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Subject copyWith({
    Object? id = _Undefined,
    int? organizationId,
    String? name,
    Object? description = _Undefined,
  }) {
    return Subject(
      id: id is int? ? id : this.id,
      organizationId: organizationId ?? this.organizationId,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
    );
  }
}
