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

