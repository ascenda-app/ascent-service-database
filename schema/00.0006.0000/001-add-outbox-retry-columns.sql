CREATE TABLE IF NOT EXISTS "__EFMigrationsHistory" (
    "MigrationId" character varying(150) NOT NULL,
    "ProductVersion" character varying(32) NOT NULL,
    CONSTRAINT "PK___EFMigrationsHistory" PRIMARY KEY ("MigrationId")
);

START TRANSACTION;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260724221426_InitialAscentSchema') THEN
    CREATE TABLE ascents (
        id uuid NOT NULL,
        user_id uuid NOT NULL,
        peak_id uuid NOT NULL,
        peak_name character varying(200) NOT NULL,
        peak_altitude_m integer NOT NULL,
        ascent_date date NOT NULL,
        companions character varying(500),
        route_notes text,
        visibility character varying(20) NOT NULL DEFAULT 'Public',
        created_at_utc timestamp with time zone NOT NULL,
        updated_at_utc timestamp with time zone NOT NULL,
        conditions jsonb NOT NULL,
        CONSTRAINT "PK_ascents" PRIMARY KEY (id)
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260724221426_InitialAscentSchema') THEN
    CREATE TABLE outbox_messages (
        id uuid NOT NULL,
        type character varying(500) NOT NULL,
        content text NOT NULL,
        occurred_at_utc timestamp with time zone NOT NULL,
        processed_at_utc timestamp with time zone,
        error text,
        CONSTRAINT "PK_outbox_messages" PRIMARY KEY (id)
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260724221426_InitialAscentSchema') THEN
    CREATE TABLE processed_messages (
        message_id uuid NOT NULL,
        processed_at_utc timestamp with time zone NOT NULL,
        CONSTRAINT "PK_processed_messages" PRIMARY KEY (message_id)
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260724221426_InitialAscentSchema') THEN
    CREATE TABLE ascent_photos (
        id uuid NOT NULL,
        cloudinary_public_id character varying(255) NOT NULL,
        secure_url character varying(500) NOT NULL,
        width integer NOT NULL,
        height integer NOT NULL,
        position smallint NOT NULL,
        uploaded_at_utc timestamp with time zone NOT NULL,
        ascent_id uuid NOT NULL,
        CONSTRAINT "PK_ascent_photos" PRIMARY KEY (id),
        CONSTRAINT "FK_ascent_photos_ascents_ascent_id" FOREIGN KEY (ascent_id) REFERENCES ascents (id) ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260724221426_InitialAscentSchema') THEN
    CREATE UNIQUE INDEX ux_ascent_photo_position ON ascent_photos (ascent_id, position);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260724221426_InitialAscentSchema') THEN
    CREATE INDEX ix_ascents_peak ON ascents (peak_id);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260724221426_InitialAscentSchema') THEN
    CREATE INDEX ix_ascents_user_date ON ascents (user_id, ascent_date DESC);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260724221426_InitialAscentSchema') THEN
    CREATE INDEX ix_outbox_messages_processed_at_utc ON outbox_messages (processed_at_utc);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260724221426_InitialAscentSchema') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20260724221426_InitialAscentSchema', '10.0.10');
    END IF;
END $EF$;
COMMIT;

START TRANSACTION;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260725143725_AddConfirmedUsers') THEN
    CREATE TABLE confirmed_users (
        id uuid NOT NULL,
        confirmed_at_utc timestamp with time zone NOT NULL,
        created_at_utc timestamp with time zone NOT NULL,
        updated_at_utc timestamp with time zone NOT NULL,
        CONSTRAINT "PK_confirmed_users" PRIMARY KEY (id)
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260725143725_AddConfirmedUsers') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20260725143725_AddConfirmedUsers', '10.0.10');
    END IF;
END $EF$;
COMMIT;

START TRANSACTION;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260808212825_AddClientAscentId') THEN
    ALTER TABLE ascents ADD client_ascent_id uuid;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260808212825_AddClientAscentId') THEN
    CREATE UNIQUE INDEX ux_ascents_user_client_id ON ascents (user_id, client_ascent_id) WHERE client_ascent_id IS NOT NULL;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260808212825_AddClientAscentId') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20260808212825_AddClientAscentId', '10.0.10');
    END IF;
END $EF$;
COMMIT;

START TRANSACTION;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260810085839_RemovePhotoSecureUrl') THEN
    ALTER TABLE ascent_photos DROP COLUMN secure_url;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260810085839_RemovePhotoSecureUrl') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20260810085839_RemovePhotoSecureUrl', '10.0.10');
    END IF;
END $EF$;
COMMIT;

START TRANSACTION;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260811205923_AddDeletedUsersAndPhotoPositionCheck') THEN
    CREATE TABLE deleted_users (
        id uuid NOT NULL,
        deleted_at_utc timestamp with time zone NOT NULL,
        created_at_utc timestamp with time zone NOT NULL,
        updated_at_utc timestamp with time zone NOT NULL,
        CONSTRAINT "PK_deleted_users" PRIMARY KEY (id)
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260811205923_AddDeletedUsersAndPhotoPositionCheck') THEN
    ALTER TABLE ascent_photos ADD CONSTRAINT ck_ascent_photo_position CHECK (position BETWEEN 0 AND 2);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260811205923_AddDeletedUsersAndPhotoPositionCheck') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20260811205923_AddDeletedUsersAndPhotoPositionCheck', '10.0.10');
    END IF;
END $EF$;
COMMIT;

START TRANSACTION;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260813112939_AddOutboxRetryColumns') THEN
    DROP INDEX ix_outbox_messages_processed_at_utc;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260813112939_AddOutboxRetryColumns') THEN
    ALTER TABLE outbox_messages ADD attempt_count integer NOT NULL DEFAULT 0;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260813112939_AddOutboxRetryColumns') THEN
    ALTER TABLE outbox_messages ADD next_attempt_at_utc timestamp with time zone;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260813112939_AddOutboxRetryColumns') THEN
    CREATE INDEX ix_outbox_messages_processed_at_utc ON outbox_messages (processed_at_utc, next_attempt_at_utc);
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20260813112939_AddOutboxRetryColumns') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20260813112939_AddOutboxRetryColumns', '10.0.10');
    END IF;
END $EF$;
COMMIT;

