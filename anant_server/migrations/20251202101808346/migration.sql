BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "organization_settings" (
    "id" bigserial PRIMARY KEY,
    "organizationName" text NOT NULL,
    "enabledModules" json NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "org_settings_unique" ON "organization_settings" USING btree ("organizationName");


--
-- MIGRATION VERSION FOR anant
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('anant', '20251202101808346', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251202101808346', "timestamp" = now();

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
