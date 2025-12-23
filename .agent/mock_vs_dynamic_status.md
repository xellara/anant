# App Data Status - Mock vs Dynamic

## ✅ Already Dynamic (Connected to Server)

### 1. **User Authentication**
- ✅ Login/Signup via `AuthService`
- ✅ User profile data from server
- ✅ Multi-account switching
- **Files:** `auth/`, `profile/`

### 2. **Fee Management**
- ✅ Fee records from database
- ✅ Monthly transactions
- **Files:** `fee_screen.dart`, `monthly_fee_list_screen.dart`
- **Note:** Some breakdown data still mocked in `fee_detail_screen.dart`

## ❌ Still Using Mock Data

### 1. **Announcements** 📢
**Status:** Mock data
**Files:**
- `lib/features/announcements/presentation/pages/announcement_page.dart` (Line 9)
- `lib/features/announcements/presentation/pages/create_announcement_page.dart` (Line 30 - class list)

**What's Mocked:**
- Announcement list (hardcoded 2 items)
- Class list for targeting

**Server Ready:** ✅ Yes - `Announcement` table exists, data seeded
**Needs:** BLoC + Repository to connect to `client.announcement.*`

### 2. **Notifications** 🔔
**Status:** Mock data
**Files:**
- `lib/features/notifications/presentation/pages/notifications_page.dart` (Line 23)

**What's Mocked:**
- All notifications (5 hardcoded items)
- Unread count

**Server Ready:** ✅ Yes - `Notification` table exists, data seeded
**Needs:** BLoC + Repository to connect to `client.notification.*`

### 3. **Admin - Manage Users** 👥
**Status:** Mock data
**Files:**
- `lib/features/admin/pages/manage_users_page.dart` (Line 15)

**What's Mocked:**
- User list (5 hardcoded users)
- User roles and statuses

**Server Ready:** ✅ Yes - `User` table exists, 47 users seeded
**Needs:** Connect to `client.user.*` endpoints

### 4. **Admin - Manage Classes** 🏫
**Status:** Mock data
**Files:**
- `lib/features/admin/pages/manage_classes_page.dart` (Line 12)

**What's Mocked:**
- Class list (12 hardcoded classes)
- Section information

**Server Ready:** ✅ Yes - `Class` table exists, data seeded
**Needs:** Connect to `client.class.*` and `client.section.*`

### 5. **Admin - Reports & Analytics** 📊
**Status:** Mock data
**Files:**
- `lib/features/admin/pages/reports_page.dart`

**What's Mocked:**
- All KPI metrics (revenue, attendance, etc.)
- Chart data (bar charts, line charts)
- Statistics

**Server Ready:** ⚠️ Endpoints exist but return mock data
**Needs:** 
- Implement actual queries in `report_endpoint.dart`
- Connect UI to `client.report.*`

### 6. **Teacher - Student Selection** 👨‍🎓
**Status:** Mock data
**Files:**
- `lib/features/teacher_home/student_selection_page.dart` (Lines 14, 18)

**What's Mocked:**
- Student list by class
- Class sections

**Server Ready:** ✅ Yes - 35 students seeded
**Needs:** Query from `User` table where role=student

### 7. **Timetable** 📅
**Status:** Partially mock
**Files:**
- `lib/features/timetable/data/repositories/timetable_repository_impl.dart`

**What's Mocked:**
- Timetable slots and sessions

**Server Ready:** ✅ Yes - `TimetableEntry` table exists, data seeded
**Needs:** Update repository to query from database

### 8. **Student Attendance** ✅
**Status:** Need to verify
**Files:**
- `lib/features/student_attendance/presentation/pages/student_attendance_page.dart`
- `lib/features/student_attendance/data/repositories/student_attendance_repository_impl.dart`

**What's Mocked:**
- Attendance summary and records

**Server Ready:** ✅ Yes - `Attendance` table exists, 5 days seeded
**Needs:** Connect to `client.attendance.*`

## 📊 Summary Statistics

| Category | Total | Dynamic | Mock | % Complete |
|----------|-------|---------|------|------------|
| **User Features** | 4 | 2 | 2 | 50% |
| **Admin Features** | 4 | 0 | 4 | 0% |
| **Teacher Features** | 2 | 0 | 2 | 0% |
| **Data Display** | 3 | 1 | 2 | 33% |
| **TOTAL** | 13 | 3 | 10 | **23%** |

## 🎯 Priority Implementation Plan

### **Phase 1: Critical User Features** (High Priority)
1. ✨ **Notifications** - Users need real-time alerts
   - Create `NotificationBloc`
   - Create `NotificationRepository`
   - Update `notifications_page.dart`
   
2. ✨ **Announcements** - School-wide communications
   - Create `AnnouncementBloc`
   - Create `AnnouncementRepository`
   - Update `announcement_page.dart`
   - Update `create_announcement_page.dart`

