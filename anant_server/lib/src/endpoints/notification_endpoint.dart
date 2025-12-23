import 'package:serverpod/serverpod.dart';
import 'package:anant_server/src/generated/protocol.dart';

// Endpoint for handling notifications
class NotificationEndpoint extends Endpoint {
  
  /// Get all notifications for a user
  Future<List<Notification>> getUserNotifications(
    Session session,
    String userId,
  ) async {
    try {
      // Get user to determine organization
      final users = await User.db.find(
        session,
        where: (t) => t.anantId.equals(userId),
        limit: 1,
      );
      
      if (users.isEmpty) {
        return [];
      }
      
      final orgName = users.first.organizationName;
      
      // Get organization ID
      final orgs = await Organization.db.find(
        session,
        where: (t) => t.organizationName.equals(orgName),
        limit: 1,
      );
      
      if (orgs.isEmpty) {
        return [];
      }
      
      final orgId = orgs.first.id!;
      
      // Query notifications for this user
      final notifications = await Notification.db.find(
        session,
        where: (t) => t.organizationId.equals(orgId) & t.userId.equals(userId),
        orderBy: (t) => t.timestamp,
        orderDescending: true,
      );
      
      return notifications;
    } catch (e) {
      session.log('Error fetching notifications: $e');
      return [];
    }
  }
  
  /// Mark notification as read
  Future<bool> markAsRead(
    Session session,
    int notificationId,
  ) async {
    try {
      final notifications = await Notification.db.find(
        session,
        where: (t) => t.id.equals(notificationId),
        limit: 1,
      );
      
      if (notifications.isEmpty) {
        return false;
      }
      
      final notification = notifications.first.copyWith(isRead: true);
      await Notification.db.updateRow(session, notification);
      return true;
    } catch (e) {
      session.log('Error marking notification as read: $e');
      return false;
    }
  }
  
  /// Mark all notifications as read for a user
  Future<bool> markAllAsRead(
    Session session,
    String userId,
  ) async {
    try {
      // Get user's organization
      final users = await User.db.find(
        session,
        where: (t) => t.anantId.equals(userId),
        limit: 1,
      );
      
      if (users.isEmpty) {
        return false;
      }
      
      final orgName = users.first.organizationName;
      final orgs = await Organization.db.find(
        session,
        where: (t) => t.organizationName.equals(orgName),
        limit: 1,
      );
      
      if (orgs.isEmpty) {
        return false;
      }
      
      final orgId = orgs.first.id!;
      
      // Get all unread notifications
      final notifications = await Notification.db.find(
        session,
        where: (t) => 
          t.organizationId.equals(orgId) & 
          t.userId.equals(userId) &
          t.isRead.equals(false),
      );
      
      // Mark each as read
      for (var notification in notifications) {
        final updated = notification.copyWith(isRead: true);
        await Notification.db.updateRow(session, updated);
      }
      
      return true;
    } catch (e) {
      session.log('Error marking all as read: $e');
      return false;
    }
  }
  
  /// Delete a notification
  Future<bool> deleteNotification(
    Session session,
    int notificationId,
  ) async {
    try {
      await Notification.db.deleteWhere(
        session,
        where: (t) => t.id.equals(notificationId),
      );
      return true;
    } catch (e) {
      session.log('Error deleting notification: $e');
      return false;
    }
  }
  
  /// Create a notification (for system use)
  Future<Notification?> createNotification(
    Session session,
    Notification notification,
  ) async {
    try {
      final inserted = await Notification.db.insertRow(session, notification);
      
      // Publish real-time update
      session.messages.postMessage(
        'user_notifications_${notification.userId}',
        inserted,
      );
      
      return inserted;
    } catch (e) {
      session.log('Error creating notification: $e');
      return null;
    }
  }
  
  /// Get unread count for a user
  Future<int> getUnreadCount(
    Session session,
    String userId,
  ) async {
    try {
      // Get user's organization
      final users = await User.db.find(
        session,
        where: (t) => t.anantId.equals(userId),
        limit: 1,
      );
      
      if (users.isEmpty) {
        return 0;
      }
      
      final orgName = users.first.organizationName;
      final orgs = await Organization.db.find(
        session,
        where: (t) => t.organizationName.equals(orgName),
        limit: 1,
      );
      
      if (orgs.isEmpty) {
        return 0;
      }
      
      final orgId = orgs.first.id!;
      
      // Count unread notifications
      final unreadNotifications = await Notification.db.find(
        session,
        where: (t) => 
          t.organizationId.equals(orgId) & 
          t.userId.equals(userId) &
          t.isRead.equals(false),
      );
      
      return unreadNotifications.length;
    } catch (e) {
      session.log('Error getting unread count: $e');
      return 0;
    }
  }

  /// Stream notifications for a user
  Stream<Notification> receiveNotificationStream(
    Session session,
    String userId,
  ) async* {
    var stream = session.messages.createStream('user_notifications_$userId');
    await for (var message in stream) {
      if (message is Notification) {
        yield message;
      }
    }
  }
}
