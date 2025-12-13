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

/// StudentCourseEnrollment
abstract class StudentCourseEnrollment implements _i1.SerializableModel {
  StudentCourseEnrollment._({
    this.id,
    required this.studentAnantId,
    required this.courseName,
    this.organizationId,
    required this.enrolledOn,
  });

  factory StudentCourseEnrollment({
    int? id,
    required String studentAnantId,
    required String courseName,
    int? organizationId,
    required DateTime enrolledOn,
  }) = _StudentCourseEnrollmentImpl;

  factory StudentCourseEnrollment.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return StudentCourseEnrollment(
      id: jsonSerialization['id'] as int?,
      studentAnantId: jsonSerialization['studentAnantId'] as String,
      courseName: jsonSerialization['courseName'] as String,
      organizationId: jsonSerialization['organizationId'] as int?,
      enrolledOn:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['enrolledOn']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String studentAnantId;

  String courseName;

  int? organizationId;

  DateTime enrolledOn;

  /// Returns a shallow copy of this [StudentCourseEnrollment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  StudentCourseEnrollment copyWith({
    int? id,
    String? studentAnantId,
    String? courseName,
    int? organizationId,
    DateTime? enrolledOn,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'studentAnantId': studentAnantId,
      'courseName': courseName,
      if (organizationId != null) 'organizationId': organizationId,
      'enrolledOn': enrolledOn.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StudentCourseEnrollmentImpl extends StudentCourseEnrollment {
  _StudentCourseEnrollmentImpl({
    int? id,
    required String studentAnantId,
    required String courseName,
    int? organizationId,
    required DateTime enrolledOn,
  }) : super._(
          id: id,
          studentAnantId: studentAnantId,
          courseName: courseName,
          organizationId: organizationId,
          enrolledOn: enrolledOn,
        );

  /// Returns a shallow copy of this [StudentCourseEnrollment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  StudentCourseEnrollment copyWith({
    Object? id = _Undefined,
    String? studentAnantId,
    String? courseName,
    Object? organizationId = _Undefined,
    DateTime? enrolledOn,
  }) {
    return StudentCourseEnrollment(
      id: id is int? ? id : this.id,
      studentAnantId: studentAnantId ?? this.studentAnantId,
      courseName: courseName ?? this.courseName,
      organizationId:
          organizationId is int? ? organizationId : this.organizationId,
      enrolledOn: enrolledOn ?? this.enrolledOn,
    );
  }
}
