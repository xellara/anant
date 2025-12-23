BEGIN;

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
--
CREATE TABLE "role_permission" (
    "id" bigserial PRIMARY KEY,
    "roleId" bigint NOT NULL,
    "permissionId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "role_perm_idx" ON "role_permission" USING btree ("roleId", "permissionId");

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "permission_audit"
    ADD CONSTRAINT "permission_audit_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
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
-- ACTION CREATE FOREIGN KEY
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
-- ACTION CREATE FOREIGN KEY
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
-- MIGRATION VERSION FOR anant
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('anant', '20251223020058766', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251223020058766', "timestamp" = now();

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
