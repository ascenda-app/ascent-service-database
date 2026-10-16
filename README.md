# ascent-service-database

SQL versionado de `ascenda_ascents` (PostgreSQL 16), la base de datos de `ascent-service`.

## Qué hay aquí

```
schema/
├── 00.0001.0000/001-initial-schema.sql
├── 00.0002.0000/001-add-confirmed-users.sql
├── 00.0003.0000/001-add-client-ascent-id.sql
├── 00.0004.0000/001-remove-photo-secure-url.sql
├── 00.0005.0000/001-add-deleted-users-and-photo-position-check.sql
└── 00.0006.0000/001-add-outbox-retry-columns.sql
```

Todos generados e idempotentes. Qué aporta cada versión:

| Versión | Contenido |
|---|---|
| `00.0001.0000` | `ascents`, `ascent_photos`, `outbox_messages`, `processed_messages`, con `ix_ascents_user_date`, `ix_ascents_peak` y `ux_ascent_photo_position` |
| `00.0002.0000` | `confirmed_users`, la proyección de RF-AUT-02 |
| `00.0003.0000` | `ascents.client_ascent_id` y el índice parcial `ux_ascents_user_client_id` |
| `00.0004.0000` | Elimina `ascent_photos.secure_url`: la URL se firma en cada lectura |
| `00.0005.0000` | `deleted_users` (fila lápida) y `ck_ascent_photo_position` |
| `00.0006.0000` | `outbox_messages.attempt_count` y `next_attempt_at_utc`, y el índice pasa a cubrir las dos columnas del filtro de elegibilidad |

`00.0002.0000` y `00.0003.0000` se generaron en **delta**; de `00.0004.0000` en adelante son
**acumulativos**, que es la forma correcta (`DEVELOPMENT.md` §8). Los publicados no se corrigen
retroactivamente.

**`xmin` no aparece en ningún script y es correcto.** El agregado `Ascent` usa esa columna de sistema
de PostgreSQL como token de concurrencia optimista, así que no hay columna que crear. EF sí emite un
`AddColumn` para ella al generar la migración: **hay que borrarlo a mano del fichero de migración**,
porque `ALTER TABLE ... ADD COLUMN xmin` falla con *column name "xmin" conflicts with a system
column name*.

## Cómo se genera

**Este repositorio no se escribe a mano.** La fuente de verdad son las migraciones EF Core de
`ascent-service/AscentService/AscentService.Infrastructure/Persistence/Migrations/`. Tras crear una
migración nueva:

```bash
cd ascent-service/AscentService

dotnet ef migrations add <NombreDeLaMigracion> \
  --project AscentService.Infrastructure \
  --startup-project AscentService.API

dotnet ef migrations script --idempotent \
  --project AscentService.Infrastructure \
  --startup-project AscentService.API \
  --output ../../ascent-service-database/schema/<version>/<n>-<nombre>.sql
```

Un script publicado **no se edita nunca**: se corrige con una migración nueva.

## Cómo se aplica

En Docker, el contenedor efímero `ascent-migrator` (stage `migrator` del `Dockerfile`) ejecuta un
bundle EF autocontenido antes de que arranque el servicio. Estos scripts son el artefacto de
publicación del esquema; **no** se montan en el contenedor de base de datos.

Fuera de Docker:

```bash
dotnet ef database update \
  --project AscentService.Infrastructure \
  --startup-project AscentService.API
```

Detalle en `.claude/docs/DEVELOPMENT.md` §8 y esquema en `.claude/docs/DESIGN.md` §7.
