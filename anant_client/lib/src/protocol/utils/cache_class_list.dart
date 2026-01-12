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
import '../attendance/class.dart' as _i2;
import 'package:anant_client/src/protocol/protocol.dart' as _i3;

abstract class ClassListContainer implements _i1.SerializableModel {
  ClassListContainer._({required this.classes});

  factory ClassListContainer({required List<_i2.Classes> classes}) =
      _ClassListContainerImpl;

  factory ClassListContainer.fromJson(Map<String, dynamic> jsonSerialization) {
    return ClassListContainer(
      classes: _i3.Protocol().deserialize<List<_i2.Classes>>(
        jsonSerialization['classes'],
      ),
    );
  }

  List<_i2.Classes> classes;

  /// Returns a shallow copy of this [ClassListContainer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ClassListContainer copyWith({List<_i2.Classes>? classes});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ClassListContainer',
      'classes': classes.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ClassListContainerImpl extends ClassListContainer {
  _ClassListContainerImpl({required List<_i2.Classes> classes})
    : super._(classes: classes);

  /// Returns a shallow copy of this [ClassListContainer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ClassListContainer copyWith({List<_i2.Classes>? classes}) {
    return ClassListContainer(
      classes: classes ?? this.classes.map((e0) => e0.copyWith()).toList(),
    );
  }
}
