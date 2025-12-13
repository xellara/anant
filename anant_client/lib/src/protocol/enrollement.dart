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

/// Enrollment (many-to-many: students enrolled in classes)
abstract class Enrollment implements _i1.SerializableModel {
  Enrollment._({
    this.id,
    required this.organizationId,
    required this.classId,
    required this.studentId,
  });

  factory Enrollment({
    int? id,
    required int organizationId,
    required int classId,
    required int studentId,
  }) = _EnrollmentImpl;

  factory Enrollment.fromJson(Map<String, dynamic> jsonSerialization) {
    return Enrollment(
      id: jsonSerialization['id'] as int?,
      organizationId: jsonSerialization['organizationId'] as int,
      classId: jsonSerialization['classId'] as int,
      studentId: jsonSerialization['studentId'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int organizationId;

  int classId;

  int studentId;

  /// Returns a shallow copy of this [Enrollment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Enrollment copyWith({
    int? id,
    int? organizationId,
    int? classId,
    int? studentId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'organizationId': organizationId,
      'classId': classId,
      'studentId': studentId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EnrollmentImpl extends Enrollment {
  _EnrollmentImpl({
    int? id,
    required int organizationId,
    required int classId,
    required int studentId,
  }) : super._(
          id: id,
          organizationId: organizationId,
          classId: classId,
          studentId: studentId,
        );

  /// Returns a shallow copy of this [Enrollment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Enrollment copyWith({
    Object? id = _Undefined,
    int? organizationId,
    int? classId,
    int? studentId,
  }) {
    return Enrollment(
      id: id is int? ? id : this.id,
      organizationId: organizationId ?? this.organizationId,
      classId: classId ?? this.classId,
      studentId: studentId ?? this.studentId,
    );
  }
}
