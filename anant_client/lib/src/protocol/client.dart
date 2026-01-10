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
import 'dart:async' as _i2;
import 'package:anant_client/src/protocol/announcement.dart' as _i3;
import 'package:anant_client/src/protocol/attendance/attendance.dart' as _i4;
import 'package:anant_client/src/protocol/user/user_role.dart' as _i5;
import 'package:anant_client/src/protocol/user/user.dart' as _i6;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i7;
import 'package:anant_client/src/protocol/attendance/class.dart' as _i8;
import 'package:anant_client/src/protocol/attendance/course.dart' as _i9;
import 'package:anant_client/src/protocol/notification.dart' as _i10;
import 'package:anant_client/src/protocol/auth/organization.dart' as _i11;
import 'package:anant_client/src/protocol/auth/permission.dart' as _i12;
import 'package:anant_client/src/protocol/auth/role.dart' as _i13;
import 'package:anant_client/src/protocol/auth/role_permission.dart' as _i14;
import 'package:anant_client/src/protocol/attendance/section.dart' as _i15;
import 'package:anant_client/src/protocol/auth/organization_settings.dart'
    as _i16;
import 'package:anant_client/src/protocol/transaction/montly_fee_transaction.dart'
    as _i17;
import 'protocol.dart' as _i18;

