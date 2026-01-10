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

/// Class
abstract class Classes implements _i1.SerializableModel {
  Classes._({
    this.id,
    this.organizationId,
    required this.name,
    required this.academicYear,
    this.courseName,
    this.classTeacherAnantId,
    this.startDate,
    this.endDate,
    bool? isActive,
  }) : isActive = isActive ?? true;

  factory Classes({
    int? id,
    int? organizationId,
    required String name,
    required String academicYear,
    String? courseName,
    String? classTeacherAnantId,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
  }) = _ClassesImpl;

  factory Classes.fromJson(Map<String, dynamic> jsonSerialization) {
    return Classes(
      id: jsonSerialization['id'] as int?,
      organizationId: jsonSerialization['organizationId'] as int?,
      name: jsonSerialization['name'] as String,
      academicYear: jsonSerialization['academicYear'] as String,
      courseName: jsonSerialization['courseName'] as String?,
      classTeacherAnantId: jsonSerialization['classTeacherAnantId'] as String?,
      startDate: jsonSerialization['startDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['startDate']),
      endDate: jsonSerialization['endDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      isActive: jsonSerialization['isActive'] as bool?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int? organizationId;

  String name;

  String academicYear;

  String? courseName;

  String? classTeacherAnantId;

  DateTime? startDate;

  DateTime? endDate;

  bool isActive;

  /// Returns a shallow copy of this [Classes]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Classes copyWith({
    int? id,
    int? organizationId,
    String? name,
    String? academicYear,
    String? courseName,
    String? classTeacherAnantId,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Classes',
      if (id != null) 'id': id,
      if (organizationId != null) 'organizationId': organizationId,
      'name': name,
      'academicYear': academicYear,
      if (courseName != null) 'courseName': courseName,
      if (classTeacherAnantId != null)
        'classTeacherAnantId': classTeacherAnantId,
      if (startDate != null) 'startDate': startDate?.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ClassesImpl extends Classes {
  _ClassesImpl({
    int? id,
    int? organizationId,
    required String name,
    required String academicYear,
    String? courseName,
    String? classTeacherAnantId,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
  }) : super._(
         id: id,
         organizationId: organizationId,
         name: name,
         academicYear: academicYear,
         courseName: courseName,
         classTeacherAnantId: classTeacherAnantId,
         startDate: startDate,
         endDate: endDate,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [Classes]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Classes copyWith({
    Object? id = _Undefined,
    Object? organizationId = _Undefined,
    String? name,
    String? academicYear,
    Object? courseName = _Undefined,
    Object? classTeacherAnantId = _Undefined,
    Object? startDate = _Undefined,
    Object? endDate = _Undefined,
    bool? isActive,
  }) {
    return Classes(
      id: id is int? ? id : this.id,
      organizationId: organizationId is int?
          ? organizationId
          : this.organizationId,
      name: name ?? this.name,
      academicYear: academicYear ?? this.academicYear,
      courseName: courseName is String? ? courseName : this.courseName,
      classTeacherAnantId: classTeacherAnantId is String?
          ? classTeacherAnantId
          : this.classTeacherAnantId,
      startDate: startDate is DateTime? ? startDate : this.startDate,
      endDate: endDate is DateTime? ? endDate : this.endDate,
      isActive: isActive ?? this.isActive,
    );
  }
}
