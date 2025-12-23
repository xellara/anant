# Making Anant App Fully Dynamic - Server Integration Guide

## Overview
This document outlines the steps to replace all mock data with real server data throughout the Anant Flutter application.

## Available Server Endpoints

Based on the server structure, we have the following endpoints:
1. **User Endpoint** - User management (CRUD operations)
2. **Class Endpoint** - Class and grade management
3. **Section Endpoint** - Section management
4. **Course Endpoint** - Course management
5. **Attendance Endpoint** - Attendance records
6. **Transaction Endpoint** - Fee transactions
7. **Settings Endpoint** - Organization settings
8. **Organization Endpoint** - Organization management
9. **Auth Endpoint** - Authentication
10. **Role Endpoint** - Role management
11. **Permission Endpoint** - Permission management

## Implementation Roadmap

### Phase 1: Core Infrastructure
- [ ] Set up Serverpod client configuration
- [ ] Create service layer for each domain
- [ ] Implement error handling and loading states
- [ ] Set up state management (BLoC/Cubit)

### Phase 2: User Management
**Files to Update:**
- `lib/features/admin/pages/manage_users_page.dart`
- Create: `lib/features/users/domain/repositories/user_repository.dart`
- Create: `lib/features/users/data/repositories/user_repository_impl.dart`
- Create: `lib/features/users/presentation/bloc/user_bloc.dart`

**API Integration:**
```dart
// Get all users
final users = await client.user.getAllUsers();

// Add user
await client.user.createUser(user);

// Update user
await client.user.updateUser(userId, userData);

// Delete user
await client.user.deleteUser(userId);
```

### Phase 3: Class Management
**Files to Update:**
- `lib/features/admin/pages/manage_classes_page.dart`
- Create: `lib/features/classes/domain/repositories/class_repository.dart`
- Create: `lib/features/classes/data/repositories/class_repository_impl.dart`
- Create: `lib/features/classes/presentation/bloc/class_bloc.dart`

**API Integration:**
```dart
// Get all classes
final classes = await client.class.getAllClasses();

// Create class
await client.class.createClass(classData);

// Update class
await client.class.updateClass(classId, classData);

// Delete class
await client.class.deleteClass(classId);

// Get sections for a class
final sections = await client.section.getSectionsByClass(classId);
```

### Phase 4: Attendance System
**Files to Update:**
- `lib/features/attendance/attendance.dart`
- `lib/features/student_attendance/presentation/pages/student_attendance_page.dart`
- `lib/features/student_attendance/data/repositories/student_attendance_repository_impl.dart`

**API Integration:**
```dart
// Get attendance summary
final summary = await client.attendance.getAttendanceSummary(userId);

// Mark attendance
await client.attendance.markAttendance(attendanceData);

// Get attendance by date range
final records = await client.attendance.getAttendanceByDateRange(userId, startDate, endDate);
```

### Phase 5: Fee/Transaction System
**Files to Update:**
- `lib/fee_screen.dart`
- `lib/features/transaction/monthly_fee_list_screen.dart`
- `lib/features/transaction/payment_gateway_page.dart`

**API Integration:**
```dart
// Get pending fees
final pendingFees = await client.transaction.getPendingFees(studentId);

// Get payment history
final history = await client.transaction.getPaymentHistory(studentId);

// Process payment
await client.transaction.processPayment(paymentData);
```

### Phase 6: Announcements
**Files to Update:**
- `lib/features/announcements/presentation/pages/announcement_page.dart`
- `lib/features/announcements/presentation/pages/create_announcement_page.dart`
- Create: `lib/features/announcements/domain/repositories/announcement_repository.dart`
- Create: `lib/features/announcements/data/repositories/announcement_repository_impl.dart`
- Create: `lib/features/announcements/presentation/bloc/announcement_bloc.dart`

**API Integration:**
```dart
// Get announcements
final announcements = await client.announcement.getAnnouncements(userId, role);

// Create announcement
await client.announcement.createAnnouncement(announcementData);

// Delete announcement
await client.announcement.deleteAnnouncement(announcementId);
```

### Phase 7: Notifications
**Files to Update:**
- `lib/features/notifications/presentation/pages/notifications_page.dart`
- Create: `lib/features/notifications/domain/repositories/notification_repository.dart`
- Create: `lib/features/notifications/data/repositories/notification_repository_impl.dart`
- Create: `lib/features/notifications/presentation/bloc/notification_bloc.dart`

**API Integration:**
```dart
// Get notifications
final notifications = await client.notification.getUserNotifications(userId);

// Mark as read
await client.notification.markAsRead(notificationId);

// Delete notification
await client.notification.deleteNotification(notificationId);
```

### Phase 8: System Settings
**Files to Update:**
- `lib/features/admin/pages/system_settings_page.dart`

**API Integration:**
```dart
// Get organization settings
final settings = await client.settings.getOrganizationSettings(orgId);

// Update settings
await client.settings.updateSettings(settingsData);
```

