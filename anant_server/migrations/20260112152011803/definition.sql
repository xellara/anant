BEGIN;

--
-- Class Announcement as table announcements
--
CREATE TABLE "announcements" (
    "id" bigserial PRIMARY KEY,
    "organizationId" bigint NOT NULL,
    "title" text NOT NULL,
    "content" text NOT NULL,
    "priority" text NOT NULL,
    "targetAudience" text NOT NULL,
    "targetClasses" text,
    "createdBy" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone,
    "isActive" boolean NOT NULL DEFAULT true
);

--
-- Class Attendance as table attendance
--
CREATE TABLE "attendance" (
    "id" bigserial PRIMARY KEY,
    "organizationName" text NOT NULL,
    "className" text NOT NULL,
    "sectionName" text NOT NULL,
    "subjectName" text,
    "studentAnantId" text NOT NULL,
    "startTime" text NOT NULL,
    "endTime" text NOT NULL,
    "date" text NOT NULL,
    "markedByAnantId" text NOT NULL,
    "status" text NOT NULL,
    "isSubmitted" boolean NOT NULL DEFAULT false,
    "remarks" text
);

--
-- Class Classes as table class
--
CREATE TABLE "class" (
    "id" bigserial PRIMARY KEY,
    "organizationId" bigint,
    "name" text NOT NULL,
    "academicYear" text NOT NULL,
    "courseName" text,
    "classTeacherAnantId" text,
    "startDate" timestamp without time zone,
    "endDate" timestamp without time zone,
    "isActive" boolean NOT NULL DEFAULT true
);

--
-- Class Course as table course
--
CREATE TABLE "course" (
    "id" bigserial PRIMARY KEY,
    "organizationId" bigint,
    "department" text,
    "name" text NOT NULL,
    "code" text,
    "description" text,
    "semester" bigint,
    "academicYear" text,
    "credits" bigint,
    "isElective" boolean NOT NULL DEFAULT false,
    "isActive" boolean NOT NULL DEFAULT true
);

--
-- Class Enrollment as table enrollment
--
CREATE TABLE "enrollment" (
    "id" bigserial PRIMARY KEY,
    "organizationId" bigint NOT NULL,
    "classId" bigint NOT NULL,
    "studentId" bigint NOT NULL
);

-- Indexes
CREATE INDEX "enroll_class_idx" ON "enrollment" USING btree ("classId");
CREATE INDEX "enroll_student_idx" ON "enrollment" USING btree ("studentId");

--
-- Class Exam as table exam
--
CREATE TABLE "exam" (
    "id" bigserial PRIMARY KEY,
    "organizationId" bigint NOT NULL,
    "classId" bigint NOT NULL,
    "subjectId" bigint NOT NULL,
    "name" text NOT NULL,
    "date" timestamp without time zone NOT NULL,
    "totalMarks" bigint NOT NULL
);

-- Indexes
CREATE INDEX "exam_class_idx" ON "exam" USING btree ("classId", "date");

