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

/// Exam or test event
abstract class Exam implements _i1.SerializableModel {
  Exam._({
    this.id,
    required this.organizationId,
    required this.classId,
    required this.subjectId,
    required this.name,
    required this.date,
    required this.totalMarks,
  });

  factory Exam({
    int? id,
    required int organizationId,
    required int classId,
    required int subjectId,
    required String name,
    required DateTime date,
    required int totalMarks,
  }) = _ExamImpl;

  factory Exam.fromJson(Map<String, dynamic> jsonSerialization) {
    return Exam(
      id: jsonSerialization['id'] as int?,
      organizationId: jsonSerialization['organizationId'] as int,
      classId: jsonSerialization['classId'] as int,
      subjectId: jsonSerialization['subjectId'] as int,
      name: jsonSerialization['name'] as String,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      totalMarks: jsonSerialization['totalMarks'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int organizationId;

  int classId;

  int subjectId;

  String name;

  DateTime date;

  int totalMarks;

  /// Returns a shallow copy of this [Exam]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Exam copyWith({
    int? id,
    int? organizationId,
    int? classId,
    int? subjectId,
    String? name,
    DateTime? date,
    int? totalMarks,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'organizationId': organizationId,
      'classId': classId,
      'subjectId': subjectId,
      'name': name,
      'date': date.toJson(),
      'totalMarks': totalMarks,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ExamImpl extends Exam {
  _ExamImpl({
    int? id,
    required int organizationId,
    required int classId,
    required int subjectId,
    required String name,
    required DateTime date,
    required int totalMarks,
  }) : super._(
          id: id,
          organizationId: organizationId,
          classId: classId,
          subjectId: subjectId,
          name: name,
          date: date,
          totalMarks: totalMarks,
        );

  /// Returns a shallow copy of this [Exam]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Exam copyWith({
    Object? id = _Undefined,
    int? organizationId,
    int? classId,
    int? subjectId,
    String? name,
    DateTime? date,
    int? totalMarks,
  }) {
    return Exam(
      id: id is int? ? id : this.id,
      organizationId: organizationId ?? this.organizationId,
      classId: classId ?? this.classId,
      subjectId: subjectId ?? this.subjectId,
      name: name ?? this.name,
      date: date ?? this.date,
      totalMarks: totalMarks ?? this.totalMarks,
    );
  }
}
