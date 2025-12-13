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

/// Course
abstract class Course implements _i1.SerializableModel {
  Course._({
    this.id,
    this.organizationId,
    this.department,
    required this.name,
    this.code,
    this.description,
    this.semester,
    this.academicYear,
    this.credits,
    bool? isElective,
    bool? isActive,
  })  : isElective = isElective ?? false,
        isActive = isActive ?? true;

  factory Course({
    int? id,
    int? organizationId,
    String? department,
    required String name,
    String? code,
    String? description,
    int? semester,
    String? academicYear,
    int? credits,
    bool? isElective,
    bool? isActive,
  }) = _CourseImpl;

  factory Course.fromJson(Map<String, dynamic> jsonSerialization) {
    return Course(
      id: jsonSerialization['id'] as int?,
      organizationId: jsonSerialization['organizationId'] as int?,
      department: jsonSerialization['department'] as String?,
      name: jsonSerialization['name'] as String,
      code: jsonSerialization['code'] as String?,
      description: jsonSerialization['description'] as String?,
      semester: jsonSerialization['semester'] as int?,
      academicYear: jsonSerialization['academicYear'] as String?,
      credits: jsonSerialization['credits'] as int?,
      isElective: jsonSerialization['isElective'] as bool,
      isActive: jsonSerialization['isActive'] as bool,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int? organizationId;

  String? department;

  String name;

  String? code;

  String? description;

  int? semester;

  String? academicYear;

  int? credits;

  bool isElective;

  bool isActive;

  /// Returns a shallow copy of this [Course]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Course copyWith({
    int? id,
    int? organizationId,
    String? department,
    String? name,
    String? code,
    String? description,
    int? semester,
    String? academicYear,
    int? credits,
    bool? isElective,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (organizationId != null) 'organizationId': organizationId,
      if (department != null) 'department': department,
      'name': name,
      if (code != null) 'code': code,
      if (description != null) 'description': description,
      if (semester != null) 'semester': semester,
      if (academicYear != null) 'academicYear': academicYear,
      if (credits != null) 'credits': credits,
      'isElective': isElective,
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CourseImpl extends Course {
  _CourseImpl({
    int? id,
    int? organizationId,
    String? department,
    required String name,
    String? code,
    String? description,
    int? semester,
    String? academicYear,
    int? credits,
    bool? isElective,
    bool? isActive,
  }) : super._(
          id: id,
          organizationId: organizationId,
          department: department,
          name: name,
          code: code,
          description: description,
          semester: semester,
          academicYear: academicYear,
          credits: credits,
          isElective: isElective,
          isActive: isActive,
        );

  /// Returns a shallow copy of this [Course]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Course copyWith({
    Object? id = _Undefined,
    Object? organizationId = _Undefined,
    Object? department = _Undefined,
    String? name,
    Object? code = _Undefined,
    Object? description = _Undefined,
    Object? semester = _Undefined,
    Object? academicYear = _Undefined,
    Object? credits = _Undefined,
    bool? isElective,
    bool? isActive,
  }) {
    return Course(
      id: id is int? ? id : this.id,
      organizationId:
          organizationId is int? ? organizationId : this.organizationId,
      department: department is String? ? department : this.department,
      name: name ?? this.name,
      code: code is String? ? code : this.code,
      description: description is String? ? description : this.description,
      semester: semester is int? ? semester : this.semester,
      academicYear: academicYear is String? ? academicYear : this.academicYear,
      credits: credits is int? ? credits : this.credits,
      isElective: isElective ?? this.isElective,
      isActive: isActive ?? this.isActive,
    );
  }
}
