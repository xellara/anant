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
import 'announcement.dart' as _i2;
import 'attendance/attendance.dart' as _i3;
import 'attendance/class.dart' as _i4;
import 'attendance/course.dart' as _i5;
import 'attendance/section.dart' as _i6;
import 'attendance/student_course_enrollement.dart' as _i7;
import 'auth/external_auth_provider.dart' as _i8;
import 'auth/organization.dart' as _i9;
import 'auth/organization_settings.dart' as _i10;
import 'auth/permission.dart' as _i11;
import 'auth/permission_audit.dart' as _i12;
import 'auth/resource_permission.dart' as _i13;
import 'auth/role.dart' as _i14;
import 'auth/role_permission.dart' as _i15;
import 'auth/user_credentials.dart' as _i16;
import 'auth/user_permission_override.dart' as _i17;
import 'auth/user_role_assignment.dart' as _i18;
import 'enrollement.dart' as _i19;
import 'exam.dart' as _i20;
import 'fee_record.dart' as _i21;
import 'notification.dart' as _i22;
import 'subject.dart' as _i23;
import 'time_table_entry.dart' as _i24;
import 'transaction/montly_fee_transaction.dart' as _i25;
import 'user/user.dart' as _i26;
import 'user/user_role.dart' as _i27;
import 'package:anant_client/src/protocol/announcement.dart' as _i28;
import 'package:anant_client/src/protocol/attendance/attendance.dart' as _i29;
import 'package:anant_client/src/protocol/user/user.dart' as _i30;
import 'package:anant_client/src/protocol/attendance/class.dart' as _i31;
import 'package:anant_client/src/protocol/attendance/course.dart' as _i32;
import 'package:anant_client/src/protocol/notification.dart' as _i33;
import 'package:anant_client/src/protocol/auth/organization.dart' as _i34;
import 'package:anant_client/src/protocol/auth/permission.dart' as _i35;
import 'package:anant_client/src/protocol/auth/role.dart' as _i36;
import 'package:anant_client/src/protocol/attendance/section.dart' as _i37;
import 'package:anant_client/src/protocol/transaction/montly_fee_transaction.dart'
    as _i38;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i39;
