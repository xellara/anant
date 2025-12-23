import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class AttendanceEndpoint extends Endpoint {
  /// Update or create a single attendance record
  Future<void> updateSingleAttendance(Session session, Attendance attendance) async {
  final existing = await Attendance.db.findFirstRow(
    session,
    where: (t) =>
        t.studentAnantId.equals(attendance.studentAnantId) &
        t.date.equals(attendance.date) &
        t.subjectName.equals(attendance.subjectName) &
        t.startTime.equals(attendance.startTime) &
        t.endTime.equals(attendance.endTime) &
        t.className.equals(attendance.className) &
        t.sectionName.equals(attendance.sectionName) &
        t.organizationName.equals(attendance.organizationName),
  );

  if (existing != null) {
    // Record exists, update it.
    attendance.id = existing.id;
    await Attendance.db.updateRow(session, attendance);
  } else {
    // Record does not exist, insert it.
    await Attendance.db.insertRow(session, attendance);
  }
  
  session.messages.postMessage('student_attendance_${attendance.studentAnantId}', attendance);
}

  /// Submit full attendance list and mark all as submitted
  Future<void> submitCompleteAttendance(Session session, List<Attendance> attendanceList) async {
    for (final attendance in attendanceList) {
      attendance.isSubmitted = true;

      final existing = await Attendance.db.findFirstRow(
        session,
        where: (t) =>
            t.studentAnantId.equals(attendance.studentAnantId) &
            t.date.equals(attendance.date) &
            t.subjectName.equals(attendance.subjectName) &
            t.startTime.equals(attendance.startTime) &
            t.endTime.equals(attendance.endTime) &
            t.className.equals(attendance.className) &
            t.sectionName.equals(attendance.sectionName) &
            t.organizationName.equals(attendance.organizationName),
      );

      if (existing != null) {
        attendance.id = existing.id;
        await Attendance.db.updateRow(session, attendance);
      } else {
        await Attendance.db.insertRow(session, attendance);
      }
      
      session.messages.postMessage('student_attendance_${attendance.studentAnantId}', attendance);
    }
  }

  /// Get attendance status for a list of userIds
  Future<Map<String, String>> getFilteredAttendanceStatus(
    Session session,
    List<String> studentAnantId,
    String subjectName,
    String startTime,
    String endTime,
    String sectionName,
    String className,
    String date,
    String organizationName,
  ) async {
    Map<String, String> statusMap = {};

    for (final userId in studentAnantId) {
      final records = await Attendance.db.find(
        session,
        where: (t) =>
            t.studentAnantId.equals(userId) &
            t.subjectName.equals(subjectName) &
            t.startTime.equals(startTime) &
            t.endTime.equals(endTime) &
            t.sectionName.equals(sectionName) &
            t.className.equals(className) &
            t.organizationName.equals(organizationName) &
            t.date.equals(date),
      );

      if (records.isEmpty) {
        statusMap[userId] = 'Absent';
      } else {
        statusMap[userId] = records.first.status;
      }
    }

    return statusMap;
  }

  /// Get all attendance records for a specific user using their Anant ID.
  Future<List<Attendance>> getUserAttendanceRecords(Session session, String studentAnantId) async {
    return await Attendance.db.find(
      session,
      where: (t) => t.studentAnantId.equals(studentAnantId),
    );
  }

  /// Stream attendance updates for a user
  Stream<Attendance> receiveAttendanceStream(
    Session session,
    String studentAnantId,
  ) async* {
    var stream = session.messages.createStream('student_attendance_$studentAnantId');
    await for (var message in stream) {
      if (message is Attendance) {
        yield message;
      }
    }
  }
}