3. ✨ **Student Attendance** - Core academic feature
   - Update `StudentAttendanceRepository`
   - Connect to server endpoints

### **Phase 2: Teacher Features** (Medium Priority)
4. ✨ **Timetable** - Daily schedules
   - Update `TimetableRepository`
   - Fetch from `TimetableEntry` table

5. ✨ **Student Selection** - Class management
   - Query students by class
   - Connect to `User` table

### **Phase 3: Admin Features** (Medium Priority)
6. ✨ **Manage Users** - User administration
   - Connect to `UserEndpoint`
   - Implement CRUD operations

7. ✨ **Manage Classes** - Class administration
   - Connect to `ClassEndpoint`
   - Implement CRUD operations

### **Phase 4: Analytics** (Low Priority)
8. ✨ **Reports & Analytics** - Admin insights
   - Implement queries in `report_endpoint.dart`
   - Connect UI to endpoints

## 🛠️ Implementation Template

For each feature, follow this pattern:

### 1. Create Domain Layer
```dart
// lib/features/{feature}/domain/repositories/{feature}_repository.dart
abstract class FeatureRepository {
  Future<List<Item>> getItems();
  Future<void> createItem(Item item);
  // ...
}
```

### 2. Create Data Layer
```dart
// lib/features/{feature}/data/repositories/{feature}_repository_impl.dart
class FeatureRepositoryImpl implements FeatureRepository {
  final Client client;
  
  @override
  Future<List<Item>> getItems() async {
    return await client.feature.getItems();
  }
}
```

### 3. Create BLoC
```dart
// lib/features/{feature}/presentation/bloc/{feature}_bloc.dart
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  final FeatureRepository repository;
  
  FeatureBloc(this.repository) : super(FeatureInitial()) {
    on<LoadItems>(_onLoadItems);
  }
  
  Future<void> _onLoadItems(LoadItems event, Emitter<FeatureState> emit) async {
    emit(FeatureLoading());
    try {
      final items = await repository.getItems();
      emit(FeatureLoaded(items));
    } catch (e) {
      emit(FeatureError(e.toString()));
    }
  }
}
```

### 4. Update UI
```dart
BlocProvider(
  create: (context) => FeatureBloc(repository)..add(LoadItems()),
  child: BlocBuilder<FeatureBloc, FeatureState>(
    builder: (context, state) {
      if (state is FeatureLoading) return CircularProgressIndicator();
      if (state is FeatureLoaded) return ItemList(items: state.items);
      if (state is FeatureError) return ErrorView(message: state.message);
      return Container();
    },
  ),
)
```

## 🔍 Server Endpoint Status

### Available & Working:
- ✅ `client.user.*` - User management
- ✅ `client.class.*` - Class management
- ✅ `client.section.*` - Section management
- ✅ `client.attendance.*` - Attendance records
- ✅ `client.transaction.*` - Fee transactions
- ✅ `client.settings.*` - Organization settings

### Available (Mock Data):
- ⚠️ `client.announcement.*` - Returns mock data from endpoint
- ⚠️ `client.notification.*` - Returns mock data from endpoint
- ⚠️ `client.timetable.*` - Returns mock data from endpoint
- ⚠️ `client.report.*` - Returns mock data from endpoint

## 📝 Next Steps

1. **Update Server Endpoints** - Replace mock data with actual database queries
2. **Create Repositories** - Implement data layer for each feature
3. **Create BLoCs** - Add state management
4. **Update UI** - Replace hardcoded lists with BlocBuilder
5. **Test** - Verify all features work with real data

## 🎨 Files That Need Updates

### High Priority (User-Facing):
1. `lib/features/notifications/presentation/pages/notifications_page.dart`
2. `lib/features/announcements/presentation/pages/announcement_page.dart`
3. `lib/features/student_attendance/data/repositories/student_attendance_repository_impl.dart`
4. `lib/features/timetable/data/repositories/timetable_repository_impl.dart`

### Medium Priority (Teacher Tools):
5. `lib/features/teacher_home/student_selection_page.dart`
6. `lib/features/attendance/attendance.dart` (Teacher attendance marking)

### Medium Priority (Admin):
7. `lib/features/admin/pages/manage_users_page.dart`
8. `lib/features/admin/pages/manage_classes_page.dart`
9. `lib/features/admin/pages/system_settings_page.dart`

### Low Priority (Analytics):
10. `lib/features/admin/pages/reports_page.dart`

## ✅ Database Seeding Status

All data is properly seeded:
- ✅ 1 Organization
- ✅ 47 Users (35 students, 2 teachers, 2 admins, etc.)
- ✅ 1 Class
- ✅ 5 Subjects
- ✅ Timetable entries
- ✅ 35 Students × 5 Days = 175 Attendance records
- ✅ 35 Fee records
- ✅ 4 Announcements
- ✅ ~40+ Notifications (fee alerts + announcements)

**Next Action:** Start implementing BLoC pattern for each mock data section, beginning with Notifications and Announcements.