/// {@category Endpoint}
class EndpointAnnouncement extends _i1.EndpointRef {
  EndpointAnnouncement(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'announcement';

  /// Get all announcements for a user based on their role
  _i2.Future<List<_i3.Announcement>> getAnnouncementsForUser(
    String userId,
    String userRole,
  ) => caller.callServerEndpoint<List<_i3.Announcement>>(
    'announcement',
    'getAnnouncementsForUser',
    {
      'userId': userId,
      'userRole': userRole,
    },
  );

  /// Create a new announcement
  _i2.Future<_i3.Announcement?> createAnnouncement(
    _i3.Announcement announcement,
  ) => caller.callServerEndpoint<_i3.Announcement?>(
    'announcement',
    'createAnnouncement',
    {'announcement': announcement},
  );

  /// Delete an announcement
  _i2.Future<bool> deleteAnnouncement(int announcementId) =>
      caller.callServerEndpoint<bool>(
        'announcement',
        'deleteAnnouncement',
        {'announcementId': announcementId},
      );

  /// Update an announcement
  _i2.Future<bool> updateAnnouncement(_i3.Announcement announcement) =>
      caller.callServerEndpoint<bool>(
        'announcement',
        'updateAnnouncement',
        {'announcement': announcement},
      );
}

/// {@category Endpoint}
class EndpointAttendance extends _i1.EndpointRef {
  EndpointAttendance(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'attendance';

  /// Update or create a single attendance record
  _i2.Future<void> updateSingleAttendance(_i4.Attendance attendance) =>
      caller.callServerEndpoint<void>(
        'attendance',
        'updateSingleAttendance',
        {'attendance': attendance},
      );

  /// Submit full attendance list and mark all as submitted
  _i2.Future<void> submitCompleteAttendance(
    List<_i4.Attendance> attendanceList,
  ) => caller.callServerEndpoint<void>(
    'attendance',
    'submitCompleteAttendance',
    {'attendanceList': attendanceList},
  );

  /// Get attendance status for a list of userIds
  _i2.Future<Map<String, String>> getFilteredAttendanceStatus(
    List<String> studentAnantId,
    String subjectName,
    String startTime,
    String endTime,
    String sectionName,
    String className,
    String date,
    String organizationName,
  ) => caller.callServerEndpoint<Map<String, String>>(
    'attendance',
    'getFilteredAttendanceStatus',
    {
      'studentAnantId': studentAnantId,
      'subjectName': subjectName,
      'startTime': startTime,
      'endTime': endTime,
      'sectionName': sectionName,
      'className': className,
      'date': date,
      'organizationName': organizationName,
    },
  );

  /// Get all attendance records for a specific user using their Anant ID.
  _i2.Future<List<_i4.Attendance>> getUserAttendanceRecords(
    String studentAnantId,
  ) => caller.callServerEndpoint<List<_i4.Attendance>>(
    'attendance',
    'getUserAttendanceRecords',
    {'studentAnantId': studentAnantId},
  );

  /// Stream attendance updates for a user
  _i2.Stream<_i4.Attendance> receiveAttendanceStream(
    String studentAnantId,
  ) => caller
      .callStreamingServerEndpoint<_i2.Stream<_i4.Attendance>, _i4.Attendance>(
        'attendance',
        'receiveAttendanceStream',
        {'studentAnantId': studentAnantId},
        {},
      );
}

/// {@category Endpoint}
class EndpointAuth extends _i1.EndpointRef {
  EndpointAuth(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'auth';

  /// Sign up a new user.
  _i2.Future<Map<String, dynamic>> signUp(
    _i5.UserRole role,
    String organizationName, {
    String? sectionName,
    String? admissionNumber,
    String? className,
    String? rollNumber,
    String? email,
    String? password,
    String? fullName,
    String? anantId,
    String? profileImageUrl,
    String? mobileNumber,
    String? parentMobileNumber,
    String? address,
    String? city,
    String? state,
    String? country,
    String? pincode,
    String? dob,
    String? bloodGroup,
    String? aadharNumber,
    List<String>? subjectTeaching,
    List<String>? classAndSectionTeaching,
  }) => caller.callServerEndpoint<Map<String, dynamic>>(
    'auth',
    'signUp',
    {
      'role': role,
      'organizationName': organizationName,
      'sectionName': sectionName,
      'admissionNumber': admissionNumber,
      'className': className,
      'rollNumber': rollNumber,
      'email': email,
      'password': password,
      'fullName': fullName,
      'anantId': anantId,
      'profileImageUrl': profileImageUrl,
      'mobileNumber': mobileNumber,
      'parentMobileNumber': parentMobileNumber,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'pincode': pincode,
      'dob': dob,
      'bloodGroup': bloodGroup,
      'aadharNumber': aadharNumber,
      'subjectTeaching': subjectTeaching,
      'classAndSectionTeaching': classAndSectionTeaching,
    },
  );

  /// Bulk sign up new users.
  _i2.Future<List<Map<String, dynamic>>> bulkSignUp(List<_i6.User> userList) =>
      caller.callServerEndpoint<List<Map<String, dynamic>>>(
        'auth',
        'bulkSignUp',
        {'userList': userList},
      );

  /// Sign in a user by verifying their credentials.
  _i2.Future<_i7.AuthKey> signIn(
    String anantId,
    String password,
  ) => caller.callServerEndpoint<_i7.AuthKey>(
    'auth',
    'signIn',
    {
      'anantId': anantId,
      'password': password,
    },
  );

  /// Update a user's details.
  _i2.Future<_i7.AuthKey> updateUser(
    int userId, {
    String? newAnantId,
    String? newPassword,
    String? newEmail,
    String? newFullName,
    _i5.UserRole? newRole,
    bool? isActive,
    String? newClassName,
    String? newRollNumber,
    String? newAdmissionNumber,
    String? newSectionName,
    String? newOrganizationName,
    String? newProfileImageUrl,
    String? newMobileNumber,
    String? newParentMobileNumber,
    String? newAddress,
    String? newCity,
    String? newState,
    String? newCountry,
    String? newPincode,
    String? newDob,
    String? newBloodGroup,
    String? newAadharNumber,
    List<String>? newSubjectTeaching,
    List<String>? newClassAndSectionTeaching,
  }) => caller.callServerEndpoint<_i7.AuthKey>(
    'auth',
    'updateUser',
    {
      'userId': userId,
      'newAnantId': newAnantId,
      'newPassword': newPassword,
      'newEmail': newEmail,
      'newFullName': newFullName,
      'newRole': newRole,
      'isActive': isActive,
      'newClassName': newClassName,
      'newRollNumber': newRollNumber,
      'newAdmissionNumber': newAdmissionNumber,
      'newSectionName': newSectionName,
      'newOrganizationName': newOrganizationName,
      'newProfileImageUrl': newProfileImageUrl,
      'newMobileNumber': newMobileNumber,
      'newParentMobileNumber': newParentMobileNumber,
      'newAddress': newAddress,
      'newCity': newCity,
      'newState': newState,
      'newCountry': newCountry,
      'newPincode': newPincode,
      'newDob': newDob,
      'newBloodGroup': newBloodGroup,
      'newAadharNumber': newAadharNumber,
      'newSubjectTeaching': newSubjectTeaching,
      'newClassAndSectionTeaching': newClassAndSectionTeaching,
    },
  );

  /// Delete a user.
  _i2.Future<bool> deleteUser(int userId) => caller.callServerEndpoint<bool>(
    'auth',
    'deleteUser',
    {'userId': userId},
  );
}

/// {@category Endpoint}
class EndpointClasses extends _i1.EndpointRef {
  EndpointClasses(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'classes';

  /// Create a new Class linked to an Organization
  _i2.Future<_i8.Classes> createClasses(_i8.Classes cls) =>
      caller.callServerEndpoint<_i8.Classes>(
        'classes',
        'createClasses',
        {'cls': cls},
      );

  /// Get a Classes by its id
  _i2.Future<_i8.Classes?> getClasses(int id) =>
      caller.callServerEndpoint<_i8.Classes?>(
        'classes',
        'getClasses',
        {'id': id},
      );

  /// Get all Classeses (optionally, could filter by organizationId if needed)
  _i2.Future<List<_i8.Classes>> getAllClasseses() =>
      caller.callServerEndpoint<List<_i8.Classes>>(
        'classes',
        'getAllClasseses',
        {},
      );

  /// Delete a Classes by id
  _i2.Future<bool> deleteClasses(int id) => caller.callServerEndpoint<bool>(
    'classes',
    'deleteClasses',
    {'id': id},
  );
}

/// {@category Endpoint}
class EndpointCourse extends _i1.EndpointRef {
  EndpointCourse(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'course';

  /// Create a new Course associated with an Organization
  _i2.Future<_i9.Course> createCourse(_i9.Course course) =>
      caller.callServerEndpoint<_i9.Course>(
        'course',
        'createCourse',
        {'course': course},
      );

  /// Get a Course by its id
  _i2.Future<_i9.Course?> getCourse(int id) =>
      caller.callServerEndpoint<_i9.Course?>(
        'course',
        'getCourse',
        {'id': id},
      );

  /// Get all Courses
  _i2.Future<List<_i9.Course>> getAllCourses() =>
      caller.callServerEndpoint<List<_i9.Course>>(
        'course',
        'getAllCourses',
        {},
      );

  /// Delete a Course by id
  _i2.Future<bool> deleteCourse(int id) => caller.callServerEndpoint<bool>(
    'course',
    'deleteCourse',
    {'id': id},
  );
}

/// {@category Endpoint}
class EndpointExam extends _i1.EndpointRef {
  EndpointExam(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'exam';

  /// Get exam schedule with subject details
  _i2.Future<List<Map<String, dynamic>>> getExamSchedule(String userId) =>
      caller.callServerEndpoint<List<Map<String, dynamic>>>(
        'exam',
        'getExamSchedule',
        {'userId': userId},
      );
}

/// {@category Endpoint}
class EndpointNotification extends _i1.EndpointRef {
  EndpointNotification(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'notification';

  /// Get all notifications for a user
  _i2.Future<List<_i10.Notification>> getUserNotifications(String userId) =>
      caller.callServerEndpoint<List<_i10.Notification>>(
        'notification',
        'getUserNotifications',
        {'userId': userId},
      );

  /// Mark notification as read
  _i2.Future<bool> markAsRead(int notificationId) =>
      caller.callServerEndpoint<bool>(
        'notification',
        'markAsRead',
        {'notificationId': notificationId},
      );

  /// Mark all notifications as read for a user
  _i2.Future<bool> markAllAsRead(String userId) =>
      caller.callServerEndpoint<bool>(
        'notification',
        'markAllAsRead',
        {'userId': userId},
      );

  /// Delete a notification
  _i2.Future<bool> deleteNotification(int notificationId) =>
      caller.callServerEndpoint<bool>(
        'notification',
        'deleteNotification',
        {'notificationId': notificationId},
      );

  /// Create a notification (for system use)
  _i2.Future<_i10.Notification?> createNotification(
    _i10.Notification notification,
  ) => caller.callServerEndpoint<_i10.Notification?>(
    'notification',
    'createNotification',
    {'notification': notification},
  );

  /// Get unread count for a user
  _i2.Future<int> getUnreadCount(String userId) =>
      caller.callServerEndpoint<int>(
        'notification',
        'getUnreadCount',
        {'userId': userId},
      );

  /// Stream notifications for a user
  _i2.Stream<_i10.Notification> receiveNotificationStream(String userId) =>
      caller.callStreamingServerEndpoint<
        _i2.Stream<_i10.Notification>,
        _i10.Notification
      >(
        'notification',
        'receiveNotificationStream',
        {'userId': userId},
        {},
      );
}

/// {@category Endpoint}
class EndpointOrganization extends _i1.EndpointRef {
  EndpointOrganization(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'organization';

  /// Create a new Organization in the database
  _i2.Future<_i11.Organization> createOrganization(_i11.Organization org) =>
      caller.callServerEndpoint<_i11.Organization>(
        'organization',
        'createOrganization',
        {'org': org},
      );

  /// Retrieve a single Organization by its name
  _i2.Future<_i11.Organization?> getOrganization(String organizationName) =>
      caller.callServerEndpoint<_i11.Organization?>(
        'organization',
        'getOrganization',
        {'organizationName': organizationName},
      );

  /// Retrieve all Organizations
  _i2.Future<List<_i11.Organization>> getAllOrganizations() =>
      caller.callServerEndpoint<List<_i11.Organization>>(
        'organization',
        'getAllOrganizations',
        {},
      );

  /// Delete an Organization by name
  _i2.Future<bool> deleteOrganization(String organizationName) =>
      caller.callServerEndpoint<bool>(
        'organization',
        'deleteOrganization',
        {'organizationName': organizationName},
      );
}

/// Endpoint for managing permissions.
/// {@category Endpoint}
class EndpointPermission extends _i1.EndpointRef {
  EndpointPermission(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'permission';

  /// Create a new permission.
  _i2.Future<_i12.Permission?> createPermission(
    String slug,
    String? description,
    String? module,
  ) => caller.callServerEndpoint<_i12.Permission?>(
    'permission',
    'createPermission',
    {
      'slug': slug,
      'description': description,
      'module': module,
    },
  );

  /// Get all permissions.
  _i2.Future<List<_i12.Permission>> getAllPermissions() =>
      caller.callServerEndpoint<List<_i12.Permission>>(
        'permission',
        'getAllPermissions',
        {},
      );

  /// Get permissions by module.
  _i2.Future<List<_i12.Permission>> getPermissionsByModule(String module) =>
      caller.callServerEndpoint<List<_i12.Permission>>(
        'permission',
        'getPermissionsByModule',
        {'module': module},
      );

  /// Update a permission.
  _i2.Future<_i12.Permission?> updatePermission(
    int permissionId,
    String? description,
    String? module,
  ) => caller.callServerEndpoint<_i12.Permission?>(
    'permission',
    'updatePermission',
    {
      'permissionId': permissionId,
      'description': description,
      'module': module,
    },
  );

  /// Delete a permission.
  _i2.Future<bool> deletePermission(int permissionId) =>
      caller.callServerEndpoint<bool>(
        'permission',
        'deletePermission',
        {'permissionId': permissionId},
      );

  /// Initialize default permissions for the system.
  _i2.Future<Map<String, dynamic>> initializeDefaultPermissions() =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'permission',
        'initializeDefaultPermissions',
        {},
      );

