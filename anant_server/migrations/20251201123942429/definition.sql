BEGIN;

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
    "anantId" text,
    "email" text,
    "mobileNumber" text,
    "role" text NOT NULL,
    "fullName" text,
    "className" text,
    "sectionName" text,
    "rollNumber" text,
    "profileImageUrl" text,
    "organizationName" text NOT NULL,
    "admissionNumber" text,
    "gender" text,
    "dob" text,
    "bloodGroup" text,
    "address" text,
    "city" text,
    "state" text,
    "country" text NOT NULL DEFAULT 'India'::text,
    "pincode" text,
    "parentMobileNumber" text,
    "parentEmail" text,
    "aadharNumber" text,
    "subjectTeaching" json,
    "classAndSectionTeaching" json,
    "isPasswordCreated" boolean NOT NULL DEFAULT false,
    "isActive" boolean NOT NULL DEFAULT false,
    "isPremiumUser" boolean NOT NULL DEFAULT false
);

-- Indexes
CREATE UNIQUE INDEX "user_username_idx" ON "user" USING btree ("anantId");

--
-- Class UserCredentials as table user_credentials
--
CREATE TABLE "user_credentials" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "passwordHash" text NOT NULL,
    "anantId" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "user_credentials_userId_idx" ON "user_credentials" USING btree ("userId");

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
    VALUES ('anant', '20251201123942429', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251201123942429', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20240520102713718', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240520102713718', "timestamp" = now();


COMMIT;
