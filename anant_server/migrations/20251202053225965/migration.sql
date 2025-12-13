BEGIN;

--
-- ACTION CREATE TABLE
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
-- ACTION ALTER TABLE
--
ALTER TABLE "user" ADD COLUMN "uid" text;
ALTER TABLE "user" ADD COLUMN "createdAt" timestamp without time zone;
ALTER TABLE "user" ADD COLUMN "updatedAt" timestamp without time zone;
CREATE UNIQUE INDEX "user_uid_idx" ON "user" USING btree ("uid");
CREATE UNIQUE INDEX "user_email_idx" ON "user" USING btree ("email");
CREATE INDEX "user_org_role_idx" ON "user" USING btree ("organizationName", "role");
--
-- ACTION DROP TABLE
--
DROP TABLE "user_credentials" CASCADE;

--
-- ACTION CREATE TABLE
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
-- MIGRATION VERSION FOR anant
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('anant', '20251202053225965', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251202053225965', "timestamp" = now();

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