  /// Get effective list of permission slugs for a given user.
  /// Considers: Org Settings -> Role Permissions -> User Overrides.
  _i2.Future<List<String>> getEffectivePermissions(int targetUserId) =>
      caller.callServerEndpoint<List<String>>(
        'permission',
        'getEffectivePermissions',
        {'targetUserId': targetUserId},
      );

  /// Grant a specific permission to a user (Override).
  _i2.Future<bool> grantUserPermission(
    int userId,
    String permissionSlug,
  ) => caller.callServerEndpoint<bool>(
    'permission',
    'grantUserPermission',
    {
      'userId': userId,
      'permissionSlug': permissionSlug,
    },
  );

  /// Revoke a specific permission from a user (Override).
  _i2.Future<bool> revokeUserPermission(
    int userId,
    String permissionSlug,
  ) => caller.callServerEndpoint<bool>(
    'permission',
    'revokeUserPermission',
    {
      'userId': userId,
      'permissionSlug': permissionSlug,
    },
  );

  /// Reset a user's permission override (Back to Role default).
  _i2.Future<bool> resetUserPermission(
    int userId,
    String permissionSlug,
  ) => caller.callServerEndpoint<bool>(
    'permission',
    'resetUserPermission',
    {
      'userId': userId,
      'permissionSlug': permissionSlug,
    },
  );
}

/// {@category Endpoint}
class EndpointReport extends _i1.EndpointRef {
  EndpointReport(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'report';

  /// Get revenue/fee collection report
  _i2.Future<Map<String, dynamic>> getRevenueReport(
    String organizationId,
    DateTime startDate,
    DateTime endDate,
  ) => caller.callServerEndpoint<Map<String, dynamic>>(
    'report',
    'getRevenueReport',
    {
      'organizationId': organizationId,
      'startDate': startDate,
      'endDate': endDate,
    },
  );

  /// Get attendance report
  _i2.Future<Map<String, dynamic>> getAttendanceReport(
    String organizationId,
    String period,
  ) => caller.callServerEndpoint<Map<String, dynamic>>(
    'report',
    'getAttendanceReport',
    {
      'organizationId': organizationId,
      'period': period,
    },
  );

  /// Get student statistics
  _i2.Future<Map<String, dynamic>> getStudentStatistics(
    String organizationId,
  ) => caller.callServerEndpoint<Map<String, dynamic>>(
    'report',
    'getStudentStatistics',
    {'organizationId': organizationId},
  );

  /// Get fee collection statistics
  _i2.Future<Map<String, dynamic>> getFeeStatistics(String organizationId) =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'report',
        'getFeeStatistics',
        {'organizationId': organizationId},
      );

