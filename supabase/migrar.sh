#!/usr/bin/env bash
# Aplica en orden las migraciones pendientes y las registra.
# Uso: supabase/migrar.sh "<cadena de conexión>"
set -euo pipefail
CONN="${1:?Falta la cadena de conexión}"
DIR="$(cd "$(dirname "$0")" && pwd)/migrations"
psql "$CONN" -v ON_ERROR_STOP=1 -q <<'SQL'
create schema if not exists supabase_migrations;
create table if not exists supabase_migrations.schema_migrations (
  version text primary key, statements text[], name text);
SQL
for f in "$DIR"/*.sql; do
  base="$(basename "$f" .sql)"; version="${base%%_*}"; name="${base#*_}"
  hecho=$(psql "$CONN" -Atq -c "select 1 from supabase_migrations.schema_migrations where version='$version'")
  if [ -z "$hecho" ]; then
    psql "$CONN" -v ON_ERROR_STOP=1 -q --single-transaction -f "$f" \
      -c "insert into supabase_migrations.schema_migrations(version,name) values ('$version','$name')"
    echo "aplicada $base"
  fi
done
