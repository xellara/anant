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

abstract class UserCredentials implements _i1.SerializableModel {
  UserCredentials._({
    this.id,
    required this.uid,
    this.userId,
    required this.passwordHash,
    this.anantId,
    this.createdAt,
    this.updatedAt,
  });

  factory UserCredentials({
    int? id,
    required String uid,
    int? userId,
    required String passwordHash,
    String? anantId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserCredentialsImpl;

  factory UserCredentials.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserCredentials(
      id: jsonSerialization['id'] as int?,
      uid: jsonSerialization['uid'] as String,
      userId: jsonSerialization['userId'] as int?,
      passwordHash: jsonSerialization['passwordHash'] as String,
      anantId: jsonSerialization['anantId'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String uid;

  int? userId;

  String passwordHash;

  String? anantId;

  DateTime? createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [UserCredentials]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserCredentials copyWith({
    int? id,
    String? uid,
    int? userId,
    String? passwordHash,
    String? anantId,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'uid': uid,
      if (userId != null) 'userId': userId,
      'passwordHash': passwordHash,
      if (anantId != null) 'anantId': anantId,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserCredentialsImpl extends UserCredentials {
  _UserCredentialsImpl({
    int? id,
    required String uid,
    int? userId,
    required String passwordHash,
    String? anantId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
          id: id,
          uid: uid,
          userId: userId,
          passwordHash: passwordHash,
          anantId: anantId,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Returns a shallow copy of this [UserCredentials]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserCredentials copyWith({
    Object? id = _Undefined,
    String? uid,
    Object? userId = _Undefined,
    String? passwordHash,
    Object? anantId = _Undefined,
    Object? createdAt = _Undefined,
    Object? updatedAt = _Undefined,
  }) {
    return UserCredentials(
      id: id is int? ? id : this.id,
      uid: uid ?? this.uid,
      userId: userId is int? ? userId : this.userId,
      passwordHash: passwordHash ?? this.passwordHash,
      anantId: anantId is String? ? anantId : this.anantId,
      createdAt: createdAt is DateTime? ? createdAt : this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}
