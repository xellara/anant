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

abstract class Notification implements _i1.SerializableModel {
  Notification._({
    this.id,
    required this.organizationId,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    this.relatedId,
    DateTime? timestamp,
    bool? isRead,
    this.data,
  })  : timestamp = timestamp ?? DateTime.now(),
        isRead = isRead ?? false;

  factory Notification({
    int? id,
    required int organizationId,
    required String userId,
    required String title,
    required String message,
    required String type,
    String? relatedId,
    DateTime? timestamp,
    bool? isRead,
    String? data,
  }) = _NotificationImpl;

  factory Notification.fromJson(Map<String, dynamic> jsonSerialization) {
    return Notification(
      id: jsonSerialization['id'] as int?,
      organizationId: jsonSerialization['organizationId'] as int,
      userId: jsonSerialization['userId'] as String,
      title: jsonSerialization['title'] as String,
      message: jsonSerialization['message'] as String,
      type: jsonSerialization['type'] as String,
      relatedId: jsonSerialization['relatedId'] as String?,
      timestamp:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['timestamp']),
      isRead: jsonSerialization['isRead'] as bool,
      data: jsonSerialization['data'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int organizationId;

  String userId;

  String title;

  String message;

  String type;

  String? relatedId;

  DateTime timestamp;

  bool isRead;

  String? data;

  /// Returns a shallow copy of this [Notification]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Notification copyWith({
    int? id,
    int? organizationId,
    String? userId,
    String? title,
    String? message,
    String? type,
    String? relatedId,
    DateTime? timestamp,
    bool? isRead,
    String? data,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'organizationId': organizationId,
      'userId': userId,
      'title': title,
      'message': message,
      'type': type,
      if (relatedId != null) 'relatedId': relatedId,
      'timestamp': timestamp.toJson(),
      'isRead': isRead,
      if (data != null) 'data': data,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationImpl extends Notification {
  _NotificationImpl({
    int? id,
    required int organizationId,
    required String userId,
    required String title,
    required String message,
    required String type,
    String? relatedId,
    DateTime? timestamp,
    bool? isRead,
    String? data,
  }) : super._(
          id: id,
          organizationId: organizationId,
          userId: userId,
          title: title,
          message: message,
          type: type,
          relatedId: relatedId,
          timestamp: timestamp,
          isRead: isRead,
          data: data,
        );

  /// Returns a shallow copy of this [Notification]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Notification copyWith({
    Object? id = _Undefined,
    int? organizationId,
    String? userId,
    String? title,
    String? message,
    String? type,
    Object? relatedId = _Undefined,
    DateTime? timestamp,
    bool? isRead,
    Object? data = _Undefined,
  }) {
    return Notification(
      id: id is int? ? id : this.id,
      organizationId: organizationId ?? this.organizationId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      relatedId: relatedId is String? ? relatedId : this.relatedId,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      data: data is String? ? data : this.data,
    );
  }
}
