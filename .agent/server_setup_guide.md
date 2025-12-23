# Server Setup - Complete Guide

## ✅ What Has Been Added

### 1. Database Models (`.spy.yaml` files)
**Location:** `d:\anant\anant_server\lib\src\models\`

- ✨ **announcement.spy.yaml** - For managing school announcements
- ✨ **notification.spy.yaml** - For user notifications

### 2. Server Endpoints
**Location:** `d:\anant\anant_server\lib\src\endpoints\`

- ✨ **announcement_endpoint.dart** - CRUD operations for announcements
- ✨ **notification_endpoint.dart** - Managing user notifications  
- ✨ **timetable_endpoint.dart** - Timetable management
- ✨ **report_endpoint.dart** - Analytics and reports

### 3. Updated Seed Data
**Location:** `d:\anant\anant_server\bin\seed_data.dart`

Added seeding logic for:
- 📢 Announcements (4 sample announcements)
- 🔔 Notifications (fee reminders + announcement notifications)

**Note:** The announcement and notification seeding code is currently commented out and will work after running `serverpod generate`.

## 🔄 Required Steps to Complete Setup

### Step 1: Generate Serverpod Code
This will create database tables and Dart classes from the `.spy.yaml` models.

```bash
cd d:\anant\anant_server
serverpod generate
```

This command will:
- ✅ Create `Announcement` and `Notification` Dart classes
- ✅ Generate database migration files
- ✅ Update `lib/src/generated/protocol.dart`
- ✅ Update `lib/src/generated/endpoints.dart`
- ✅ Generate client code in `d:\anant\anant_client`

### Step 2: Apply Database Migrations
Create the new database tables:

```bash
cd d:\anant\anant_server
serverpod create-migration
```

This will create a migration file for the new tables. Then apply it:

```bash
cd d:\anant\anant_server
dart bin/main.dart --apply-migrations
```

Or if the server is already running, restart it to apply migrations automatically.

### Step 3: Uncomment Seeding Code
After `serverpod generate` completes successfully:

1. Open `d:\anant\anant_server\bin\seed_data.dart`
2. Find the sections marked with `// Note: Commented out until...`
3. Uncomment the code blocks for:
   - **Announcements** (lines ~287-300)
   - **Notifications** (lines ~309-350)
4. Also uncomment the delete statements at the top (add these lines after line 27):
   ```dart
   await Notification.db.deleteWhere(session, where: (t) => Constant.bool(true));
   await Announcement.db.deleteWhere(session, where: (t) => Constant.bool(true));
   ```

### Step 4: Re-run Seed Data
Populate the database with all data including announcements and notifications:

```bash
cd d:\anant\anant_server
dart bin/seed_data.dart --apply-migrations
```

### Step 5: Update Flutter Packages
Get the generated client code:

```bash
cd d:\anant\anant_flutter
flutter pub get
```

### Step 6: Hot Reload Flutter App
The app should automatically pick up the new client code. If not, restart the app.

## 📊 Database Schema Summary

### Existing Tables (Already Seeded):
- ✅ **organization** - School organization data
- ✅ **user** - All user accounts (35 students, teachers, admin, etc.)
- ✅ **class** - Class information
- ✅ **subject** - Subject data (5 subjects)
- ✅ **timetable_entry** - Class schedules
- ✅ **attendance** - Attendance records (last 5 days)
- ✅ **fee_record** - Fee information for students
- ✅ **exam** - Exam schedules

### New Tables (To Be Created):
- ✨ **announcements** - School announcements with targeting
  - Fields: title, content, priority, targetAudience, targetClasses, createdBy, timestamps
  
- ✨ **notifications** - User notifications
  - Fields: userId, title, message, type, relatedId, timestamp, isRead, data

## 🎯 What Data Will Be Seeded

### Announcements (4 items):
1. **School Annual Day** (High priority, All)
2. **Winter Vacation Notice** (Normal, All)
3. **Parent-Teacher Meeting** (High, Parents)
4. **Staff Meeting** (Normal, Teachers)

### Notifications (Dynamic based on users):
- ❗ **Fee Due Notifications** - For students with pending fees
- 📢 **Announcement Notifications** - For all users about Annual Day

## 🚀 Quick Start Commands

Run these in order:

```bash
# 1. Generate code
cd d:\anant\anant_server
serverpod generate

# 2. Create migration
serverpod create-migration

# 3. Apply migrations (if server not running)
dart bin/main.dart --apply-migrations

# 4. Uncomment seeding code in seed_data.dart (manual step)

# 5. Run seeding
dart bin/seed_data.dart --apply-migrations

# 6. Update Flutter client
cd d:\anant\anant_flutter
flutter pub get

# 7. Hot reload or restart Flutter app
```

## 📝 Verification

After completing all steps, verify:

1. **Database Tables Created:**
   - Check PostgreSQL: `announcements` and `notifications` tables exist
   
2. **Data Seeded:**
   - Query: `SELECT COUNT(*) FROM announcements;` should return 4
   - Query: `SELECT COUNT(*) FROM notifications;` should return 30+ (varies by users)

3. **Flutter Client Updated:**
   - Check `d:\anant\anant_client\lib\src\protocol\` for new files
   - `announcement.dart` and `notification.dart` should exist

4. **Endpoints Available:**
   - `client.announcement.*` methods available
   - `client.notification.*` methods available

## 🔍 Troubleshooting

**If "serverpod generate" fails:**
- Check the `.spy.yaml` syntax
- Ensure Serverpod CLI is up to date: `dart pub global activate serverpod_cli`

**If migrations fail:**
- Check database connection in `config/development.yaml`
- Ensure PostgreSQL is running
- Check migration files in `migrations/` directory

**If seeding fails:**
- Check that all tables are created
- Verify the Announcement and Notification classes are imported
- Check for any foreign key constraint errors

## 🎨 Next Steps - Integration

Once setup is complete, you can start integrating in Flutter:

1. **Announcements:**
   ```dart
   final announcements = await client.announcement.getAnnouncementsForUser(userId, role);
   ```

2. **Notifications:**
   ```dart
   final notifications = await client.notification.getUserNotifications(userId);
   final unreadCount = await client.notification.getUnreadCount(userId);
   ```

3. **Update UI:**
   - Replace mock data in Flutter pages
   - Use BLoC pattern for state management
   - Add loading states and error handling

All existing seeded data (users, classes, attendance, fees, etc.) remains unchanged! 🎉
