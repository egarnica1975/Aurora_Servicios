#!/usr/bin/env bash
# Prueba de restauración: restaura un volcado en una base DISTINTA y VACÍA y compara los conteos.
# Uso: supabase/respaldo/restaurar_prueba.sh <archivo.dump> "<conexión de la base de prueba>" ["<conexión de origen>"]
# Si se indica la conexión de origen, el resultado se registra en respaldo_registro.
# Nunca apuntar la base de prueba a la base de trabajo.
set -euo pipefail
ARCHIVO="${1:?Falta el archivo .dump}"; DESTINO="${2:?Falta la conexión de la base de prueba}"; ORIGEN="${3:-}"
[ "$DESTINO" = "$ORIGEN" ] && { echo "La base de prueba no puede ser la de origen" >&2; exit 2; }
registrar() { [ -n "$ORIGEN" ] && psql "$ORIGEN" -v ON_ERROR_STOP=1 -q -c "insert into respaldo_registro(tipo,resultado,detalle,usuario_id) values ('restauración','$1','$2','${USUARIO_REGISTRO:-}')" || true; }
vacia=$(psql "$DESTINO" -Atq -c "select count(*) from pg_tables where schemaname='public'")
[ "$vacia" = "0" ] || { echo "La base de prueba no está vacía" >&2; exit 2; }
# Roles que el esquema referencia (pueden no existir en una base de prueba nueva)
psql "$DESTINO" -v ON_ERROR_STOP=1 -q -c "do \$\$ declare r text; begin
  foreach r in array array['aurora_app','anon','authenticated'] loop
    if not exists (select 1 from pg_roles where rolname=r) then execute format('create role %I nologin', r); end if;
  end loop; end \$\$;"
# El esquema public ya existe en una base nueva: se omite su creación al restaurar
LISTA="$(mktemp)"; pg_restore -l "$ARCHIVO" | grep -v ' SCHEMA - public ' > "$LISTA"
INICIO=$(date +%s)
if pg_restore --no-owner --exit-on-error -L "$LISTA" -d "$DESTINO" "$ARCHIVO"; then
  SEG=$(( $(date +%s) - INICIO ))
  SOL=$(psql "$DESTINO" -Atq -c "select count(*) from solicitud"); CAM=$(psql "$DESTINO" -Atq -c "select count(*) from cambio")
  . "$ARCHIVO.conteos"
  if [ "$SOL" = "$solicitudes" ] && [ "$CAM" = "$cambios" ]; then
    echo "RESTAURACIÓN CORRECTA: solicitudes=$SOL cambios=$CAM (coinciden con el origen), tiempo=${SEG}s"
    registrar exitoso "solicitudes=$SOL; cambios=$CAM; tiempo=${SEG}s"; exit 0
  fi
  echo "Los conteos NO coinciden: origen $solicitudes/$cambios, restaurado $SOL/$CAM" >&2
  registrar fallido "conteos distintos: origen $solicitudes/$cambios, restaurado $SOL/$CAM"; exit 1
fi
echo "La restauración FALLÓ" >&2; registrar fallido "pg_restore falló"; exit 1
