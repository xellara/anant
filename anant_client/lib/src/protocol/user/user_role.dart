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

/// Enum for user roles (RBAC)
enum UserRole implements _i1.SerializableModel {
  admin,
  teacher,
  student,
  accountant,
  parent,
  principal,
  clerk,
  librarian,
  transport,
  hostel;

  static UserRole fromJson(String name) {
    switch (name) {
      case 'admin':
        return UserRole.admin;
      case 'teacher':
        return UserRole.teacher;
      case 'student':
        return UserRole.student;
      case 'accountant':
        return UserRole.accountant;
      case 'parent':
        return UserRole.parent;
      case 'principal':
        return UserRole.principal;
      case 'clerk':
        return UserRole.clerk;
      case 'librarian':
        return UserRole.librarian;
      case 'transport':
        return UserRole.transport;
      case 'hostel':
        return UserRole.hostel;
      default:
        throw ArgumentError('Value "$name" cannot be converted to "UserRole"');
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
