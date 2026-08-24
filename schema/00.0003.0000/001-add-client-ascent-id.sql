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

