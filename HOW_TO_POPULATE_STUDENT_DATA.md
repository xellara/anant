# How to Populate Student Data (Attendance, Timetable, Exams)

Since the student features now fetch real data from the database, you need to populate the tables with test data to see them in the app.

## Prerequisites
1. Ensure the Server is running.
2. Ensure you have a User (Student) to test with.
   - Note their `anantId` (e.g., `STU001`).
   - Note their `className` (e.g., `Class 10-A`).

## 1. Populate Class and Subjects (if not exists)
You need `Class` and `Subject` entries because Timetable and Exams link to them.

- **Create Class:**
  - Table: `class`
  - Columns: `name` ('Class 10-A'), `academicYear` ('2024-25'), `organizationId`.
- **Create Subjects:**
  - Table: `subject`
  - Columns: `name` ('Mathematics', 'Science', ...), `organizationId`.
- **Note IDs:**
  - Get `id` of the created Class (e.g., `1`).
  - Get `id`s of created Subjects (e.g., Math=`1`, Science=`2`).

## 2. Populate Timetable
Timetable entries determine the schedule displayed on the Timetable page.

- **Table:** `time_table_entry`
- **Columns:**
  - `classId`: ID of the student's class (e.g., `1`).
  - `subjectId`: ID of the subject (e.g., `1`).
  - `teacherId`: ID of a Teacher user (create a dummy teacher if needed and get their ID).
  - `dayOfWeek`: `1` (Monday) to `7` (Sunday).
  - `startTime`: timestamp (date part ignored usually, but set a valid datetime e.g. '2025-01-01 09:00:00').
  - `durationMinutes`: `60` (1 hour).
  - `organizationId`.

**Example SQL (PostgreSQL):**
```sql
-- Monday 9:00 AM Math
INSERT INTO time_table_entry ("classId", "subjectId", "teacherId", "dayOfWeek", "startTime", "durationMinutes", "organizationId")
VALUES (1, 1, 2, 1, '2025-01-01 09:00:00', 60, 1);

-- Monday 10:00 AM Science
INSERT INTO time_table_entry ("classId", "subjectId", "teacherId", "dayOfWeek", "startTime", "durationMinutes", "organizationId")
VALUES (1, 2, 2, 1, '2025-01-01 10:00:00', 60, 1);
```

## 3. Populate Exams
Exams appear on the Exam Schedule page.

- **Table:** `exam`
- **Columns:**
  - `classId`: ID of the student's class (e.g., `1`).
  - `subjectId`: ID of the subject.
  - `name`: Name of exam (e.g. 'Midterm', 'Finals').
  - `date`: Timestamp of exam (e.g. '2025-05-10 09:00:00').
  - `totalMarks`: e.g. `100`.
  - `organizationId`.

**Example SQL:**
```sql
INSERT INTO exam ("classId", "subjectId", "name", "date", "totalMarks", "organizationId")
VALUES (1, 1, 'Math Midterm', '2025-05-15 09:00:00', 100, 1);
```

## 4. Populate Attendance
Attendance records show up in the Attendance page.

- **Table:** `attendance`
- **Columns:**
  - `studentAnantId`: The student's ID (e.g. 'STU001').
  - `subjectName`: 'Mathematics' (Should match subject name).
  - `status`: 'Present' or 'Absent'.
  - `date`: String 'YYYY-MM-DD' (e.g. '2025-05-01').
  - `startTime`, `endTime`: String (e.g. '09:00', '10:00').
  - `markedByAnantId`: Teacher's Anant ID.
  - `organizationName`.

**Example SQL:**
```sql
INSERT INTO attendance ("studentAnantId", "subjectName", "status", "date", "startTime", "endTime", "markedByAnantId", "organizationName")
VALUES ('STU001', 'Mathematics', 'Present', '2025-05-01', '09:00', '10:00', 'TCH001', 'Anant School');
```

## 5. Populate Notifications
Notifications appear in the Notification bell icon.

- **Table:** `notification`
- **Columns:**
  - `title`: e.g. 'Class Cancelled'.
  - `message`: Details.
  - `type`: 'announcement', 'fee', 'attendance', or 'info'.
  - `timestamp`: Current time.
  - `isRead`: `false` for unread.
  - `userId`: The student's Anant ID (e.g. 'STU001').

**Example SQL:**
```sql
INSERT INTO notification ("title", "message", "type", "timestamp", "isRead", "userId")
VALUES ('Welcome', 'Welcome to the school app!', 'info', '2025-01-01 10:00:00', false, 'STU001');
```
