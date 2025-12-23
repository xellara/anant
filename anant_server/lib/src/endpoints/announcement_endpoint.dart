import 'package:serverpod/serverpod.dart';
import 'package:anant_server/src/generated/protocol.dart';

// Endpoint for handling announcements
class AnnouncementEndpoint extends Endpoint {
  
  /// Get all announcements for a user based on their role
  Future<List<Announcement>> getAnnouncementsForUser(
    Session session,
    String userId,
    String userRole,
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
      
      final user = users.first;
      final orgName = user.organizationName;
      
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
      
      // Query announcements based on target audience
      final announcements = await Announcement.db.find(
        session,
        where: (t) => 
          t.organizationId.equals(orgId) & 
          t.isActive.equals(true) &
          (t.targetAudience.equals('All') | t.targetAudience.equals(userRole)),
        orderBy: (t) => t.createdAt,
        orderDescending: true,
      );
      
      return announcements;
    } catch (e) {
      session.log('Error fetching announcements: $e');
      return [];
    }
  }
  
  /// Create a new announcement
  Future<Announcement?> createAnnouncement(
    Session session,
    Announcement announcement,
  ) async {
    try {
      return await Announcement.db.insertRow(session, announcement);
    } catch (e) {
      session.log('Error creating announcement: $e');
      return null;
    }
  }
  
  /// Delete an announcement
  Future<bool> deleteAnnouncement(
    Session session,
    int announcementId,
  ) async {
    try {
      await Announcement.db.deleteWhere(
        session,
        where: (t) => t.id.equals(announcementId),
      );
      return true;
    } catch (e) {
      session.log('Error deleting announcement: $e');
      return false;
    }
  }
  
  /// Update an announcement
  Future<bool> updateAnnouncement(
    Session session,
    Announcement announcement,
  ) async {
    try {
      await Announcement.db.updateRow(session, announcement);
      return true;
    } catch (e) {
      session.log('Error updating announcement: $e');
      return false;
    }
  }
}
