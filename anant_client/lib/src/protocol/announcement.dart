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

abstract class Announcement implements _i1.SerializableModel {
  Announcement._({
    this.id,
    required this.organizationId,
    required this.title,
    required this.content,
    required this.priority,
    required this.targetAudience,
    this.targetClasses,
    required this.createdBy,
    DateTime? createdAt,
    this.updatedAt,
    bool? isActive,
  })  : createdAt = createdAt ?? DateTime.now(),
        isActive = isActive ?? true;

  factory Announcement({
    int? id,
    required int organizationId,
    required String title,
    required String content,
    required String priority,
    required String targetAudience,
    String? targetClasses,
    required String createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) = _AnnouncementImpl;

  factory Announcement.fromJson(Map<String, dynamic> jsonSerialization) {
    return Announcement(
      id: jsonSerialization['id'] as int?,
      organizationId: jsonSerialization['organizationId'] as int,
      title: jsonSerialization['title'] as String,
      content: jsonSerialization['content'] as String,
      priority: jsonSerialization['priority'] as String,
      targetAudience: jsonSerialization['targetAudience'] as String,
      targetClasses: jsonSerialization['targetClasses'] as String?,
      createdBy: jsonSerialization['createdBy'] as String,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      isActive: jsonSerialization['isActive'] as bool,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int organizationId;

  String title;

  String content;

  String priority;

  String targetAudience;

  String? targetClasses;

  String createdBy;

  DateTime createdAt;

  DateTime? updatedAt;

  bool isActive;

  /// Returns a shallow copy of this [Announcement]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Announcement copyWith({
    int? id,
    int? organizationId,
    String? title,
    String? content,
    String? priority,
    String? targetAudience,
    String? targetClasses,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'organizationId': organizationId,
      'title': title,
      'content': content,
      'priority': priority,
      'targetAudience': targetAudience,
      if (targetClasses != null) 'targetClasses': targetClasses,
      'createdBy': createdBy,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AnnouncementImpl extends Announcement {
  _AnnouncementImpl({
    int? id,
    required int organizationId,
    required String title,
    required String content,
    required String priority,
    required String targetAudience,
    String? targetClasses,
    required String createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) : super._(
          id: id,
          organizationId: organizationId,
          title: title,
          content: content,
          priority: priority,
          targetAudience: targetAudience,
          targetClasses: targetClasses,
          createdBy: createdBy,
          createdAt: createdAt,
          updatedAt: updatedAt,
          isActive: isActive,
        );

  /// Returns a shallow copy of this [Announcement]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Announcement copyWith({
    Object? id = _Undefined,
    int? organizationId,
    String? title,
    String? content,
    String? priority,
    String? targetAudience,
    Object? targetClasses = _Undefined,
    String? createdBy,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    bool? isActive,
  }) {
    return Announcement(
      id: id is int? ? id : this.id,
      organizationId: organizationId ?? this.organizationId,
      title: title ?? this.title,
      content: content ?? this.content,
      priority: priority ?? this.priority,
      targetAudience: targetAudience ?? this.targetAudience,
      targetClasses:
          targetClasses is String? ? targetClasses : this.targetClasses,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