--
-- Class ExternalAuthProvider as table external_auth_provider
--
CREATE TABLE "external_auth_provider" (
    "id" bigserial PRIMARY KEY,
    "uid" text NOT NULL,
    "provider" text NOT NULL,
    "providerUid" text NOT NULL,
    "providerEmail" text,
    "metadata" text,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "provider_uid_idx" ON "external_auth_provider" USING btree ("provider", "providerUid");
CREATE INDEX "uid_idx" ON "external_auth_provider" USING btree ("uid");

--
-- Class FeeRecord as table fee_record
--
CREATE TABLE "fee_record" (
    "id" bigserial PRIMARY KEY,
    "organizationId" bigint NOT NULL,
    "studentId" bigint NOT NULL,
    "amount" double precision NOT NULL,
    "dueDate" timestamp without time zone,
    "paidDate" timestamp without time zone,
    "description" text
);

-- Indexes
CREATE INDEX "fee_student_idx" ON "fee_record" USING btree ("studentId", "dueDate");

--
-- Class MonthlyFeeTransaction as table monthly_fee_transaction
--
CREATE TABLE "monthly_fee_transaction" (
    "id" bigserial PRIMARY KEY,
    "anantId" text NOT NULL,
    "organizationName" text NOT NULL,
    "month" text NOT NULL,
    "feeAmount" double precision NOT NULL,
    "discount" double precision NOT NULL,
    "fine" double precision NOT NULL,
    "transactionDate" timestamp without time zone NOT NULL,
    "transactionGateway" text NOT NULL,
    "transactionRef" text NOT NULL,
    "transactionId" text NOT NULL,
    "transactionStatus" text NOT NULL,
    "transactionType" text NOT NULL,
    "markedByAnantId" text NOT NULL,
    "isRefunded" boolean NOT NULL DEFAULT false
);

-- Indexes
CREATE INDEX "txn_anant_id_idx" ON "monthly_fee_transaction" USING btree ("anantId");
CREATE INDEX "txn_month_idx" ON "monthly_fee_transaction" USING btree ("month");
CREATE INDEX "txn_status_idx" ON "monthly_fee_transaction" USING btree ("transactionStatus");

--
-- Class Notification as table notifications
--
CREATE TABLE "notifications" (
    "id" bigserial PRIMARY KEY,
    "organizationId" bigint NOT NULL,
    "userId" text NOT NULL,
    "title" text NOT NULL,
    "message" text NOT NULL,
    "type" text NOT NULL,
    "relatedId" text,
    "timestamp" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "isRead" boolean NOT NULL DEFAULT false,
    "data" text
);

--
-- Class Organization as table organization
--
CREATE TABLE "organization" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "organizationName" text NOT NULL,
    "code" text,
    "type" text NOT NULL,
    "address" text,
    "city" text,
    "state" text,
    "country" text NOT NULL DEFAULT 'India'::text,
    "pincode" text,
    "contactNumber" text,
    "email" text,
    "website" text,
    "logoUrl" text,
    "isActive" boolean NOT NULL DEFAULT true,
    "createdAt" timestamp without time zone NOT NULL,
    "monthlyFees" json,
    "feeStartAndEndMonth" json,
    "admissionFee" double precision,
    "gstNumber" text,
    "panNumber" text
);

-- Indexes
CREATE UNIQUE INDEX "org_organizationName_unique" ON "organization" USING btree ("organizationName");

--
-- Class OrganizationSettings as table organization_settings
--
CREATE TABLE "organization_settings" (
    "id" bigserial PRIMARY KEY,
    "organizationName" text NOT NULL,
    "enabledModules" json NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "org_settings_unique" ON "organization_settings" USING btree ("organizationName");

--
-- Class Permission as table permission
--
CREATE TABLE "permission" (
    "id" bigserial PRIMARY KEY,
    "slug" text NOT NULL,
    "description" text,
    "module" text
);

-- Indexes
CREATE UNIQUE INDEX "permission_slug_idx" ON "permission" USING btree ("slug");

--
-- Class PermissionAudit as table permission_audit
--
CREATE TABLE "permission_audit" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "permissionSlug" text NOT NULL,
    "action" text NOT NULL,
    "resourceType" text,
    "resourceId" text,
    "organizationName" text,
    "success" boolean NOT NULL,
    "failureReason" text,
    "ipAddress" text,
    "userAgent" text,
    "timestamp" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "perm_audit_user_idx" ON "permission_audit" USING btree ("userId", "timestamp");
CREATE INDEX "perm_audit_time_idx" ON "permission_audit" USING btree ("timestamp");
CREATE INDEX "perm_audit_org_idx" ON "permission_audit" USING btree ("organizationName", "timestamp");

--
-- Class ResourcePermission as table resource_permission
--
CREATE TABLE "resource_permission" (
    "id" bigserial PRIMARY KEY,
    "roleId" bigint NOT NULL,
    "permissionId" bigint NOT NULL,
    "resourceType" text NOT NULL,
    "resourceId" text NOT NULL,
    "organizationName" text,
    "conditions" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdById" bigint
);

-- Indexes
CREATE INDEX "resource_perm_idx" ON "resource_permission" USING btree ("roleId", "resourceType", "resourceId");
CREATE INDEX "resource_perm_org_idx" ON "resource_permission" USING btree ("organizationName", "resourceType");

--
-- Class Role as table role
--
CREATE TABLE "role" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "slug" text NOT NULL,
    "description" text,
    "organizationName" text,
    "isSystemRole" boolean NOT NULL DEFAULT false
);

-- Indexes
CREATE UNIQUE INDEX "role_slug_org_idx" ON "role" USING btree ("slug", "organizationName");

