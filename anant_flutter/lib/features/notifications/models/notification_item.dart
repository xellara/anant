import 'package:equatable/equatable.dart';

class NotificationItem extends Equatable {
  final String id;
  final String title;
  final String message;
  final String type; // 'fee', 'announcement', 'attendance', 'general'
  final DateTime timestamp;
  final bool isRead;
  final Map<String, dynamic>? data;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.data,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    DateTime? timestamp,
    bool? isRead,
    Map<String, dynamic>? data,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [id, title, message, type, timestamp, isRead, data];
}