### Phase 9: Reports & Analytics
**Files to Update:**
- `lib/features/admin/pages/reports_page.dart`
- Create: `lib/features/reports/domain/repositories/report_repository.dart`
- Create: `lib/features/reports/data/repositories/report_repository_impl.dart`

**API Integration:**
```dart
// Get revenue report
final revenueData = await client.reports.getRevenueReport(startDate, endDate);

// Get attendance report
final attendanceData = await client.reports.getAttendanceReport(period);

// Get student statistics
final stats = await client.reports.getStudentStatistics();
```

### Phase 10: Timetable
**Files to Update:**
- `lib/features/timetable/data/repositories/timetable_repository_impl.dart`

**API Integration:**
```dart
// Get timetable
final timetable = await client.timetable.getTimetable(userId, role);
```

## Implementation Steps for Each Feature

### 1. Create Domain Layer
```dart
// Example: User Repository Interface
abstract class UserRepository {
  Future<List<User>> getAllUsers();
  Future<User> getUserById(String id);
  Future<void> createUser(User user);
  Future<void> updateUser(String id, User user);
  Future<void> deleteUser(String id);
}
```

### 2. Create Data Layer
```dart
// Example: User Repository Implementation
class UserRepositoryImpl implements UserRepository {
  final Client client;
  
  UserRepositoryImpl(this.client);
  
  @override
  Future<List<User>> getAllUsers() async {
    try {
      return await client.user.getAllUsers();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  // ... other methods
}
```

### 3. Create BLoC/Events/States
```dart
// Events
abstract class UserEvent extends Equatable {}
class LoadUsers extends UserEvent {}
class AddUser extends UserEvent {
  final User user;
  AddUser(this.user);
}

// States
abstract class UserState extends Equatable {}
class UserInitial extends UserState {}
class UserLoading extends UserState {}
class UserLoaded extends UserState {
  final List<User> users;
  UserLoaded(this.users);
}
class UserError extends UserState {
  final String message;
  UserError(this.message);
}

// BLoC
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;
  
  UserBloc(this.repository) : super(UserInitial()) {
    on<LoadUsers>((event, emit) async {
      emit(UserLoading());
      try {
        final users = await repository.getAllUsers();
        emit(UserLoaded(users));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
  }
}
```

### 4. Update UI to use BLoC
```dart
// In widget
BlocProvider(
  create: (context) => UserBloc(userRepository)..add(LoadUsers()),
  child: BlocBuilder<UserBloc, UserState>(
    builder: (context, state) {
      if (state is UserLoading) {
        return CircularProgressIndicator();
      } else if (state is UserLoaded) {
        return ListView.builder(
          itemCount: state.users.length,
          itemBuilder: (context, index) {
            final user = state.users[index];
            return UserCard(user: user);
          },
        );
      } else if (state is UserError) {
        return Text('Error: ${state.message}');
      }
      return Container();
    },
  ),
)
```

## Serverpod Client Setup

### Initialize Client
```dart
// lib/core/services/serverpod_client.dart
import 'package:anant_client/anant_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

class ServerpodClientService {
  static late Client client;
  
  static Future<void> initialize() async {
    client = Client(
      'http://localhost:8080/',
      authenticationKeyManager: FlutterAuthenticationKeyManager(),
    );
  }
}
```

### Inject in main.dart
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Serverpod client
  await ServerpodClientService.initialize();
  
  runApp(MyApp());
}
```

## Error Handling

```dart
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

// In repositories
try {
  final result = await client.endpoint.method();
  return result;
} on SerializedError catch (e) {
  throw ServerException('Server Error: ${e.message}');
} catch (e) {
  throw ServerException('Network Error: $e');
}
```

## Loading States

```dart
// Use in UI
if (state is Loading) {
  return Center(
    child: CircularProgressIndicator(),
  );
}

// Or with shimmer
if (state is Loading) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: LoadingPlaceholder(),
  );
}
```

## Priority Order for Implementation

1. **High Priority** (User-facing features):
   - Authentication & User Profile
   - Attendance (Student & Teacher)
   - Fee Transactions
   - Timetable
   - Announcements

2. **Medium Priority** (Admin features):
   - User Management
   - Class Management
   - Notifications

3. **Low Priority** (Admin analytics):
   - System Settings
   - Reports & Analytics

## Testing Strategy

1. Test each endpoint individually
2. Test error scenarios (network failure, server error)
3. Test loading states
4. Test data refresh
5. Test offline behavior (if applicable)

## Notes

- All mock data should be removed after server integration
- Add proper error messages for user feedback
- Implement retry mechanisms for failed requests
- Add request caching where appropriate (e.g., user profile)
- Implement pull-to-refresh on list screens
- Add pagination for large datasets

## Next Steps

1. Review server endpoints and data models
2. Create protocol definitions if missing
3. Implement repositories following clean architecture
4. Add BLoC for state management
5. Update UI to consume server data
6. Test thoroughly with real server
7. Remove all mock data
