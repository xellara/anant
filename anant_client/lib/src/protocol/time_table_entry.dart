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

abstract class TimetableEntry implements _i1.SerializableModel {
  TimetableEntry._({
    this.id,
    required this.organizationId,
    required this.classId,
    required this.subjectId,
    required this.teacherId,
    required this.dayOfWeek,
    required this.startTime,
    required this.durationMinutes,
  });

  factory TimetableEntry({
    int? id,
    required int organizationId,
    required int classId,
    required int subjectId,
    required int teacherId,
    required int dayOfWeek,
    required DateTime startTime,
    required int durationMinutes,
  }) = _TimetableEntryImpl;

  factory TimetableEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return TimetableEntry(
      id: jsonSerialization['id'] as int?,
      organizationId: jsonSerialization['organizationId'] as int,
      classId: jsonSerialization['classId'] as int,
      subjectId: jsonSerialization['subjectId'] as int,
      teacherId: jsonSerialization['teacherId'] as int,
      dayOfWeek: jsonSerialization['dayOfWeek'] as int,
      startTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startTime'],
      ),
      durationMinutes: jsonSerialization['durationMinutes'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int organizationId;

  int classId;

  int subjectId;

  int teacherId;

  int dayOfWeek;

  DateTime startTime;

  int durationMinutes;

  /// Returns a shallow copy of this [TimetableEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TimetableEntry copyWith({
    int? id,
    int? organizationId,
    int? classId,
    int? subjectId,
    int? teacherId,
    int? dayOfWeek,
    DateTime? startTime,
    int? durationMinutes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TimetableEntry',
      if (id != null) 'id': id,
      'organizationId': organizationId,
      'classId': classId,
      'subjectId': subjectId,
      'teacherId': teacherId,
      'dayOfWeek': dayOfWeek,
      'startTime': startTime.toJson(),
      'durationMinutes': durationMinutes,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TimetableEntryImpl extends TimetableEntry {
  _TimetableEntryImpl({
    int? id,
    required int organizationId,
    required int classId,
    required int subjectId,
    required int teacherId,
    required int dayOfWeek,
    required DateTime startTime,
    required int durationMinutes,
  }) : super._(
         id: id,
         organizationId: organizationId,
         classId: classId,
         subjectId: subjectId,
         teacherId: teacherId,
         dayOfWeek: dayOfWeek,
         startTime: startTime,
         durationMinutes: durationMinutes,
       );

  /// Returns a shallow copy of this [TimetableEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TimetableEntry copyWith({
    Object? id = _Undefined,
    int? organizationId,
    int? classId,
    int? subjectId,
    int? teacherId,
    int? dayOfWeek,
    DateTime? startTime,
    int? durationMinutes,
  }) {
    return TimetableEntry(
      id: id is int? ? id : this.id,
      organizationId: organizationId ?? this.organizationId,
      classId: classId ?? this.classId,
      subjectId: subjectId ?? this.subjectId,
      teacherId: teacherId ?? this.teacherId,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startTime: startTime ?? this.startTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
    );
  }
}
