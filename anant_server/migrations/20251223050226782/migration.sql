BEGIN;

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "announcements"
    ADD CONSTRAINT "announcements_fk_0"
    FOREIGN KEY("organizationId")
    REFERENCES "organization"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "notifications"
    ADD CONSTRAINT "notifications_fk_0"
    FOREIGN KEY("organizationId")
    REFERENCES "organization"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR anant
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('anant', '20251223050226782', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251223050226782', "timestamp" = now();

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