  /// Get class-wise statistics
  _i2.Future<List<Map<String, dynamic>>> getClassWiseStatistics(
    String organizationId,
  ) => caller.callServerEndpoint<List<Map<String, dynamic>>>(
    'report',
    'getClassWiseStatistics',
    {'organizationId': organizationId},
  );

  /// Export report as CSV/PDF
  _i2.Future<String> exportReport(
    String reportType,
    Map<String, dynamic> filters,
  ) => caller.callServerEndpoint<String>(
    'report',
    'exportReport',
    {
      'reportType': reportType,
      'filters': filters,
    },
  );
}

/// Endpoint for managing roles and permissions (RBAC).
/// {@category Endpoint}
class EndpointRole extends _i1.EndpointRef {
  EndpointRole(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'role';

  /// Create a new role.
  _i2.Future<_i13.Role?> createRole(
    String name,
    String slug,
    String? description,
    String? organizationName,
    bool isSystemRole,
  ) => caller.callServerEndpoint<_i13.Role?>(
    'role',
    'createRole',
    {
      'name': name,
      'slug': slug,
      'description': description,
      'organizationName': organizationName,
      'isSystemRole': isSystemRole,
    },
  );

  /// Get all roles for an organization.
  _i2.Future<List<_i13.Role>> getRoles({String? organizationName}) =>
      caller.callServerEndpoint<List<_i13.Role>>(
        'role',
        'getRoles',
        {'organizationName': organizationName},
      );

  /// Update a role.
  _i2.Future<_i13.Role?> updateRole(
    int roleId,
    String? name,
    String? description,
  ) => caller.callServerEndpoint<_i13.Role?>(
    'role',
    'updateRole',
    {
      'roleId': roleId,
      'name': name,
      'description': description,
    },
  );

  /// Delete a role.
  _i2.Future<bool> deleteRole(int roleId) => caller.callServerEndpoint<bool>(
    'role',
    'deleteRole',
    {'roleId': roleId},
  );

  /// Assign a permission to a role.
  _i2.Future<_i14.RolePermission?> assignPermission(
    int roleId,
    int permissionId,
  ) => caller.callServerEndpoint<_i14.RolePermission?>(
    'role',
    'assignPermission',
    {
      'roleId': roleId,
      'permissionId': permissionId,
    },
  );

  /// Remove a permission from a role.
  _i2.Future<bool> removePermission(
    int roleId,
    int permissionId,
  ) => caller.callServerEndpoint<bool>(
    'role',
    'removePermission',
    {
      'roleId': roleId,
      'permissionId': permissionId,
    },
  );

  /// Get all permissions for a role.
  _i2.Future<List<_i12.Permission>> getPermissionsForRole(int roleId) =>
      caller.callServerEndpoint<List<_i12.Permission>>(
        'role',
        'getPermissionsForRole',
        {'roleId': roleId},
      );
}

/// {@category Endpoint}
class EndpointSection extends _i1.EndpointRef {
  EndpointSection(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'section';

  /// Create a new Section under an Organization (organizationId must be set)
  _i2.Future<_i15.Section> createSection(_i15.Section section) =>
      caller.callServerEndpoint<_i15.Section>(
        'section',
        'createSection',
        {'section': section},
      );

  /// Retrieve a Section by id
  _i2.Future<_i15.Section?> getSection(int id) =>
      caller.callServerEndpoint<_i15.Section?>(
        'section',
        'getSection',
        {'id': id},
      );

  /// Retrieve all Sections (or use a filter by organizationId if needed)
  _i2.Future<List<_i15.Section>> getAllSections() =>
      caller.callServerEndpoint<List<_i15.Section>>(
        'section',
        'getAllSections',
        {},
      );

  /// Delete a Section by id
  _i2.Future<bool> deleteSection(int id) => caller.callServerEndpoint<bool>(
    'section',
    'deleteSection',
    {'id': id},
  );
}

/// {@category Endpoint}
class EndpointSeed extends _i1.EndpointRef {
  EndpointSeed(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'seed';

  _i2.Future<Map<String, dynamic>> seedDatabase() =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'seed',
        'seedDatabase',
        {},
      );
}

/// {@category Endpoint}
class EndpointSettings extends _i1.EndpointRef {
  EndpointSettings(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'settings';

  /// Get settings for the user's organization.
  _i2.Future<_i16.OrganizationSettings?> getSettings() =>
      caller.callServerEndpoint<_i16.OrganizationSettings?>(
        'settings',
        'getSettings',
        {},
      );

  /// Update settings (Admin/Principal only)
  _i2.Future<void> updateSettings(List<String> enabledModules) =>
      caller.callServerEndpoint<void>(
        'settings',
        'updateSettings',
        {'enabledModules': enabledModules},
      );
}

/// {@category Endpoint}
class EndpointTimetable extends _i1.EndpointRef {
  EndpointTimetable(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'timetable';

  /// Get timetable for a user (student or teacher)
  _i2.Future<List<Map<String, dynamic>>> getTimetable(
    String userId,
    String role,
  ) => caller.callServerEndpoint<List<Map<String, dynamic>>>(
    'timetable',
    'getTimetable',
    {
      'userId': userId,
      'role': role,
    },
  );

  /// Create or update timetable entry
  _i2.Future<bool> upsertTimetableEntry(Map<String, dynamic> entry) =>
      caller.callServerEndpoint<bool>(
        'timetable',
        'upsertTimetableEntry',
        {'entry': entry},
      );

  /// Delete timetable entry
  _i2.Future<bool> deleteTimetableEntry(String entryId) =>
      caller.callServerEndpoint<bool>(
        'timetable',
        'deleteTimetableEntry',
        {'entryId': entryId},
      );

  /// Get timetable for a specific class
  _i2.Future<List<Map<String, dynamic>>> getClassTimetable(String classId) =>
      caller.callServerEndpoint<List<Map<String, dynamic>>>(
        'timetable',
        'getClassTimetable',
        {'classId': classId},
      );
}

/// {@category Endpoint}
class EndpointTransaction extends _i1.EndpointRef {
  EndpointTransaction(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'transaction';

  /// Create a new MonthlyFeeTransaction in the database (no checks).
  _i2.Future<_i17.MonthlyFeeTransaction> createMonthlyFeeTransaction(
    _i17.MonthlyFeeTransaction txn,
  ) => caller.callServerEndpoint<_i17.MonthlyFeeTransaction>(
    'transaction',
    'createMonthlyFeeTransaction',
    {'txn': txn},
  );

  /// Retrieve a single MonthlyFeeTransaction by its month
  _i2.Future<_i17.MonthlyFeeTransaction?> getMonthlyFeeTransaction(
    String month,
    String anantId,
  ) => caller.callServerEndpoint<_i17.MonthlyFeeTransaction?>(
    'transaction',
    'getMonthlyFeeTransaction',
    {
      'month': month,
      'anantId': anantId,
    },
  );

  /// Retrieve all MonthlyFeeTransactions
  _i2.Future<List<_i17.MonthlyFeeTransaction>> getAllMonthlyFeeTransactionUser(
    String anantId,
  ) => caller.callServerEndpoint<List<_i17.MonthlyFeeTransaction>>(
    'transaction',
    'getAllMonthlyFeeTransactionUser',
    {'anantId': anantId},
  );

  _i2.Future<List<_i17.MonthlyFeeTransaction>> getAllMonthlyFeeTransactionOrg(
    String organizationName,
  ) => caller.callServerEndpoint<List<_i17.MonthlyFeeTransaction>>(
    'transaction',
    'getAllMonthlyFeeTransactionOrg',
    {'organizationName': organizationName},
  );

  /// Delete a MonthlyFeeTransaction by month
  _i2.Future<bool> deleteMonthlyFeeTransaction(
    String month,
    String anantId,
  ) => caller.callServerEndpoint<bool>(
    'transaction',
    'deleteMonthlyFeeTransaction',
    {
      'month': month,
      'anantId': anantId,
    },
  );
}

/// {@category Endpoint}
class EndpointUser extends _i1.EndpointRef {
  EndpointUser(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'user';

  /// Retrieves all the data about a user given their user ID.
  _i2.Future<_i6.User?> me(int userId) => caller.callServerEndpoint<_i6.User?>(
    'user',
    'me',
    {'userId': userId},
  );

  /// Retrieves user data by anantId (case-insensitive).
  _i2.Future<_i6.User?> getByAnantId(String anantId) =>
      caller.callServerEndpoint<_i6.User?>(
        'user',
        'getByAnantId',
        {'anantId': anantId},
      );

  /// Get all Users without filtering.
  _i2.Future<List<_i6.User>> getAllUsers() =>
      caller.callServerEndpoint<List<_i6.User>>(
        'user',
        'getAllUsers',
        {},
      );

  /// Get all Users filtered by sectionName, className, and organizationName.
  _i2.Future<List<_i6.User>> getFilteredUsers(
    String sectionName,
    String className,
    String organizationName,
    String role,
  ) => caller.callServerEndpoint<List<_i6.User>>(
    'user',
    'getFilteredUsers',
    {
      'sectionName': sectionName,
      'className': className,
      'organizationName': organizationName,
      'role': role,
    },
  );

  /// Delete a user by id.
  _i2.Future<bool> deleteUser(int id) => caller.callServerEndpoint<bool>(
    'user',
    'deleteUser',
    {'id': id},
  );

  /// Marks the user's password as created by setting isPasswordCreated to true.
  /// This method retrieves the user record for the given [userId] and updates
  /// the isPasswordCreated flag without altering the existing password.
  _i2.Future<_i6.User?> updateInitialPassword(int userId) =>
      caller.callServerEndpoint<_i6.User?>(
        'user',
        'updateInitialPassword',
        {'userId': userId},
      );

  _i2.Future<List<_i6.User>> searchUsers(
    String className,
    String sectionName,
    String organizationName,
    String query,
  ) => caller.callServerEndpoint<List<_i6.User>>(
    'user',
    'searchUsers',
    {
      'className': className,
      'sectionName': sectionName,
      'organizationName': organizationName,
      'query': query,
    },
  );
}

class Modules {
  Modules(Client client) {
    auth = _i7.Caller(client);
  }

