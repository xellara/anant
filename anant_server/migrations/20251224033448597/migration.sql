BEGIN;

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE FOREIGN KEY
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
-- MIGRATION VERSION FOR anant
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('anant', '20251224033448597', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251224033448597', "timestamp" = now();

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
