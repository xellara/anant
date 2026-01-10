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

/// Section
abstract class Section implements _i1.SerializableModel {
  Section._({
    this.id,
    this.organizationId,
    required this.className,
    required this.name,
    this.sectionTeacherAnantId,
    bool? isActive,
  }) : isActive = isActive ?? true;

  factory Section({
    int? id,
    int? organizationId,
    required String className,
    required String name,
    String? sectionTeacherAnantId,
    bool? isActive,
  }) = _SectionImpl;

  factory Section.fromJson(Map<String, dynamic> jsonSerialization) {
    return Section(
      id: jsonSerialization['id'] as int?,
      organizationId: jsonSerialization['organizationId'] as int?,
      className: jsonSerialization['className'] as String,
      name: jsonSerialization['name'] as String,
      sectionTeacherAnantId:
          jsonSerialization['sectionTeacherAnantId'] as String?,
      isActive: jsonSerialization['isActive'] as bool?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int? organizationId;

  String className;

  String name;

  String? sectionTeacherAnantId;

  bool isActive;

  /// Returns a shallow copy of this [Section]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Section copyWith({
    int? id,
    int? organizationId,
    String? className,
    String? name,
    String? sectionTeacherAnantId,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Section',
      if (id != null) 'id': id,
      if (organizationId != null) 'organizationId': organizationId,
      'className': className,
      'name': name,
      if (sectionTeacherAnantId != null)
        'sectionTeacherAnantId': sectionTeacherAnantId,
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SectionImpl extends Section {
  _SectionImpl({
    int? id,
    int? organizationId,
    required String className,
    required String name,
    String? sectionTeacherAnantId,
    bool? isActive,
  }) : super._(
         id: id,
         organizationId: organizationId,
         className: className,
         name: name,
         sectionTeacherAnantId: sectionTeacherAnantId,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [Section]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Section copyWith({
    Object? id = _Undefined,
    Object? organizationId = _Undefined,
    String? className,
    String? name,
    Object? sectionTeacherAnantId = _Undefined,
    bool? isActive,
  }) {
    return Section(
      id: id is int? ? id : this.id,
      organizationId: organizationId is int?
          ? organizationId
          : this.organizationId,
      className: className ?? this.className,
      name: name ?? this.name,
      sectionTeacherAnantId: sectionTeacherAnantId is String?
          ? sectionTeacherAnantId
          : this.sectionTeacherAnantId,
      isActive: isActive ?? this.isActive,
    );
  }
}
