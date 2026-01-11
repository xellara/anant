# Seeding Scripts

This directory contains two seeding scripts for the Anant server database:

## 1. `seed_essential.dart` - Essential Data Only

Seeds **only the required data** needed for the application to function properly.

### What it seeds:
- ✅ Organization with complete fee structure (12 months)
- ✅ Organization Settings with enabled modules
- ✅ All Permissions (26 permissions across different modules)
- ✅ All Roles (11 roles for different user types)
- ✅ Role-Permission mappings
- ✅ 1 Super Admin user for initial access

### What it does NOT seed:
- ❌ No dummy/test users
- ❌ No test classes or sections
- ❌ No attendance records
- ❌ No exam data
- ❌ No announcements

### Usage:
```bash
cd anant_server
dart run bin/seed_essential.dart
```

### Super Admin Credentials:
After running, you'll get:
- **Anant ID**: `superadmin@AnantSchool.anant`
- **Password**: `Admin@123`

---

## 2. `seed_data.dart` - Complete Dummy Data

Seeds **comprehensive test/dummy data** for development and testing.

### What it seeds:
- ✅ Organization
- ✅ 1 Class (Class 10)
- ✅ 5 Subjects
- ✅ 54 Users across all roles:
  - 1 Anant (Super Admin)
  - 2 Admins
  - 2 Principals
  - 2 Teachers
  - 35 Students
  - 2 Accountants
  - 2 Clerks
  - 2 Librarians
  - 2 Transport staff
  - 2 Hostel staff
  - 2 Parents
- ✅ Enrollments (35 class enrollments)
- ✅ Student Course Enrollments (105-175 enrollments)
- ✅ Timetable entries (25 entries, Mon-Fri)
- ✅ Exams (10 exam records)
- ✅ Attendance records (last 5 days for all students)
- ✅ Fee records (for all students)
- ✅ Announcements (4 announcements)
- ✅ Notifications (based on fees and announcements)
- ✅ Roles and Permissions
- ✅ Role-Permission mappings
- ✅ User-Role assignments

### Usage:
```bash
cd anant_server
dart run bin/seed_data.dart
```

### Important:
- **Asks for confirmation** before clearing existing data
- Type `yes` or `y` to proceed, anything else to cancel
- Displays all user credentials in a table format after creation

---

## When to Use Which?

### Use `seed_essential.dart` when:
- 🚀 Setting up a **new production** environment
- 🏢 Creating a **new organization** without test data
- ⚙️ You only need the basic structure and one admin user
- 📋 You want to manually add real users later

### Use `seed_data.dart` when:
- 🧪 Setting up a **development** environment
- 🎯 You need **test data** to work with
- 👥 You want realistic data for **testing features**
- 🔍 You need sample data to **demo** the application

---

## Common Passwords:

After seeding, all users have predictable passwords based on their role:

- **Super Admin** (Anant): `Admin@123`
- **Admin**: `Admin@123`
- **Principal**: `Principal@123`
- **Teacher**: `Teacher@123`
- **Student**: `Student@123`
- **Accountant**: `Accountant@123`
- **Clerk**: `Clerk@123`
- **Librarian**: `Librarian@123`
- **Transport**: `Transport@123`
- **Hostel**: `Hostel@123`
- **Parent**: `Parent@123`

---

## Fee Structure

Both scripts create the organization with a complete 12-month fee structure:
- Monthly fees: ₹5,000 per month
- Academic year: April to March
- Admission fee: ₹10,000

You can modify these values in the organization object within each script.
