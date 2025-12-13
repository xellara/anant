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

/// External Authentication Provider Mapping
/// Maps external provider UIDs (Firebase, Google, etc.) to internal UID
abstract class ExternalAuthProvider implements _i1.SerializableModel {
  ExternalAuthProvider._({
    this.id,
    required this.uid,
    required this.provider,
    required this.providerUid,
    this.providerEmail,
    this.metadata,
    this.createdAt,
    this.updatedAt,
  });

  factory ExternalAuthProvider({
    int? id,
    required String uid,
    required String provider,
    required String providerUid,
    String? providerEmail,
    String? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ExternalAuthProviderImpl;

  factory ExternalAuthProvider.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ExternalAuthProvider(
      id: jsonSerialization['id'] as int?,
      uid: jsonSerialization['uid'] as String,
      provider: jsonSerialization['provider'] as String,
      providerUid: jsonSerialization['providerUid'] as String,
      providerEmail: jsonSerialization['providerEmail'] as String?,
      metadata: jsonSerialization['metadata'] as String?,
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

  String provider;

  String providerUid;

  String? providerEmail;

  String? metadata;

  DateTime? createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [ExternalAuthProvider]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ExternalAuthProvider copyWith({
    int? id,
    String? uid,
    String? provider,
    String? providerUid,
    String? providerEmail,
    String? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'uid': uid,
      'provider': provider,
      'providerUid': providerUid,
      if (providerEmail != null) 'providerEmail': providerEmail,
      if (metadata != null) 'metadata': metadata,
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

class _ExternalAuthProviderImpl extends ExternalAuthProvider {
  _ExternalAuthProviderImpl({
    int? id,
    required String uid,
    required String provider,
    required String providerUid,
    String? providerEmail,
    String? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
          id: id,
          uid: uid,
          provider: provider,
          providerUid: providerUid,
          providerEmail: providerEmail,
          metadata: metadata,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Returns a shallow copy of this [ExternalAuthProvider]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ExternalAuthProvider copyWith({
    Object? id = _Undefined,
    String? uid,
    String? provider,
    String? providerUid,
    Object? providerEmail = _Undefined,
    Object? metadata = _Undefined,
    Object? createdAt = _Undefined,
    Object? updatedAt = _Undefined,
  }) {
    return ExternalAuthProvider(
      id: id is int? ? id : this.id,
      uid: uid ?? this.uid,
      provider: provider ?? this.provider,
      providerUid: providerUid ?? this.providerUid,
      providerEmail:
          providerEmail is String? ? providerEmail : this.providerEmail,
      metadata: metadata is String? ? metadata : this.metadata,
      createdAt: createdAt is DateTime? ? createdAt : this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}
