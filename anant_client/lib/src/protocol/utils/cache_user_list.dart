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
import '../user/user.dart' as _i2;
import 'package:anant_client/src/protocol/protocol.dart' as _i3;

abstract class UserListContainer implements _i1.SerializableModel {
  UserListContainer._({required this.users});

  factory UserListContainer({required List<_i2.User> users}) =
      _UserListContainerImpl;

  factory UserListContainer.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserListContainer(
      users: _i3.Protocol().deserialize<List<_i2.User>>(
        jsonSerialization['users'],
      ),
    );
  }

  List<_i2.User> users;

  /// Returns a shallow copy of this [UserListContainer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserListContainer copyWith({List<_i2.User>? users});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserListContainer',
      'users': users.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _UserListContainerImpl extends UserListContainer {
  _UserListContainerImpl({required List<_i2.User> users})
    : super._(users: users);

  /// Returns a shallow copy of this [UserListContainer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserListContainer copyWith({List<_i2.User>? users}) {
    return UserListContainer(
      users: users ?? this.users.map((e0) => e0.copyWith()).toList(),
    );
  }
}
