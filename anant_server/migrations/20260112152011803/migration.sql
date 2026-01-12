BEGIN;

--
-- ACTION ALTER TABLE
--
CREATE INDEX "txn_anant_id_idx" ON "monthly_fee_transaction" USING btree ("anantId");
CREATE INDEX "txn_month_idx" ON "monthly_fee_transaction" USING btree ("month");
CREATE INDEX "txn_status_idx" ON "monthly_fee_transaction" USING btree ("transactionStatus");
--
-- ACTION ALTER TABLE
--
CREATE INDEX "user_org_class_section_idx" ON "user" USING btree ("organizationName", "className", "sectionName");
CREATE INDEX "user_fullname_idx" ON "user" USING btree ("fullName");
CREATE INDEX "user_rollnumber_idx" ON "user" USING btree ("rollNumber");

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
