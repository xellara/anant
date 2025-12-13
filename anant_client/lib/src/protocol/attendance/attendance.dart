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

/// Attendance
abstract class Attendance implements _i1.SerializableModel {
  Attendance._({
    this.id,
    required this.organizationName,
    required this.className,
    required this.sectionName,
    this.subjectName,
    required this.studentAnantId,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.markedByAnantId,
    required this.status,
    bool? isSubmitted,
    this.remarks,
  }) : isSubmitted = isSubmitted ?? false;

  factory Attendance({
    int? id,
    required String organizationName,
    required String className,
    required String sectionName,
    String? subjectName,
    required String studentAnantId,
    required String startTime,
    required String endTime,
    required String date,
    required String markedByAnantId,
    required String status,
    bool? isSubmitted,
    String? remarks,
  }) = _AttendanceImpl;

  factory Attendance.fromJson(Map<String, dynamic> jsonSerialization) {
    return Attendance(
      id: jsonSerialization['id'] as int?,
      organizationName: jsonSerialization['organizationName'] as String,
      className: jsonSerialization['className'] as String,
      sectionName: jsonSerialization['sectionName'] as String,
      subjectName: jsonSerialization['subjectName'] as String?,
      studentAnantId: jsonSerialization['studentAnantId'] as String,
      startTime: jsonSerialization['startTime'] as String,
      endTime: jsonSerialization['endTime'] as String,
      date: jsonSerialization['date'] as String,
      markedByAnantId: jsonSerialization['markedByAnantId'] as String,
      status: jsonSerialization['status'] as String,
      isSubmitted: jsonSerialization['isSubmitted'] as bool,
      remarks: jsonSerialization['remarks'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String organizationName;

  String className;

  String sectionName;

  String? subjectName;

  String studentAnantId;

  String startTime;

  String endTime;

  String date;

  String markedByAnantId;

  String status;

  bool isSubmitted;

  String? remarks;

  /// Returns a shallow copy of this [Attendance]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Attendance copyWith({
    int? id,
    String? organizationName,
    String? className,
    String? sectionName,
    String? subjectName,
    String? studentAnantId,
    String? startTime,
    String? endTime,
    String? date,
    String? markedByAnantId,
    String? status,
    bool? isSubmitted,
    String? remarks,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'organizationName': organizationName,
      'className': className,
      'sectionName': sectionName,
      if (subjectName != null) 'subjectName': subjectName,
      'studentAnantId': studentAnantId,
      'startTime': startTime,
      'endTime': endTime,
      'date': date,
      'markedByAnantId': markedByAnantId,
      'status': status,
      'isSubmitted': isSubmitted,
      if (remarks != null) 'remarks': remarks,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AttendanceImpl extends Attendance {
  _AttendanceImpl({
    int? id,
    required String organizationName,
    required String className,
    required String sectionName,
    String? subjectName,
    required String studentAnantId,
    required String startTime,
    required String endTime,
    required String date,
    required String markedByAnantId,
    required String status,
    bool? isSubmitted,
    String? remarks,
  }) : super._(
          id: id,
          organizationName: organizationName,
          className: className,
          sectionName: sectionName,
          subjectName: subjectName,
          studentAnantId: studentAnantId,
          startTime: startTime,
          endTime: endTime,
          date: date,
          markedByAnantId: markedByAnantId,
          status: status,
          isSubmitted: isSubmitted,
          remarks: remarks,
        );

  /// Returns a shallow copy of this [Attendance]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Attendance copyWith({
    Object? id = _Undefined,
    String? organizationName,
    String? className,
    String? sectionName,
    Object? subjectName = _Undefined,
    String? studentAnantId,
    String? startTime,
    String? endTime,
    String? date,
    String? markedByAnantId,
    String? status,
    bool? isSubmitted,
    Object? remarks = _Undefined,
  }) {
    return Attendance(
      id: id is int? ? id : this.id,
      organizationName: organizationName ?? this.organizationName,
      className: className ?? this.className,
      sectionName: sectionName ?? this.sectionName,
      subjectName: subjectName is String? ? subjectName : this.subjectName,
      studentAnantId: studentAnantId ?? this.studentAnantId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      date: date ?? this.date,
      markedByAnantId: markedByAnantId ?? this.markedByAnantId,
      status: status ?? this.status,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      remarks: remarks is String? ? remarks : this.remarks,
    );
  }
}
