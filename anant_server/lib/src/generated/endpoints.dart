/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../endpoints/attendance_endpoint.dart' as _i2;
import '../endpoints/auth_endpoint.dart' as _i3;
import '../endpoints/class_endpoint.dart' as _i4;
import '../endpoints/course_endpoint.dart' as _i5;
import '../endpoints/organization_endpoint.dart' as _i6;
import '../endpoints/permission_endpoint.dart' as _i7;
import '../endpoints/role_endpoint.dart' as _i8;
import '../endpoints/section_endpoint.dart' as _i9;
import '../endpoints/seed_endpoint.dart' as _i10;
import '../endpoints/settings_endpoint.dart' as _i11;
import '../endpoints/transaction_endpoint.dart' as _i12;
import '../endpoints/user_endpoint.dart' as _i13;
import 'package:anant_server/src/generated/attendance/attendance.dart' as _i14;
import 'package:anant_server/src/generated/user/user_role.dart' as _i15;
import 'package:anant_server/src/generated/user/user.dart' as _i16;
import 'package:anant_server/src/generated/attendance/class.dart' as _i17;
import 'package:anant_server/src/generated/attendance/course.dart' as _i18;
import 'package:anant_server/src/generated/auth/organization.dart' as _i19;
import 'package:anant_server/src/generated/attendance/section.dart' as _i20;
import 'package:anant_server/src/generated/transaction/montly_fee_transaction.dart'
    as _i21;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i22;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'attendance': _i2.AttendanceEndpoint()
        ..initialize(
          server,
          'attendance',
          null,
        ),
      'auth': _i3.AuthEndpoint()
        ..initialize(
          server,
          'auth',
          null,
        ),
      'classes': _i4.ClassesEndpoint()
        ..initialize(
          server,
          'classes',
          null,
        ),
      'course': _i5.CourseEndpoint()
        ..initialize(
          server,
          'course',
          null,
        ),
      'organization': _i6.OrganizationEndpoint()
        ..initialize(
          server,
          'organization',
          null,
        ),
      'permission': _i7.PermissionEndpoint()
        ..initialize(
          server,
          'permission',
          null,
        ),
      'role': _i8.RoleEndpoint()
        ..initialize(
          server,
          'role',
          null,
        ),
      'section': _i9.SectionEndpoint()
        ..initialize(
          server,
          'section',
          null,
        ),
      'seed': _i10.SeedEndpoint()
        ..initialize(
          server,
          'seed',
          null,
        ),
      'settings': _i11.SettingsEndpoint()
        ..initialize(
          server,
          'settings',
          null,
        ),
      'transaction': _i12.TransactionEndpoint()
        ..initialize(
          server,
          'transaction',
          null,
        ),
      'user': _i13.UserEndpoint()
        ..initialize(
          server,
          'user',
          null,
        ),
    };
    connectors['attendance'] = _i1.EndpointConnector(
      name: 'attendance',
      endpoint: endpoints['attendance']!,
      methodConnectors: {
        'updateSingleAttendance': _i1.MethodConnector(
          name: 'updateSingleAttendance',
          params: {
            'attendance': _i1.ParameterDescription(
              name: 'attendance',
              type: _i1.getType<_i14.Attendance>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['attendance'] as _i2.AttendanceEndpoint)
                  .updateSingleAttendance(
            session,
            params['attendance'],
          ),
        ),
        'submitCompleteAttendance': _i1.MethodConnector(
          name: 'submitCompleteAttendance',
          params: {
            'attendanceList': _i1.ParameterDescription(
              name: 'attendanceList',
              type: _i1.getType<List<_i14.Attendance>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['attendance'] as _i2.AttendanceEndpoint)
                  .submitCompleteAttendance(
            session,
            params['attendanceList'],
          ),
        ),
        'getFilteredAttendanceStatus': _i1.MethodConnector(
          name: 'getFilteredAttendanceStatus',
          params: {
            'studentAnantId': _i1.ParameterDescription(
              name: 'studentAnantId',
              type: _i1.getType<List<String>>(),
              nullable: false,
            ),
            'subjectName': _i1.ParameterDescription(
              name: 'subjectName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'startTime': _i1.ParameterDescription(
              name: 'startTime',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'endTime': _i1.ParameterDescription(
              name: 'endTime',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'sectionName': _i1.ParameterDescription(
              name: 'sectionName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'className': _i1.ParameterDescription(
              name: 'className',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'date': _i1.ParameterDescription(
              name: 'date',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'organizationName': _i1.ParameterDescription(
              name: 'organizationName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['attendance'] as _i2.AttendanceEndpoint)
                  .getFilteredAttendanceStatus(
            session,
            params['studentAnantId'],
            params['subjectName'],
            params['startTime'],
            params['endTime'],
            params['sectionName'],
            params['className'],
            params['date'],
            params['organizationName'],
          ),
        ),
        'getUserAttendanceRecords': _i1.MethodConnector(
          name: 'getUserAttendanceRecords',
          params: {
            'studentAnantId': _i1.ParameterDescription(
              name: 'studentAnantId',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['attendance'] as _i2.AttendanceEndpoint)
                  .getUserAttendanceRecords(
            session,
            params['studentAnantId'],
          ),
        ),
      },
    );
    connectors['auth'] = _i1.EndpointConnector(
      name: 'auth',
      endpoint: endpoints['auth']!,
      methodConnectors: {
        'signUp': _i1.MethodConnector(
          name: 'signUp',
          params: {
            'role': _i1.ParameterDescription(
              name: 'role',
              type: _i1.getType<_i15.UserRole>(),
              nullable: false,
            ),
            'organizationName': _i1.ParameterDescription(
              name: 'organizationName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'sectionName': _i1.ParameterDescription(
              name: 'sectionName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'admissionNumber': _i1.ParameterDescription(
              name: 'admissionNumber',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'className': _i1.ParameterDescription(
              name: 'className',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'rollNumber': _i1.ParameterDescription(
              name: 'rollNumber',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'fullName': _i1.ParameterDescription(
              name: 'fullName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'anantId': _i1.ParameterDescription(
              name: 'anantId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'profileImageUrl': _i1.ParameterDescription(
              name: 'profileImageUrl',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'mobileNumber': _i1.ParameterDescription(
              name: 'mobileNumber',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'parentMobileNumber': _i1.ParameterDescription(
              name: 'parentMobileNumber',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'address': _i1.ParameterDescription(
              name: 'address',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'city': _i1.ParameterDescription(
              name: 'city',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'state': _i1.ParameterDescription(
              name: 'state',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'country': _i1.ParameterDescription(
              name: 'country',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'pincode': _i1.ParameterDescription(
              name: 'pincode',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'dob': _i1.ParameterDescription(
              name: 'dob',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'bloodGroup': _i1.ParameterDescription(
              name: 'bloodGroup',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'aadharNumber': _i1.ParameterDescription(
              name: 'aadharNumber',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'subjectTeaching': _i1.ParameterDescription(
              name: 'subjectTeaching',
              type: _i1.getType<List<String>?>(),
              nullable: true,
            ),
            'classAndSectionTeaching': _i1.ParameterDescription(
              name: 'classAndSectionTeaching',
              type: _i1.getType<List<String>?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['auth'] as _i3.AuthEndpoint).signUp(
            session,
            params['role'],
            params['organizationName'],
            sectionName: params['sectionName'],
            admissionNumber: params['admissionNumber'],
            className: params['className'],
            rollNumber: params['rollNumber'],
            email: params['email'],
            password: params['password'],
            fullName: params['fullName'],
            anantId: params['anantId'],
            profileImageUrl: params['profileImageUrl'],
            mobileNumber: params['mobileNumber'],
            parentMobileNumber: params['parentMobileNumber'],
            address: params['address'],
            city: params['city'],
            state: params['state'],
            country: params['country'],
            pincode: params['pincode'],
            dob: params['dob'],
            bloodGroup: params['bloodGroup'],
            aadharNumber: params['aadharNumber'],
            subjectTeaching: params['subjectTeaching'],
            classAndSectionTeaching: params['classAndSectionTeaching'],
          ),
        ),
        'bulkSignUp': _i1.MethodConnector(
          name: 'bulkSignUp',
          params: {
            'userList': _i1.ParameterDescription(
              name: 'userList',
              type: _i1.getType<List<_i16.User>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['auth'] as _i3.AuthEndpoint).bulkSignUp(
            session,
            params['userList'],
          ),
        ),
        'signIn': _i1.MethodConnector(
          name: 'signIn',
          params: {
            'anantId': _i1.ParameterDescription(
              name: 'anantId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['auth'] as _i3.AuthEndpoint).signIn(
            session,
            params['anantId'],
            params['password'],
          ),
        ),
        'updateUser': _i1.MethodConnector(
          name: 'updateUser',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'newAnantId': _i1.ParameterDescription(
              name: 'newAnantId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'newEmail': _i1.ParameterDescription(
              name: 'newEmail',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'newFullName': _i1.ParameterDescription(
              name: 'newFullName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'newRole': _i1.ParameterDescription(
              name: 'newRole',
              type: _i1.getType<_i15.UserRole?>(),
              nullable: true,
            ),
            'isActive': _i1.ParameterDescription(
              name: 'isActive',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
            'newClassName': _i1.ParameterDescription(
              name: 'newClassName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'newRollNumber': _i1.ParameterDescription(
              name: 'newRollNumber',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'newAdmissionNumber': _i1.ParameterDescription(
              name: 'newAdmissionNumber',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'newSectionName': _i1.ParameterDescription(
              name: 'newSectionName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'newOrganizationName': _i1.ParameterDescription(
              name: 'newOrganizationName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'newProfileImageUrl': _i1.ParameterDescription(
              name: 'newProfileImageUrl',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'newMobileNumber': _i1.ParameterDescription(
              name: 'newMobileNumber',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'newParentMobileNumber': _i1.ParameterDescription(
              name: 'newParentMobileNumber',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'newAddress': _i1.ParameterDescription(
              name: 'newAddress',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'newCity': _i1.ParameterDescription(
              name: 'newCity',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'newState': _i1.ParameterDescription(
              name: 'newState',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'newCountry': _i1.ParameterDescription(
              name: 'newCountry',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'newPincode': _i1.ParameterDescription(
              name: 'newPincode',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'newDob': _i1.ParameterDescription(
              name: 'newDob',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'newBloodGroup': _i1.ParameterDescription(
              name: 'newBloodGroup',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'newAadharNumber': _i1.ParameterDescription(
              name: 'newAadharNumber',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'newSubjectTeaching': _i1.ParameterDescription(
              name: 'newSubjectTeaching',
              type: _i1.getType<List<String>?>(),
              nullable: true,
            ),
            'newClassAndSectionTeaching': _i1.ParameterDescription(
              name: 'newClassAndSectionTeaching',
              type: _i1.getType<List<String>?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['auth'] as _i3.AuthEndpoint).updateUser(
            session,
            params['userId'],
            newAnantId: params['newAnantId'],
            newPassword: params['newPassword'],
            newEmail: params['newEmail'],
            newFullName: params['newFullName'],
            newRole: params['newRole'],
            isActive: params['isActive'],
            newClassName: params['newClassName'],
            newRollNumber: params['newRollNumber'],
            newAdmissionNumber: params['newAdmissionNumber'],
            newSectionName: params['newSectionName'],
            newOrganizationName: params['newOrganizationName'],
            newProfileImageUrl: params['newProfileImageUrl'],
            newMobileNumber: params['newMobileNumber'],
            newParentMobileNumber: params['newParentMobileNumber'],
            newAddress: params['newAddress'],
            newCity: params['newCity'],
            newState: params['newState'],
            newCountry: params['newCountry'],
            newPincode: params['newPincode'],
            newDob: params['newDob'],
            newBloodGroup: params['newBloodGroup'],
            newAadharNumber: params['newAadharNumber'],
            newSubjectTeaching: params['newSubjectTeaching'],
            newClassAndSectionTeaching: params['newClassAndSectionTeaching'],
          ),
        ),
        'deleteUser': _i1.MethodConnector(
          name: 'deleteUser',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['auth'] as _i3.AuthEndpoint).deleteUser(
            session,
            params['userId'],
          ),
        ),
      },
    );
    connectors['classes'] = _i1.EndpointConnector(
      name: 'classes',
      endpoint: endpoints['classes']!,
      methodConnectors: {
        'createClasses': _i1.MethodConnector(
          name: 'createClasses',
          params: {
            'cls': _i1.ParameterDescription(
              name: 'cls',
              type: _i1.getType<_i17.Classes>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['classes'] as _i4.ClassesEndpoint).createClasses(
            session,
            params['cls'],
          ),
        ),
        'getClasses': _i1.MethodConnector(
          name: 'getClasses',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['classes'] as _i4.ClassesEndpoint).getClasses(
            session,
            params['id'],
          ),
        ),
        'getAllClasseses': _i1.MethodConnector(
          name: 'getAllClasseses',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['classes'] as _i4.ClassesEndpoint)
                  .getAllClasseses(session),
        ),
        'deleteClasses': _i1.MethodConnector(
          name: 'deleteClasses',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['classes'] as _i4.ClassesEndpoint).deleteClasses(
            session,
            params['id'],
          ),
        ),
      },
    );
    connectors['course'] = _i1.EndpointConnector(
      name: 'course',
      endpoint: endpoints['course']!,
      methodConnectors: {
        'createCourse': _i1.MethodConnector(
          name: 'createCourse',
          params: {
            'course': _i1.ParameterDescription(
              name: 'course',
              type: _i1.getType<_i18.Course>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['course'] as _i5.CourseEndpoint).createCourse(
            session,
            params['course'],
          ),
        ),
        'getCourse': _i1.MethodConnector(
          name: 'getCourse',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['course'] as _i5.CourseEndpoint).getCourse(
            session,
            params['id'],
          ),
        ),
        'getAllCourses': _i1.MethodConnector(
          name: 'getAllCourses',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['course'] as _i5.CourseEndpoint)
                  .getAllCourses(session),
        ),
        'deleteCourse': _i1.MethodConnector(
          name: 'deleteCourse',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['course'] as _i5.CourseEndpoint).deleteCourse(
            session,
            params['id'],
          ),
        ),
      },
    );
    connectors['organization'] = _i1.EndpointConnector(
      name: 'organization',
      endpoint: endpoints['organization']!,
      methodConnectors: {
        'createOrganization': _i1.MethodConnector(
          name: 'createOrganization',
          params: {
            'org': _i1.ParameterDescription(
              name: 'org',
              type: _i1.getType<_i19.Organization>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['organization'] as _i6.OrganizationEndpoint)
                  .createOrganization(
            session,
            params['org'],
          ),
        ),
        'getOrganization': _i1.MethodConnector(
          name: 'getOrganization',
          params: {
            'organizationName': _i1.ParameterDescription(
              name: 'organizationName',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['organization'] as _i6.OrganizationEndpoint)
                  .getOrganization(
            session,
            params['organizationName'],
          ),
        ),
        'getAllOrganizations': _i1.MethodConnector(
          name: 'getAllOrganizations',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['organization'] as _i6.OrganizationEndpoint)
                  .getAllOrganizations(session),
        ),
        'deleteOrganization': _i1.MethodConnector(
          name: 'deleteOrganization',
          params: {
            'organizationName': _i1.ParameterDescription(
              name: 'organizationName',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['organization'] as _i6.OrganizationEndpoint)
                  .deleteOrganization(
            session,
            params['organizationName'],
          ),
        ),
      },
    );
    connectors['permission'] = _i1.EndpointConnector(
      name: 'permission',
      endpoint: endpoints['permission']!,
      methodConnectors: {
        'createPermission': _i1.MethodConnector(
          name: 'createPermission',
          params: {
            'slug': _i1.ParameterDescription(
              name: 'slug',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'module': _i1.ParameterDescription(
              name: 'module',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['permission'] as _i7.PermissionEndpoint)
                  .createPermission(
            session,
            params['slug'],
            params['description'],
            params['module'],
          ),
        ),
        'getAllPermissions': _i1.MethodConnector(
          name: 'getAllPermissions',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['permission'] as _i7.PermissionEndpoint)
                  .getAllPermissions(session),
        ),
        'getPermissionsByModule': _i1.MethodConnector(
          name: 'getPermissionsByModule',
          params: {
            'module': _i1.ParameterDescription(
              name: 'module',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['permission'] as _i7.PermissionEndpoint)
                  .getPermissionsByModule(
            session,
            params['module'],
          ),
        ),
        'updatePermission': _i1.MethodConnector(
          name: 'updatePermission',
          params: {
            'permissionId': _i1.ParameterDescription(
              name: 'permissionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'module': _i1.ParameterDescription(
              name: 'module',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['permission'] as _i7.PermissionEndpoint)
                  .updatePermission(
            session,
            params['permissionId'],
            params['description'],
            params['module'],
          ),
        ),
        'deletePermission': _i1.MethodConnector(
          name: 'deletePermission',
          params: {
            'permissionId': _i1.ParameterDescription(
              name: 'permissionId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['permission'] as _i7.PermissionEndpoint)
                  .deletePermission(
            session,
            params['permissionId'],
          ),
        ),
        'initializeDefaultPermissions': _i1.MethodConnector(
          name: 'initializeDefaultPermissions',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['permission'] as _i7.PermissionEndpoint)
                  .initializeDefaultPermissions(session),
        ),
      },
    );
    connectors['role'] = _i1.EndpointConnector(
      name: 'role',
      endpoint: endpoints['role']!,
      methodConnectors: {
        'createRole': _i1.MethodConnector(
          name: 'createRole',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'slug': _i1.ParameterDescription(
              name: 'slug',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'organizationName': _i1.ParameterDescription(
              name: 'organizationName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'isSystemRole': _i1.ParameterDescription(
              name: 'isSystemRole',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['role'] as _i8.RoleEndpoint).createRole(
            session,
            params['name'],
            params['slug'],
            params['description'],
            params['organizationName'],
            params['isSystemRole'],
          ),
        ),
        'getRoles': _i1.MethodConnector(
          name: 'getRoles',
          params: {
            'organizationName': _i1.ParameterDescription(
              name: 'organizationName',
              type: _i1.getType<String?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['role'] as _i8.RoleEndpoint).getRoles(
            session,
            organizationName: params['organizationName'],
          ),
        ),
        'updateRole': _i1.MethodConnector(
          name: 'updateRole',
          params: {
            'roleId': _i1.ParameterDescription(
              name: 'roleId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['role'] as _i8.RoleEndpoint).updateRole(
            session,
            params['roleId'],
            params['name'],
            params['description'],
          ),
        ),
        'deleteRole': _i1.MethodConnector(
          name: 'deleteRole',
          params: {
            'roleId': _i1.ParameterDescription(
              name: 'roleId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['role'] as _i8.RoleEndpoint).deleteRole(
            session,
            params['roleId'],
          ),
        ),
        'assignPermission': _i1.MethodConnector(
          name: 'assignPermission',
          params: {
            'roleId': _i1.ParameterDescription(
              name: 'roleId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'permissionId': _i1.ParameterDescription(
              name: 'permissionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['role'] as _i8.RoleEndpoint).assignPermission(
            session,
            params['roleId'],
            params['permissionId'],
          ),
        ),
        'removePermission': _i1.MethodConnector(
          name: 'removePermission',
          params: {
            'roleId': _i1.ParameterDescription(
              name: 'roleId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'permissionId': _i1.ParameterDescription(
              name: 'permissionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['role'] as _i8.RoleEndpoint).removePermission(
            session,
            params['roleId'],
            params['permissionId'],
          ),
        ),
        'getPermissionsForRole': _i1.MethodConnector(
          name: 'getPermissionsForRole',
          params: {
            'roleId': _i1.ParameterDescription(
              name: 'roleId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['role'] as _i8.RoleEndpoint).getPermissionsForRole(
            session,
            params['roleId'],
          ),
        ),
      },
    );
    connectors['section'] = _i1.EndpointConnector(
      name: 'section',
      endpoint: endpoints['section']!,
      methodConnectors: {
        'createSection': _i1.MethodConnector(
          name: 'createSection',
          params: {
            'section': _i1.ParameterDescription(
              name: 'section',
              type: _i1.getType<_i20.Section>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['section'] as _i9.SectionEndpoint).createSection(
            session,
            params['section'],
          ),
        ),
        'getSection': _i1.MethodConnector(
          name: 'getSection',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['section'] as _i9.SectionEndpoint).getSection(
            session,
            params['id'],
          ),
        ),
        'getAllSections': _i1.MethodConnector(
          name: 'getAllSections',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['section'] as _i9.SectionEndpoint)
                  .getAllSections(session),
        ),
        'deleteSection': _i1.MethodConnector(
          name: 'deleteSection',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['section'] as _i9.SectionEndpoint).deleteSection(
            session,
            params['id'],
          ),
        ),
      },
    );
    connectors['seed'] = _i1.EndpointConnector(
      name: 'seed',
      endpoint: endpoints['seed']!,
      methodConnectors: {
        'seedDatabase': _i1.MethodConnector(
          name: 'seedDatabase',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['seed'] as _i10.SeedEndpoint).seedDatabase(session),
        )
      },
    );
    connectors['settings'] = _i1.EndpointConnector(
      name: 'settings',
      endpoint: endpoints['settings']!,
      methodConnectors: {
        'getSettings': _i1.MethodConnector(
          name: 'getSettings',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['settings'] as _i11.SettingsEndpoint)
                  .getSettings(session),
        ),
        'updateSettings': _i1.MethodConnector(
          name: 'updateSettings',
          params: {
            'enabledModules': _i1.ParameterDescription(
              name: 'enabledModules',
              type: _i1.getType<List<String>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['settings'] as _i11.SettingsEndpoint).updateSettings(
            session,
            params['enabledModules'],
          ),
        ),
      },
    );
    connectors['transaction'] = _i1.EndpointConnector(
      name: 'transaction',
      endpoint: endpoints['transaction']!,
      methodConnectors: {
        'createMonthlyFeeTransaction': _i1.MethodConnector(
          name: 'createMonthlyFeeTransaction',
          params: {
            'txn': _i1.ParameterDescription(
              name: 'txn',
              type: _i1.getType<_i21.MonthlyFeeTransaction>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['transaction'] as _i12.TransactionEndpoint)
                  .createMonthlyFeeTransaction(
            session,
            params['txn'],
          ),
        ),
        'getMonthlyFeeTransaction': _i1.MethodConnector(
          name: 'getMonthlyFeeTransaction',
          params: {
            'month': _i1.ParameterDescription(
              name: 'month',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'anantId': _i1.ParameterDescription(
              name: 'anantId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['transaction'] as _i12.TransactionEndpoint)
                  .getMonthlyFeeTransaction(
            session,
            params['month'],
            params['anantId'],
          ),
        ),
        'getAllMonthlyFeeTransactionUser': _i1.MethodConnector(
          name: 'getAllMonthlyFeeTransactionUser',
          params: {
            'anantId': _i1.ParameterDescription(
              name: 'anantId',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['transaction'] as _i12.TransactionEndpoint)
                  .getAllMonthlyFeeTransactionUser(
            session,
            params['anantId'],
          ),
        ),
        'getAllMonthlyFeeTransactionOrg': _i1.MethodConnector(
          name: 'getAllMonthlyFeeTransactionOrg',
          params: {
            'organizationName': _i1.ParameterDescription(
              name: 'organizationName',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['transaction'] as _i12.TransactionEndpoint)
                  .getAllMonthlyFeeTransactionOrg(
            session,
            params['organizationName'],
          ),
        ),
        'deleteMonthlyFeeTransaction': _i1.MethodConnector(
          name: 'deleteMonthlyFeeTransaction',
          params: {
            'month': _i1.ParameterDescription(
              name: 'month',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'anantId': _i1.ParameterDescription(
              name: 'anantId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['transaction'] as _i12.TransactionEndpoint)
                  .deleteMonthlyFeeTransaction(
            session,
            params['month'],
            params['anantId'],
          ),
        ),
      },
    );
    connectors['user'] = _i1.EndpointConnector(
      name: 'user',
      endpoint: endpoints['user']!,
      methodConnectors: {
        'me': _i1.MethodConnector(
          name: 'me',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['user'] as _i13.UserEndpoint).me(
            session,
            params['userId'],
          ),
        ),
        'getByAnantId': _i1.MethodConnector(
          name: 'getByAnantId',
          params: {
            'anantId': _i1.ParameterDescription(
              name: 'anantId',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['user'] as _i13.UserEndpoint).getByAnantId(
            session,
            params['anantId'],
          ),
        ),
        'getAllUsers': _i1.MethodConnector(
          name: 'getAllUsers',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['user'] as _i13.UserEndpoint).getAllUsers(session),
        ),
        'getFilteredUsers': _i1.MethodConnector(
          name: 'getFilteredUsers',
          params: {
            'sectionName': _i1.ParameterDescription(
              name: 'sectionName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'className': _i1.ParameterDescription(
              name: 'className',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'organizationName': _i1.ParameterDescription(
              name: 'organizationName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'role': _i1.ParameterDescription(
              name: 'role',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['user'] as _i13.UserEndpoint).getFilteredUsers(
            session,
            params['sectionName'],
            params['className'],
            params['organizationName'],
            params['role'],
          ),
        ),
        'deleteUser': _i1.MethodConnector(
          name: 'deleteUser',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['user'] as _i13.UserEndpoint).deleteUser(
            session,
            params['id'],
          ),
        ),
        'updateInitialPassword': _i1.MethodConnector(
          name: 'updateInitialPassword',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['user'] as _i13.UserEndpoint).updateInitialPassword(
            session,
            params['userId'],
          ),
        ),
        'searchUsers': _i1.MethodConnector(
          name: 'searchUsers',
          params: {
            'className': _i1.ParameterDescription(
              name: 'className',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'sectionName': _i1.ParameterDescription(
              name: 'sectionName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'organizationName': _i1.ParameterDescription(
              name: 'organizationName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['user'] as _i13.UserEndpoint).searchUsers(
            session,
            params['className'],
            params['sectionName'],
            params['organizationName'],
            params['query'],
          ),
        ),
      },
    );
    modules['serverpod_auth'] = _i22.Endpoints()..initializeEndpoints(server);
  }
}
