#!/usr/bin/env bash
# Respaldo manual semanal: volcado completo (esquema y datos) de la base.
# Uso: supabase/respaldo/volcar.sh "<conexión de origen>" [carpeta de salida]
# Requiere el cliente de PostgreSQL (pg_dump) de versión igual o mayor a la de la base.
# El archivo contiene datos: NO se sube al repositorio.
set -euo pipefail
CONN="${1:?Falta la cadena de conexión de origen}"
SALIDA="${2:-volcados}"
mkdir -p "$SALIDA"
SELLO="$(date +%Y%m%d_%H%M%S)"
ARCHIVO="$SALIDA/aurora_$SELLO.dump"
registrar() { psql "$CONN" -v ON_ERROR_STOP=1 -q -c "insert into respaldo_registro(tipo,resultado,detalle,usuario_id) values ('volcado','$1','$2','${USUARIO_REGISTRO:-}')" || true; }
if pg_dump "$CONN" --format=custom --no-owner --schema=public --schema=supabase_migrations -f "$ARCHIVO"; then
  SOL=$(psql "$CONN" -Atq -c "select count(*) from solicitud"); CAM=$(psql "$CONN" -Atq -c "select count(*) from cambio")
  printf 'solicitudes=%s\ncambios=%s\n' "$SOL" "$CAM" > "$ARCHIVO.conteos"
  registrar exitoso "archivo $(basename "$ARCHIVO"); solicitudes=$SOL; cambios=$CAM"
  echo "Respaldo listo: $ARCHIVO (solicitudes=$SOL, cambios=$CAM)"
else
  rm -f "$ARCHIVO"; registrar fallido "pg_dump falló"; echo "El respaldo FALLÓ" >&2; exit 1
fi