  late final _i7.Caller auth;
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i18.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    announcement = EndpointAnnouncement(this);
    attendance = EndpointAttendance(this);
    auth = EndpointAuth(this);
    classes = EndpointClasses(this);
    course = EndpointCourse(this);
    exam = EndpointExam(this);
    notification = EndpointNotification(this);
    organization = EndpointOrganization(this);
    permission = EndpointPermission(this);
    report = EndpointReport(this);
    role = EndpointRole(this);
    section = EndpointSection(this);
    seed = EndpointSeed(this);
    settings = EndpointSettings(this);
    timetable = EndpointTimetable(this);
    transaction = EndpointTransaction(this);
    user = EndpointUser(this);
    modules = Modules(this);
  }

  late final EndpointAnnouncement announcement;

  late final EndpointAttendance attendance;

  late final EndpointAuth auth;

  late final EndpointClasses classes;

  late final EndpointCourse course;

  late final EndpointExam exam;

  late final EndpointNotification notification;

  late final EndpointOrganization organization;

  late final EndpointPermission permission;

  late final EndpointReport report;

  late final EndpointRole role;

  late final EndpointSection section;

  late final EndpointSeed seed;

  late final EndpointSettings settings;

  late final EndpointTimetable timetable;

  late final EndpointTransaction transaction;

  late final EndpointUser user;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
    'announcement': announcement,
    'attendance': attendance,
    'auth': auth,
    'classes': classes,
    'course': course,
    'exam': exam,
    'notification': notification,
    'organization': organization,
    'permission': permission,
    'report': report,
    'role': role,
    'section': section,
    'seed': seed,
    'settings': settings,
    'timetable': timetable,
    'transaction': transaction,
    'user': user,
  };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
    'auth': modules.auth,
  };
}