export 'announcement.dart';
export 'attendance/attendance.dart';
export 'attendance/class.dart';
export 'attendance/course.dart';
export 'attendance/section.dart';
export 'attendance/student_course_enrollement.dart';
export 'auth/external_auth_provider.dart';
export 'auth/organization.dart';
export 'auth/organization_settings.dart';
export 'auth/permission.dart';
export 'auth/permission_audit.dart';
export 'auth/resource_permission.dart';
export 'auth/role.dart';
export 'auth/role_permission.dart';
export 'auth/user_credentials.dart';
export 'auth/user_permission_override.dart';
export 'auth/user_role_assignment.dart';
export 'enrollement.dart';
export 'exam.dart';
export 'fee_record.dart';
export 'notification.dart';
export 'subject.dart';
export 'time_table_entry.dart';
export 'transaction/montly_fee_transaction.dart';
export 'user/user.dart';
export 'user/user_role.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i2.Announcement) {
      return _i2.Announcement.fromJson(data) as T;
    }
    if (t == _i3.Attendance) {
      return _i3.Attendance.fromJson(data) as T;
    }
    if (t == _i4.Classes) {
      return _i4.Classes.fromJson(data) as T;
    }
    if (t == _i5.Course) {
      return _i5.Course.fromJson(data) as T;
    }
    if (t == _i6.Section) {
      return _i6.Section.fromJson(data) as T;
    }
    if (t == _i7.StudentCourseEnrollment) {
      return _i7.StudentCourseEnrollment.fromJson(data) as T;
    }
    if (t == _i8.ExternalAuthProvider) {
      return _i8.ExternalAuthProvider.fromJson(data) as T;
    }
    if (t == _i9.Organization) {
      return _i9.Organization.fromJson(data) as T;
    }
    if (t == _i10.OrganizationSettings) {
      return _i10.OrganizationSettings.fromJson(data) as T;
    }
    if (t == _i11.Permission) {
      return _i11.Permission.fromJson(data) as T;
    }
    if (t == _i12.PermissionAudit) {
      return _i12.PermissionAudit.fromJson(data) as T;
    }
    if (t == _i13.ResourcePermission) {
      return _i13.ResourcePermission.fromJson(data) as T;
    }
    if (t == _i14.Role) {
      return _i14.Role.fromJson(data) as T;
    }
    if (t == _i15.RolePermission) {
      return _i15.RolePermission.fromJson(data) as T;
    }
    if (t == _i16.UserCredentials) {
      return _i16.UserCredentials.fromJson(data) as T;
    }
    if (t == _i17.UserPermissionOverride) {
      return _i17.UserPermissionOverride.fromJson(data) as T;
    }
    if (t == _i18.UserRoleAssignment) {
      return _i18.UserRoleAssignment.fromJson(data) as T;
    }
    if (t == _i19.Enrollment) {
      return _i19.Enrollment.fromJson(data) as T;
    }
    if (t == _i20.Exam) {
      return _i20.Exam.fromJson(data) as T;
    }
    if (t == _i21.FeeRecord) {
      return _i21.FeeRecord.fromJson(data) as T;
    }
    if (t == _i22.Notification) {
      return _i22.Notification.fromJson(data) as T;
    }
    if (t == _i23.Subject) {
      return _i23.Subject.fromJson(data) as T;
    }
    if (t == _i24.TimetableEntry) {
      return _i24.TimetableEntry.fromJson(data) as T;
    }
    if (t == _i25.MonthlyFeeTransaction) {
      return _i25.MonthlyFeeTransaction.fromJson(data) as T;
    }
    if (t == _i26.User) {
      return _i26.User.fromJson(data) as T;
    }
    if (t == _i27.UserRole) {
      return _i27.UserRole.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Announcement?>()) {
      return (data != null ? _i2.Announcement.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.Attendance?>()) {
      return (data != null ? _i3.Attendance.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.Classes?>()) {
      return (data != null ? _i4.Classes.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.Course?>()) {
      return (data != null ? _i5.Course.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Section?>()) {
      return (data != null ? _i6.Section.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.StudentCourseEnrollment?>()) {
      return (data != null ? _i7.StudentCourseEnrollment.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i8.ExternalAuthProvider?>()) {
      return (data != null ? _i8.ExternalAuthProvider.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i9.Organization?>()) {
      return (data != null ? _i9.Organization.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.OrganizationSettings?>()) {
      return (data != null ? _i10.OrganizationSettings.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.Permission?>()) {
      return (data != null ? _i11.Permission.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.PermissionAudit?>()) {
      return (data != null ? _i12.PermissionAudit.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.ResourcePermission?>()) {
      return (data != null ? _i13.ResourcePermission.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i14.Role?>()) {
      return (data != null ? _i14.Role.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.RolePermission?>()) {
      return (data != null ? _i15.RolePermission.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.UserCredentials?>()) {
      return (data != null ? _i16.UserCredentials.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.UserPermissionOverride?>()) {
      return (data != null ? _i17.UserPermissionOverride.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i18.UserRoleAssignment?>()) {
      return (data != null ? _i18.UserRoleAssignment.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i19.Enrollment?>()) {
      return (data != null ? _i19.Enrollment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.Exam?>()) {
      return (data != null ? _i20.Exam.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.FeeRecord?>()) {
      return (data != null ? _i21.FeeRecord.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.Notification?>()) {
      return (data != null ? _i22.Notification.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.Subject?>()) {
      return (data != null ? _i23.Subject.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.TimetableEntry?>()) {
      return (data != null ? _i24.TimetableEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.MonthlyFeeTransaction?>()) {
      return (data != null ? _i25.MonthlyFeeTransaction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i26.User?>()) {
      return (data != null ? _i26.User.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.UserRole?>()) {
      return (data != null ? _i27.UserRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<Map<String, double>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<double>(v)))
          : null) as T;
    }
    if (t == _i1.getType<Map<String, String>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<String>(v)))
          : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<String>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<String>(e)).toList()
          : null) as T;
    }
    if (t == List<_i28.Announcement>) {
      return (data as List)
          .map((e) => deserialize<_i28.Announcement>(e))
          .toList() as T;
    }
    if (t == List<_i29.Attendance>) {
      return (data as List).map((e) => deserialize<_i29.Attendance>(e)).toList()
          as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String>(v))) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<dynamic>(v))) as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<String>(e)).toList()
          : null) as T;
    }
    if (t == List<Map<String, dynamic>>) {
      return (data as List)
          .map((e) => deserialize<Map<String, dynamic>>(e))
          .toList() as T;
    }
    if (t == List<_i30.User>) {
      return (data as List).map((e) => deserialize<_i30.User>(e)).toList() as T;
    }
    if (t == List<_i31.Classes>) {
      return (data as List).map((e) => deserialize<_i31.Classes>(e)).toList()
          as T;
    }
    if (t == List<_i32.Course>) {
      return (data as List).map((e) => deserialize<_i32.Course>(e)).toList()
          as T;
    }
    if (t == List<_i33.Notification>) {
      return (data as List)
          .map((e) => deserialize<_i33.Notification>(e))
          .toList() as T;
    }
    if (t == List<_i34.Organization>) {
      return (data as List)
          .map((e) => deserialize<_i34.Organization>(e))
          .toList() as T;
    }
    if (t == List<_i35.Permission>) {
      return (data as List).map((e) => deserialize<_i35.Permission>(e)).toList()
          as T;
    }
    if (t == List<_i36.Role>) {
      return (data as List).map((e) => deserialize<_i36.Role>(e)).toList() as T;
    }
    if (t == List<_i37.Section>) {
      return (data as List).map((e) => deserialize<_i37.Section>(e)).toList()
          as T;
    }
    if (t == List<_i38.MonthlyFeeTransaction>) {
      return (data as List)
          .map((e) => deserialize<_i38.MonthlyFeeTransaction>(e))
          .toList() as T;
    }
    try {
      return _i39.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i2.Announcement) {
      return 'Announcement';
    }
    if (data is _i3.Attendance) {
      return 'Attendance';
    }
    if (data is _i4.Classes) {
      return 'Classes';
    }
    if (data is _i5.Course) {
      return 'Course';
    }
    if (data is _i6.Section) {
      return 'Section';
    }
    if (data is _i7.StudentCourseEnrollment) {
      return 'StudentCourseEnrollment';
    }
    if (data is _i8.ExternalAuthProvider) {
      return 'ExternalAuthProvider';
    }
    if (data is _i9.Organization) {
      return 'Organization';
    }
    if (data is _i10.OrganizationSettings) {
      return 'OrganizationSettings';
    }
    if (data is _i11.Permission) {
      return 'Permission';
    }
    if (data is _i12.PermissionAudit) {
      return 'PermissionAudit';
    }
    if (data is _i13.ResourcePermission) {
      return 'ResourcePermission';
    }
    if (data is _i14.Role) {
      return 'Role';
    }
    if (data is _i15.RolePermission) {
      return 'RolePermission';
    }
    if (data is _i16.UserCredentials) {
      return 'UserCredentials';
    }
    if (data is _i17.UserPermissionOverride) {
      return 'UserPermissionOverride';
    }
    if (data is _i18.UserRoleAssignment) {
      return 'UserRoleAssignment';
    }
    if (data is _i19.Enrollment) {
      return 'Enrollment';
    }
    if (data is _i20.Exam) {
      return 'Exam';
    }
    if (data is _i21.FeeRecord) {
      return 'FeeRecord';
    }
    if (data is _i22.Notification) {
      return 'Notification';
    }
    if (data is _i23.Subject) {
      return 'Subject';
    }
    if (data is _i24.TimetableEntry) {
      return 'TimetableEntry';
    }
    if (data is _i25.MonthlyFeeTransaction) {
      return 'MonthlyFeeTransaction';
    }
    if (data is _i26.User) {
      return 'User';
    }
    if (data is _i27.UserRole) {
      return 'UserRole';
    }
    className = _i39.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Announcement') {
      return deserialize<_i2.Announcement>(data['data']);
    }
    if (dataClassName == 'Attendance') {
      return deserialize<_i3.Attendance>(data['data']);
    }
    if (dataClassName == 'Classes') {
      return deserialize<_i4.Classes>(data['data']);
    }
    if (dataClassName == 'Course') {
      return deserialize<_i5.Course>(data['data']);
    }
    if (dataClassName == 'Section') {
      return deserialize<_i6.Section>(data['data']);
    }
    if (dataClassName == 'StudentCourseEnrollment') {
      return deserialize<_i7.StudentCourseEnrollment>(data['data']);
    }
    if (dataClassName == 'ExternalAuthProvider') {
      return deserialize<_i8.ExternalAuthProvider>(data['data']);
    }
    if (dataClassName == 'Organization') {
      return deserialize<_i9.Organization>(data['data']);
    }
    if (dataClassName == 'OrganizationSettings') {
      return deserialize<_i10.OrganizationSettings>(data['data']);
    }
    if (dataClassName == 'Permission') {
      return deserialize<_i11.Permission>(data['data']);
    }
    if (dataClassName == 'PermissionAudit') {
      return deserialize<_i12.PermissionAudit>(data['data']);
    }
    if (dataClassName == 'ResourcePermission') {
      return deserialize<_i13.ResourcePermission>(data['data']);
    }
    if (dataClassName == 'Role') {
      return deserialize<_i14.Role>(data['data']);
    }
    if (dataClassName == 'RolePermission') {
      return deserialize<_i15.RolePermission>(data['data']);
    }
    if (dataClassName == 'UserCredentials') {
      return deserialize<_i16.UserCredentials>(data['data']);
    }
    if (dataClassName == 'UserPermissionOverride') {
      return deserialize<_i17.UserPermissionOverride>(data['data']);
    }
    if (dataClassName == 'UserRoleAssignment') {
      return deserialize<_i18.UserRoleAssignment>(data['data']);
    }
    if (dataClassName == 'Enrollment') {
      return deserialize<_i19.Enrollment>(data['data']);
    }
    if (dataClassName == 'Exam') {
      return deserialize<_i20.Exam>(data['data']);
    }
    if (dataClassName == 'FeeRecord') {
      return deserialize<_i21.FeeRecord>(data['data']);
    }
    if (dataClassName == 'Notification') {
      return deserialize<_i22.Notification>(data['data']);
    }
    if (dataClassName == 'Subject') {
      return deserialize<_i23.Subject>(data['data']);
    }
    if (dataClassName == 'TimetableEntry') {
      return deserialize<_i24.TimetableEntry>(data['data']);
    }
    if (dataClassName == 'MonthlyFeeTransaction') {
      return deserialize<_i25.MonthlyFeeTransaction>(data['data']);
    }
    if (dataClassName == 'User') {
      return deserialize<_i26.User>(data['data']);
    }
    if (dataClassName == 'UserRole') {
      return deserialize<_i27.UserRole>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i39.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
