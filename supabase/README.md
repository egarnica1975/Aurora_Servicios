# supabase/ · base de datos de la V2

Cambio vigente: `v2-modelo-de-datos`. Todo es SQL estándar de PostgreSQL: funciona igual en una base local y en Supabase.

## Contenido
- `migrations/`: migraciones numeradas (0001 esquema, 0002 catálogos, 0003 integridad e historial). Se aplican en orden.
- `migrar.sh "<conexión>"`: aplica las pendientes y las registra en `supabase_migrations.schema_migrations` (la misma tabla que usa la CLI de Supabase).
- `demo/*.csv`: datos ficticios de demostración (clientes, colaboradores, solicitudes).
- `cargar_demo.sh "<conexión>"`: carga la demostración; repetible, marca las solicitudes con `origen = 'demo'` y no pisa las existentes.
- `tests/probar_esquema.sh "<conexión>"` y `tests/probar_integridad.sh "<conexión>"`: pruebas; **solo sobre una base vacía y local** (cada una en su propia base).

## Probar en local (PostgreSQL 16)
```bash
initdb -D /tmp/pgdata -A trust && pg_ctl -D /tmp/pgdata -o '-p 5433 -k /tmp' start
psql "host=/tmp port=5433 dbname=postgres" -c "create database aurora_test"
supabase/tests/probar_esquema.sh "host=/tmp port=5433 dbname=aurora_test"
```

## Supabase (proyecto gratuito)
La conexión se toma del panel de Supabase y **no se guarda en el repositorio**. El plan gratuito se pausa tras una semana sin actividad: reactivarlo antes de usarlo. Respaldo: volcado manual semanal (ver `v2-respaldo-recuperacion`); los archivos de volcado no se suben al repositorio.

## Cómo escribe la aplicación (integridad)
- La API se conecta con el rol `aurora_app` (sin privilegios de modificación sobre `cambio`, `auditoria` ni `respaldo_registro`; no puede escribir historia ni indicar la referencia).
- En cada transacción que modifica una solicitud debe fijar `select set_config('app.usuario_id', '<id>', true)` y, si cambia el responsable o se anula, `set_config('app.motivo', '<motivo>', true)`. Sin eso la base rechaza el cambio.
- La referencia `SOL-AAAA-NNNNN` la asigna la base al insertar; la historia (incluido el alta) la generan los triggers.

## Alcance de la inmutabilidad (decisión D5)
Las garantías valen frente al rol de la aplicación y a roles sin privilegios de superusuario. Quien administre la base con credenciales de propietario puede deshabilitar triggers o alterar tablas; un hash encadenado que lo detecte es una pregunta abierta de `v2-integridad-historial`. Hacer una limpieza completa (por ejemplo quitar los datos de demostración) exige reiniciar la base con ese rol.
