# Permission Endpoint Documentation

This document outlines the API structure for the `PermissionEndpoint` in the Anant Server. It provides details on available methods, their parameters, and example responses with dummy data.

## Base Information
**Endpoint Name:** `permission`

## 1. Get Effective Permissions (Core Logic)
This is the most important method. It calculates the final list of permissions a user has by combining:
1.  **Organization Settings** (Global enable/disable of modules)
2.  **Role Permissions** (Base grants for the role)
3.  **User Overrides** (Specific grants/revocations for the user)
4.  **Super Admin Bypass** (Admins get everything)

### Method: `getEffectivePermissions`
*   **Parameters:** `targetUserId` (int)
*   **Returns:** `List<String>` (A list of enabled permission slugs)

#### Example Response (Dummy Data)
```json
[
  "attendance.mark",
  "attendance.view",
  "exam.view",
  "fees.view",
  "timetable.view"
]
```
*Note: If `exam.create` is not in this list, the user cannot create exams, even if their role says they can (e.g., if revoked specifically for them).*

---

## 2. User Permission Overrides (Granular Control)
These methods allow Admin to tweak permissions for specific users, overriding their role defaults.

### Method: `grantUserPermission`
*   **Action:** Explicitly **GIVES** a permission to a user (e.g., giving a specific Student access to "edit_profile" which students usually don't have).
*   **Parameters:**
    *   `userId` (int): The ID of the user.
    *   `permissionSlug` (String): e.g., "attendance.edit"
*   **Returns:** `bool` (true if successful)

### Method: `revokeUserPermission`
*   **Action:** Explicitly **TAKES AWAY** a permission from a user (e.g., banning a specific Teacher from "attendance.edit").
*   **Parameters:**
    *   `userId` (int)
    *   `permissionSlug` (String)
*   **Returns:** `bool` (true if successful)

### Method: `resetUserPermission`
*   **Action:** Removes any overrides for a specific permission, modifying the user's access back to whatever their **Role** dictates.
*   **Parameters:** `userId`, `permissionSlug`
*   **Returns:** `bool`

---

## 3. General Permission Management (Admin Only)

### Method: `getAllPermissions`
*   **Returns:** List of all available Permission objects in the system.

#### Example Response (Dummy Data)
```json
[
  {
    "id": 1,
    "slug": "user.create",
    "description": "Create new users",
    "module": "user_management"
  },
  {
    "id": 2,
    "slug": "attendance.mark",
    "description": "Mark attendance",
    "module": "attendance"
  },
  {
    "id": 3,
    "slug": "exam.grade",
    "description": "Grade exams",
    "module": "exam"
  }
]
```

### Method: `createPermission`
*   **Parameters:**
    *   `slug` (String): Unique identifier (e.g., `library.manage_books`)
    *   `description` (String?)
    *   `module` (String?): Grouping (e.g., `library`)
*   **Returns:** `Permission` object

### Method: `initializeDefaultPermissions`
*   **Action:** Seeds the database with the standard set of Anant permissions (User Management, Attendance, Exams, Fees, Timetable, etc.).
*   **Returns:** `Map<String, dynamic>` (Count of created permissions)

#### Example Response
```json
{
  "created": 12,
  "skipped": 5, // Already existed
  "total": 17
}
```

---

## 4. Role-Based Access Control (RBAC) Logic Flow

When `getEffectivePermissions(userId)` is called, the server performs the following check:

1.  **Is User Admin?**
    *   **YES:** Return ALL permissions (System Bypass).
    *   **NO:** Continue.

2.  **Check Organization Settings:**
    *   Is the module enabled for this school? (e.g. Is "Transport" enabled?)
    *   If **NO**, remove all "Transport" related permissions.

3.  **Fetch Role Permissions:**
    *   **Primary Role:** Get permissions from the user's main `role` field (e.g. "Teacher").
    *   **Secondary Roles:** Get active roles from `user_role_assignment` table (e.g. "Principal" assigned additionally to a Teacher).
    *   **Union:** Combine all unique permissions from both Primary and Secondary roles.
    *   *Result: {attendance.mark, exam.grade, school.manage_budget}*

4.  **Apply User Overrides:**
    *   Did Admin specifically **GRANT** anything extra? (Add to list)
    *   Did Admin specifically **REVOKE** anything? (Remove from list)

5.  **Return Final List.**

---

## Example Scenario: Multi-Role User

**Scenario:**
*   **User:** "Jane Doe"
*   **Primary Role:** `Teacher` (Grants: `attendance.mark`, `exam.grade`)
*   **Secondary Role:** `Head of Department` (Grants: `curriculum.edit`)
*   **Org Settings:** "Attendance" module is **ENABLED**.

**Admin Override:**
*   Admin calls `revokeUserPermission(jane_id, "exam.grade")` (Maybe she is a Substitute Teacher who shouldn't grade).

**Result calculation:**
1.  **Primary:** + `attendance.mark`, `exam.grade`
2.  **Secondary:** + `curriculum.edit`
3.  **Total Raw:** {`attendance.mark`, `exam.grade`, `curriculum.edit`}
4.  **Override:** - `exam.grade` (Revoked)
5.  **Final Result:** {`attendance.mark`, `curriculum.edit`}

**Jane can mark attendance and edit curriculum, but she CANNOT grade exams.**