--
-- Class RolePermission as table role_permission
--
CREATE TABLE "role_permission" (
    "id" bigserial PRIMARY KEY,
    "roleId" bigint NOT NULL,
    "permissionId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "role_perm_idx" ON "role_permission" USING btree ("roleId", "permissionId");

--
-- Class Section as table section
--
CREATE TABLE "section" (
    "id" bigserial PRIMARY KEY,
    "organizationId" bigint,
    "className" text NOT NULL,
    "name" text NOT NULL,
    "sectionTeacherAnantId" text,
    "isActive" boolean NOT NULL DEFAULT true
);

--
-- Class StudentCourseEnrollment as table student_course_enrollment
--
CREATE TABLE "student_course_enrollment" (
    "id" bigserial PRIMARY KEY,
    "studentAnantId" text NOT NULL,
    "courseName" text NOT NULL,
    "organizationId" bigint,
    "enrolledOn" timestamp without time zone NOT NULL
);

--
-- Class Subject as table subject
--
CREATE TABLE "subject" (
    "id" bigserial PRIMARY KEY,
    "organizationId" bigint NOT NULL,
    "name" text NOT NULL,
    "description" text
);

-- Indexes
CREATE INDEX "subject_org_idx" ON "subject" USING btree ("organizationId");
CREATE UNIQUE INDEX "subject_name_idx" ON "subject" USING btree ("organizationId", "name");

--
-- Class TimetableEntry as table timetable_entry
--
CREATE TABLE "timetable_entry" (
    "id" bigserial PRIMARY KEY,
    "organizationId" bigint NOT NULL,
    "classId" bigint NOT NULL,
    "subjectId" bigint NOT NULL,
    "teacherId" bigint NOT NULL,
    "dayOfWeek" bigint NOT NULL,
    "startTime" timestamp without time zone NOT NULL,
    "durationMinutes" bigint NOT NULL
);

-- Indexes
CREATE INDEX "time_class_idx" ON "timetable_entry" USING btree ("classId", "dayOfWeek");

--
-- Class User as table user
--
CREATE TABLE "user" (
    "id" bigserial PRIMARY KEY,
    "uid" text,
    "anantId" text,
    "email" text,
    "mobileNumber" text,
    "role" text NOT NULL,
    "fullName" text,
    "profileImageUrl" text,
    "organizationName" text NOT NULL,
    "className" text,
    "sectionName" text,
    "rollNumber" text,
    "admissionNumber" text,
    "gender" text,
    "dob" text,
    "bloodGroup" text,
    "aadharNumber" text,
    "address" text,
    "city" text,
    "state" text,
    "country" text NOT NULL DEFAULT 'India'::text,
    "pincode" text,
    "parentMobileNumber" text,
    "parentEmail" text,
    "subjectTeaching" json,
    "classAndSectionTeaching" json,
    "isPasswordCreated" boolean NOT NULL DEFAULT false,
    "isActive" boolean NOT NULL DEFAULT false,
    "isPremiumUser" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "user_uid_idx" ON "user" USING btree ("uid");
CREATE UNIQUE INDEX "user_username_idx" ON "user" USING btree ("anantId");
CREATE UNIQUE INDEX "user_email_idx" ON "user" USING btree ("email");
CREATE INDEX "user_org_role_idx" ON "user" USING btree ("organizationName", "role");
CREATE INDEX "user_org_class_section_idx" ON "user" USING btree ("organizationName", "className", "sectionName");
CREATE INDEX "user_fullname_idx" ON "user" USING btree ("fullName");
CREATE INDEX "user_rollnumber_idx" ON "user" USING btree ("rollNumber");

--
-- Class UserCredentials as table user_credentials
--
CREATE TABLE "user_credentials" (
    "id" bigserial PRIMARY KEY,
    "uid" text NOT NULL,
    "userId" bigint,
    "passwordHash" text NOT NULL,
    "anantId" text,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "user_credentials_uid_idx" ON "user_credentials" USING btree ("uid");
CREATE UNIQUE INDEX "user_credentials_userId_idx" ON "user_credentials" USING btree ("userId");

--
-- Class UserPermissionOverride as table user_permission_override
--
CREATE TABLE "user_permission_override" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "permissionId" bigint NOT NULL,
    "isGranted" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "user_perm_override_idx" ON "user_permission_override" USING btree ("userId", "permissionId");

--
-- Class UserRoleAssignment as table user_role_assignment
--
CREATE TABLE "user_role_assignment" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "roleId" bigint NOT NULL,
    "assignedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "assignedById" bigint,
    "isActive" boolean NOT NULL DEFAULT true,
    "validFrom" timestamp without time zone,
    "validUntil" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "user_role_assignment_idx" ON "user_role_assignment" USING btree ("userId", "roleId");

--
-- Class CloudStorageEntry as table serverpod_cloud_storage
--
CREATE TABLE "serverpod_cloud_storage" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "addedTime" timestamp without time zone NOT NULL,
    "expiration" timestamp without time zone,
    "byteData" bytea NOT NULL,
    "verified" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_path_idx" ON "serverpod_cloud_storage" USING btree ("storageId", "path");
CREATE INDEX "serverpod_cloud_storage_expiration" ON "serverpod_cloud_storage" USING btree ("expiration");

--
-- Class CloudStorageDirectUploadEntry as table serverpod_cloud_storage_direct_upload
--
CREATE TABLE "serverpod_cloud_storage_direct_upload" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL,
    "authKey" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_upload_storage_path" ON "serverpod_cloud_storage_direct_upload" USING btree ("storageId", "path");

--
-- Class FutureCallEntry as table serverpod_future_call
--
CREATE TABLE "serverpod_future_call" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "serializedObject" text,
    "serverId" text NOT NULL,
    "identifier" text
);

-- Indexes
CREATE INDEX "serverpod_future_call_time_idx" ON "serverpod_future_call" USING btree ("time");
CREATE INDEX "serverpod_future_call_serverId_idx" ON "serverpod_future_call" USING btree ("serverId");
CREATE INDEX "serverpod_future_call_identifier_idx" ON "serverpod_future_call" USING btree ("identifier");

--
-- Class ServerHealthConnectionInfo as table serverpod_health_connection_info
--
CREATE TABLE "serverpod_health_connection_info" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "active" bigint NOT NULL,
    "closing" bigint NOT NULL,
    "idle" bigint NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_connection_info_timestamp_idx" ON "serverpod_health_connection_info" USING btree ("timestamp", "serverId", "granularity");

--
-- Class ServerHealthMetric as table serverpod_health_metric
--
CREATE TABLE "serverpod_health_metric" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "isHealthy" boolean NOT NULL,
    "value" double precision NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_metric_timestamp_idx" ON "serverpod_health_metric" USING btree ("timestamp", "serverId", "name", "granularity");

--
-- Class LogEntry as table serverpod_log
--
CREATE TABLE "serverpod_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "reference" text,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "logLevel" bigint NOT NULL,
    "message" text NOT NULL,
    "error" text,
    "stackTrace" text,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_log_sessionLogId_idx" ON "serverpod_log" USING btree ("sessionLogId");

--
-- Class MessageLogEntry as table serverpod_message_log
--
CREATE TABLE "serverpod_message_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "serverId" text NOT NULL,
    "messageId" bigint NOT NULL,
    "endpoint" text NOT NULL,
    "messageName" text NOT NULL,
    "duration" double precision NOT NULL,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

--
-- Class MethodInfo as table serverpod_method
--
CREATE TABLE "serverpod_method" (
    "id" bigserial PRIMARY KEY,
    "endpoint" text NOT NULL,
    "method" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_method_endpoint_method_idx" ON "serverpod_method" USING btree ("endpoint", "method");

--
-- Class DatabaseMigrationVersion as table serverpod_migrations
--
CREATE TABLE "serverpod_migrations" (
    "id" bigserial PRIMARY KEY,
    "module" text NOT NULL,
    "version" text NOT NULL,
    "timestamp" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_migrations_ids" ON "serverpod_migrations" USING btree ("module");

--
-- Class QueryLogEntry as table serverpod_query_log
--
CREATE TABLE "serverpod_query_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "query" text NOT NULL,
    "duration" double precision NOT NULL,
    "numRows" bigint,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_query_log_sessionLogId_idx" ON "serverpod_query_log" USING btree ("sessionLogId");

--
-- Class ReadWriteTestEntry as table serverpod_readwrite_test
--
CREATE TABLE "serverpod_readwrite_test" (
    "id" bigserial PRIMARY KEY,
    "number" bigint NOT NULL
);

--
-- Class RuntimeSettings as table serverpod_runtime_settings
--
CREATE TABLE "serverpod_runtime_settings" (
    "id" bigserial PRIMARY KEY,
    "logSettings" json NOT NULL,
    "logSettingsOverrides" json NOT NULL,
    "logServiceCalls" boolean NOT NULL,
    "logMalformedCalls" boolean NOT NULL
);

--
-- Class SessionLogEntry as table serverpod_session_log
--
CREATE TABLE "serverpod_session_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "module" text,
    "endpoint" text,
    "method" text,
    "duration" double precision,
    "numQueries" bigint,
    "slow" boolean,
    "error" text,
    "stackTrace" text,
    "authenticatedUserId" bigint,
    "userId" text,
    "isOpen" boolean,
    "touched" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_session_log_serverid_idx" ON "serverpod_session_log" USING btree ("serverId");
CREATE INDEX "serverpod_session_log_touched_idx" ON "serverpod_session_log" USING btree ("touched");
CREATE INDEX "serverpod_session_log_isopen_idx" ON "serverpod_session_log" USING btree ("isOpen");

--
-- Class AuthKey as table serverpod_auth_key
--
CREATE TABLE "serverpod_auth_key" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "hash" text NOT NULL,
    "scopeNames" json NOT NULL,
    "method" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_auth_key_userId_idx" ON "serverpod_auth_key" USING btree ("userId");

--
-- Class EmailAuth as table serverpod_email_auth
--
CREATE TABLE "serverpod_email_auth" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "email" text NOT NULL,
    "hash" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_email_auth_email" ON "serverpod_email_auth" USING btree ("email");

--
-- Class EmailCreateAccountRequest as table serverpod_email_create_request
--
CREATE TABLE "serverpod_email_create_request" (
    "id" bigserial PRIMARY KEY,
    "userName" text NOT NULL,
    "email" text NOT NULL,
    "hash" text NOT NULL,
    "verificationCode" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_email_auth_create_account_request_idx" ON "serverpod_email_create_request" USING btree ("email");

--
-- Class EmailFailedSignIn as table serverpod_email_failed_sign_in
--
CREATE TABLE "serverpod_email_failed_sign_in" (
    "id" bigserial PRIMARY KEY,
    "email" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "ipAddress" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_email_failed_sign_in_email_idx" ON "serverpod_email_failed_sign_in" USING btree ("email");
CREATE INDEX "serverpod_email_failed_sign_in_time_idx" ON "serverpod_email_failed_sign_in" USING btree ("time");

--
-- Class EmailReset as table serverpod_email_reset
--
CREATE TABLE "serverpod_email_reset" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "verificationCode" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_email_reset_verification_idx" ON "serverpod_email_reset" USING btree ("verificationCode");

--
-- Class GoogleRefreshToken as table serverpod_google_refresh_token
--
CREATE TABLE "serverpod_google_refresh_token" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "refreshToken" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_google_refresh_token_userId_idx" ON "serverpod_google_refresh_token" USING btree ("userId");

--
-- Class UserImage as table serverpod_user_image
--
CREATE TABLE "serverpod_user_image" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "version" bigint NOT NULL,
    "url" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_user_image_user_id" ON "serverpod_user_image" USING btree ("userId", "version");

--
-- Class UserInfo as table serverpod_user_info
--
CREATE TABLE "serverpod_user_info" (
    "id" bigserial PRIMARY KEY,
    "userIdentifier" text NOT NULL,
    "userName" text,
    "fullName" text,
    "email" text,
    "created" timestamp without time zone NOT NULL,
    "imageUrl" text,
    "scopeNames" json NOT NULL,
    "blocked" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_user_info_user_identifier" ON "serverpod_user_info" USING btree ("userIdentifier");
CREATE INDEX "serverpod_user_info_email" ON "serverpod_user_info" USING btree ("email");

--
-- Foreign relations for "announcements" table
--
ALTER TABLE ONLY "announcements"
    ADD CONSTRAINT "announcements_fk_0"
    FOREIGN KEY("organizationId")
    REFERENCES "organization"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "class" table
--
ALTER TABLE ONLY "class"
    ADD CONSTRAINT "class_fk_0"
    FOREIGN KEY("organizationId")
    REFERENCES "organization"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "course" table
--
ALTER TABLE ONLY "course"
    ADD CONSTRAINT "course_fk_0"
    FOREIGN KEY("organizationId")
    REFERENCES "organization"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "enrollment" table
--
ALTER TABLE ONLY "enrollment"
    ADD CONSTRAINT "enrollment_fk_0"
    FOREIGN KEY("organizationId")
    REFERENCES "organization"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "enrollment"
    ADD CONSTRAINT "enrollment_fk_1"
    FOREIGN KEY("classId")
    REFERENCES "class"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "enrollment"
    ADD CONSTRAINT "enrollment_fk_2"
    FOREIGN KEY("studentId")
    REFERENCES "user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "exam" table
--
ALTER TABLE ONLY "exam"
    ADD CONSTRAINT "exam_fk_0"
    FOREIGN KEY("organizationId")
    REFERENCES "organization"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "exam"
    ADD CONSTRAINT "exam_fk_1"
    FOREIGN KEY("classId")
    REFERENCES "class"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "exam"
    ADD CONSTRAINT "exam_fk_2"
    FOREIGN KEY("subjectId")
    REFERENCES "subject"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "fee_record" table
--
ALTER TABLE ONLY "fee_record"
    ADD CONSTRAINT "fee_record_fk_0"
    FOREIGN KEY("organizationId")
    REFERENCES "organization"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "fee_record"
    ADD CONSTRAINT "fee_record_fk_1"
    FOREIGN KEY("studentId")
    REFERENCES "user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "notifications" table
--
ALTER TABLE ONLY "notifications"
    ADD CONSTRAINT "notifications_fk_0"
    FOREIGN KEY("organizationId")
    REFERENCES "organization"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "permission_audit" table
--
ALTER TABLE ONLY "permission_audit"
    ADD CONSTRAINT "permission_audit_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "resource_permission" table
--
ALTER TABLE ONLY "resource_permission"
    ADD CONSTRAINT "resource_permission_fk_0"
    FOREIGN KEY("roleId")
    REFERENCES "role"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "resource_permission"
    ADD CONSTRAINT "resource_permission_fk_1"
    FOREIGN KEY("permissionId")
    REFERENCES "permission"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "role_permission" table
--
ALTER TABLE ONLY "role_permission"
    ADD CONSTRAINT "role_permission_fk_0"
    FOREIGN KEY("roleId")
    REFERENCES "role"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "role_permission"
    ADD CONSTRAINT "role_permission_fk_1"
    FOREIGN KEY("permissionId")
    REFERENCES "permission"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "section" table
--
ALTER TABLE ONLY "section"
    ADD CONSTRAINT "section_fk_0"
    FOREIGN KEY("organizationId")
    REFERENCES "organization"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "student_course_enrollment" table
--
ALTER TABLE ONLY "student_course_enrollment"
    ADD CONSTRAINT "student_course_enrollment_fk_0"
    FOREIGN KEY("organizationId")
    REFERENCES "organization"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "subject" table
--
ALTER TABLE ONLY "subject"
    ADD CONSTRAINT "subject_fk_0"
    FOREIGN KEY("organizationId")
    REFERENCES "organization"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "timetable_entry" table
--
ALTER TABLE ONLY "timetable_entry"
    ADD CONSTRAINT "timetable_entry_fk_0"
    FOREIGN KEY("organizationId")
    REFERENCES "organization"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "timetable_entry"
    ADD CONSTRAINT "timetable_entry_fk_1"
    FOREIGN KEY("classId")
    REFERENCES "class"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "timetable_entry"
    ADD CONSTRAINT "timetable_entry_fk_2"
    FOREIGN KEY("subjectId")
    REFERENCES "subject"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "timetable_entry"
    ADD CONSTRAINT "timetable_entry_fk_3"
    FOREIGN KEY("teacherId")
    REFERENCES "user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "user_permission_override" table
--
ALTER TABLE ONLY "user_permission_override"
    ADD CONSTRAINT "user_permission_override_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "user_permission_override"
    ADD CONSTRAINT "user_permission_override_fk_1"
    FOREIGN KEY("permissionId")
    REFERENCES "permission"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "user_role_assignment" table
--
ALTER TABLE ONLY "user_role_assignment"
    ADD CONSTRAINT "user_role_assignment_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "user_role_assignment"
    ADD CONSTRAINT "user_role_assignment_fk_1"
    FOREIGN KEY("roleId")
    REFERENCES "role"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_log" table
--
ALTER TABLE ONLY "serverpod_log"
    ADD CONSTRAINT "serverpod_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_message_log" table
--
ALTER TABLE ONLY "serverpod_message_log"
    ADD CONSTRAINT "serverpod_message_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_query_log" table
--
ALTER TABLE ONLY "serverpod_query_log"
    ADD CONSTRAINT "serverpod_query_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR anant
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('anant', '20260112152011803', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260112152011803', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251208110333922-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110333922-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20250825102351908-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250825102351908-v3-0-0', "timestamp" = now();


COMMIT;
