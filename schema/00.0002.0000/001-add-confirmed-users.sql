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

