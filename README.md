# ascent-service-database

SQL versionado de `peaker_ascents` (PostgreSQL 16), la base de datos de `ascent-service`.

## Qué hay aquí

```
schema/
└── 00.0001.0000/
    └── 001-initial-schema.sql    generado, idempotente
```

`001-initial-schema.sql` crea `ascents`, `ascent_photos`, `outbox_messages` y `processed_messages`,
con los índices `ix_ascents_user_date`, `ix_ascents_peak` y `ux_ascent_photo_position`.

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
