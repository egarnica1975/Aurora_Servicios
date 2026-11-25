# supabase/ · base de datos de la V2

Cambio vigente: `v2-modelo-de-datos`. Todo es SQL estándar de PostgreSQL: funciona igual en una base local y en Supabase.

## Contenido
- `migrations/`: migraciones numeradas (0001 esquema, 0002 catálogos). Se aplican en orden.
- `migrar.sh "<conexión>"`: aplica las pendientes y las registra en `supabase_migrations.schema_migrations` (la misma tabla que usa la CLI de Supabase).
- `demo/*.csv`: datos ficticios de demostración (clientes, colaboradores, solicitudes).
- `cargar_demo.sh "<conexión>"`: carga la demostración; repetible, marca las solicitudes con `origen = 'demo'` y no pisa las existentes.
- `tests/probar_esquema.sh "<conexión>"`: pruebas del esquema; **solo sobre una base vacía y local**.

## Probar en local (PostgreSQL 16)
```bash
initdb -D /tmp/pgdata -A trust && pg_ctl -D /tmp/pgdata -o '-p 5433 -k /tmp' start
psql "host=/tmp port=5433 dbname=postgres" -c "create database aurora_test"
supabase/tests/probar_esquema.sh "host=/tmp port=5433 dbname=aurora_test"
```

## Supabase (proyecto gratuito)
La conexión se toma del panel de Supabase y **no se guarda en el repositorio**. El plan gratuito se pausa tras una semana sin actividad: reactivarlo antes de usarlo. Respaldo: volcado manual semanal (ver `v2-respaldo-recuperacion`); los archivos de volcado no se suben al repositorio.
