# Database Seeding Instructions

## Overview
This document provides instructions for seeding the database with comprehensive test data for the Anant School Management System.

## Test Data Summary
The seed script creates:
- **Organization**: TestSchool
- **Users**: 65 total users across all roles
  - 2 Admins
  - 2 Principals  
  - 10 Teachers
  - 35 Students
  - 2 Accountants
  - 2 Clerks
  - 2 Librarians
  - 2 Transport Staff
  - 2 Hostel Staff
- **Classes**: 12 classes (Class  1 to Class 12)
- **Sections**: 3 sections per class (A, B, C)
- **Courses**: 15 subjects
- **Attendance Records**: 30 days of attendance for all 35 students (~1050 records)
- **Fee Transactions**: 8 months of fee data for all 35 students (280 transactions)

## Default Credentials

### Admins
- Username: `admin001` | Password: `Admin@123`
- Username: `admin002` | Password: `Admin@123`

### Principals  
- Username: `principal001` | Password: `Principal@123`
- Username: `principal002` | Password: `Principal@123`

### Teachers (10 teachers)
- Username: `teacher001` to `teacher010` | Password: `Teacher@123`

### Students (35 students)
- Username: `student001` to `student035` | Password: `Student@123`

### Accountants
- Username: `accountant001` | Password: `Accountant@123`
- Username: `accountant002` | Password: `Accountant@123`

### Clerks
- Username: `clerk001` | Password: `Clerk@123`
- Username: `clerk002` | Password: `Clerk@123`

### Librarians
- Username: `librarian001` | Password: `Librarian@123`
- Username: `librarian002` | Password: `Librarian@123`

### Transport Staff
- Username: `transport001` | Password: `Transport@123`
- Username: `transport002` | Password: `Transport@123`

### Hostel Staff
- Username: `hostel001` | Password: `Hostel@123`
- Username: `hostel002` | Password: `Hostel@123`

## Method 1: Using Postman/HTTP Client

1. Ensure your Serverpod server is running (`dart run bin/main.dart`)

2. Make a POST request to:
   ```
   http://localhost:8080/seed/seedDatabase
   ```

3. No request body is required

4. The endpoint will:
   - Clear all existing tables
   - Create the TestSchool organization
   - Create all users with proper authentication
   - Populate attendance and fee records

5. Response example:
   ```json
   {
     "success": true,
     "message": "Database seeded successfully",
     "organization": "TestSchool",
     "users": {
       "admin": 2,
       "principal": 2,
       "teacher": 10,
       "student": 35,
       "accountant": 2,
       "clerk": 2,
       "librarian": 2,
       "transport": 2,
       "hostel": 2
     },
     "classes": 12,
     "sections": 36,
     "courses": 15,
     "attendance_records": 1050,
     "fee_transactions": 280
   }
   ```

## Method 2: Using Dart Script

Create a file `seed_database.dart` in your server's `bin` folder:

```dart
import 'package:anant_client/anant_client.dart';

Future<void> main() async {
  final client = Client('http://localhost:8080/');
  
  try {
    print('🌱 Starting database seed...');
    final result = await client.seed.seedDatabase();
    print('✅ Seeding completed!');
    print(result);
  } catch (e) {
    print('❌ Error: $e');
  }
  
  client.close();
}
```

Then run:
```bash
dart run bin/seed_database.dart
```

## Test Organization Details

- **Name**: TestSchool
- **Address**: 123 Education Street, Knowledge City
- **City**: Knowledge City
- **State**: Education State  
- **Country**: India
- **Pincode**: 123456
- **Phone**: +91-9876543210
- **Email**: admin@testschool.edu
- **Principal**: Dr. Rajesh Kumar
- **Established**: 2010
- **Board**: CBSE
- **Type**: Co-Education

## Testing Scenarios

### 1. Admin Testing
Login as `admin001` and test:
- User management (view all 65 users)
- Organization settings
- Role-based access control

### 2. Principal Testing  
Login as `principal001` and test:
- Staff management
- Student records
- Settings management

### 3. Teacher Testing
Login as `teacher001` and test:
- Mark attendance for assigned class
- View attendance records
- Timetable access

### 4. Student Testing
Login as `student001` to `student035` and test:
- View own attendance (30 days of records)
- View fee transactions (8 months of data)
- Access timetable
- Profile management

### 5. Accountant Testing
Login as `accountant001` and test:
- View all fee transactions (280 total)
- Filter by class/section
- Payment collection

## Data Distribution

### Students by Class/Section:
- Classes 1-12, Sections A, B, C
- ~3 students per section
- Mix of male and female students
- Various blood groups
- Parent contact information included

### Attendance Data:
- Last 30 days for each student  
- ~90% overall attendance rate
- Random absences distributed

### Fee Data:
- 8 months per student (April to November)
- Fees range from ₹5,000 to ₹9,500 per month
- Most students have paid 5+ months
- Some have partial payments

## Troubleshooting

### Error: "User already exists"
The seed script clears all data first. If you see this error, there might be an issue with the clearing process. Try:
```sql
-- Manually clear tables in PostgreSQL
TRUNCATE TABLE attendance, monthly_fee_transaction, user_credentials, "user", 
serverpod_user_info, organization_settings, section, classes, course, organization,
role_permission, permission, role, permission_audit CASCADE;
```

### Error: "Foreign key constraint"
Ensure tables are cleared in the correct order. The seed script handles this automatically.

## Notes

- All users are marked as `isActive: true` and `isPasswordCreated: true`
- Country defaults to "India" for all users
- Organization settings have all modules enabled
- Attendance is marked as submitted
- Fee transactions include payment dates for paid amounts

## Next Steps After Seeding

1. Test login with different user roles
2. Verify role-based feature visibility
3. Test CRUD operations for each module
4. Verify data relationships (class → section → students)
5. Test reporting and analytics features

---

**Last Updated**: December 2, 2025
**Server Version**: 2.9.2
**Database**: PostgreSQL
