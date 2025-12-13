BEGIN;

--
-- ACTION CREATE TABLE
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
-- ACTION ALTER TABLE
--
DROP INDEX "organization_organizationName_unique";
ALTER TABLE "organization" ADD COLUMN "monthlyFees" json;
ALTER TABLE "organization" ADD COLUMN "feeStartAndEndMonth" json;
ALTER TABLE "organization" ADD COLUMN "admissionFee" double precision;
ALTER TABLE "organization" ADD COLUMN "gstNumber" text;
ALTER TABLE "organization" ADD COLUMN "panNumber" text;
CREATE UNIQUE INDEX "org_organizationName_unique" ON "organization" USING btree ("organizationName");

--
-- MIGRATION VERSION FOR anant
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('anant', '20250503160134598', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250503160134598', "timestamp" = now();

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
