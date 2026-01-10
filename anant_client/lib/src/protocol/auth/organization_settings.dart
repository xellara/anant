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
import 'package:anant_client/src/protocol/protocol.dart' as _i2;

abstract class OrganizationSettings implements _i1.SerializableModel {
  OrganizationSettings._({
    this.id,
    required this.organizationName,
    required this.enabledModules,
  });

  factory OrganizationSettings({
    int? id,
    required String organizationName,
    required List<String> enabledModules,
  }) = _OrganizationSettingsImpl;

  factory OrganizationSettings.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return OrganizationSettings(
      id: jsonSerialization['id'] as int?,
      organizationName: jsonSerialization['organizationName'] as String,
      enabledModules: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['enabledModules'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String organizationName;

  List<String> enabledModules;

  /// Returns a shallow copy of this [OrganizationSettings]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OrganizationSettings copyWith({
    int? id,
    String? organizationName,
    List<String>? enabledModules,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OrganizationSettings',
      if (id != null) 'id': id,
      'organizationName': organizationName,
      'enabledModules': enabledModules.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrganizationSettingsImpl extends OrganizationSettings {
  _OrganizationSettingsImpl({
    int? id,
    required String organizationName,
    required List<String> enabledModules,
  }) : super._(
         id: id,
         organizationName: organizationName,
         enabledModules: enabledModules,
       );

  /// Returns a shallow copy of this [OrganizationSettings]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OrganizationSettings copyWith({
    Object? id = _Undefined,
    String? organizationName,
    List<String>? enabledModules,
  }) {
    return OrganizationSettings(
      id: id is int? ? id : this.id,
      organizationName: organizationName ?? this.organizationName,
      enabledModules:
          enabledModules ?? this.enabledModules.map((e0) => e0).toList(),
    );
  }
}
