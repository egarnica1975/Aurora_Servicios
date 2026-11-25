#!/usr/bin/env bash
# Pruebas de v2-modelo-de-datos sobre una base local VACÍA.
# Uso: supabase/tests/probar_esquema.sh "<cadena de conexión>"
set -uo pipefail
CONN="${1:?Falta la cadena de conexión}"
RAIZ="$(cd "$(dirname "$0")/.." && pwd)"
OK=0; FALLA=0
export PGOPTIONS="-c client_min_messages=warning"
q() { psql "$CONN" -Atq -v ON_ERROR_STOP=1 -c "$1" 2>&1; }
espera_ok()    { if out=$(q "$2"); then echo "OK   $1"; OK=$((OK+1)); else echo "FALLA $1: $out"; FALLA=$((FALLA+1)); fi; }
espera_error() { if out=$(q "$2"); then echo "FALLA $1: se aceptó"; FALLA=$((FALLA+1)); else echo "OK   $1"; OK=$((OK+1)); fi; }
igual()        { r=$(q "$2"); if [ "$r" = "$3" ]; then echo "OK   $1"; OK=$((OK+1)); else echo "FALLA $1: obtuvo '$r', esperaba '$3'"; FALLA=$((FALLA+1)); fi; }

"$RAIZ/migrar.sh" "$CONN" >/dev/null || { echo "FALLA migración inicial"; exit 1; }
igual "migraciones registradas" "select count(*) from supabase_migrations.schema_migrations" "4"
igual "catálogo de canales" "select string_agg(nombre,',' order by nombre) from canal" "correo,mensajería,teléfono"
igual "catálogo de estados" "select string_agg(nombre,',' order by nombre) from estado" "Abierta,En gestión"
[ -z "$("$RAIZ/migrar.sh" "$CONN")" ] && { echo "OK   segunda ejecución no reaplica"; OK=$((OK+1)); } || { echo "FALLA reaplica"; FALLA=$((FALLA+1)); }

espera_ok "alta de cliente y colaboradores" "insert into cliente values ('C1','Cliente Uno'); insert into colaborador(id,nombre,rol) values ('u1','Uno','agente'),('u2','Dos','coordinador')"
BASE="'SOL-2026-00001','C1'"
espera_ok "solicitud mínima válida" "insert into solicitud(ref,cliente_id,asunto,canal,estado,responsable_id,fecha_recepcion,registrada_por) values ($BASE,'Asunto','correo','Abierta','u1',now(),'u1')"
espera_error "referencia con formato inválido" "insert into solicitud(ref,cliente_id,asunto,canal,estado,responsable_id,fecha_recepcion,registrada_por) values ('X-1','C1','A','correo','Abierta','u1',now(),'u1')"
espera_error "referencia duplicada" "insert into solicitud(ref,cliente_id,asunto,canal,estado,responsable_id,fecha_recepcion,registrada_por) values ($BASE,'A','correo','Abierta','u1',now(),'u1')"
espera_error "cliente inexistente" "insert into solicitud(ref,cliente_id,asunto,canal,estado,responsable_id,fecha_recepcion,registrada_por) values ('SOL-2026-00002','NOEXISTE','A','correo','Abierta','u1',now(),'u1')"
espera_error "asunto vacío" "insert into solicitud(ref,cliente_id,asunto,canal,estado,responsable_id,fecha_recepcion,registrada_por) values ('SOL-2026-00003','C1','   ','correo','Abierta','u1',now(),'u1')"
espera_error "canal fuera del catálogo" "insert into solicitud(ref,cliente_id,asunto,canal,estado,responsable_id,fecha_recepcion,registrada_por) values ('SOL-2026-00004','C1','A','paloma','Abierta','u1',now(),'u1')"
espera_error "estado fuera del catálogo" "insert into solicitud(ref,cliente_id,asunto,canal,estado,responsable_id,fecha_recepcion,registrada_por) values ('SOL-2026-00005','C1','A','correo','Inventado','u1',now(),'u1')"
espera_error "contacto con nombre sin medio" "insert into solicitud(ref,cliente_id,contacto_nombre,asunto,canal,estado,responsable_id,fecha_recepcion,registrada_por) values ('SOL-2026-00006','C1','Ana','A','correo','Abierta','u1',now(),'u1')"
espera_ok "solicitud sin contacto ni pedido" "insert into solicitud(ref,cliente_id,asunto,canal,estado,responsable_id,fecha_recepcion,registrada_por) values ('SOL-2026-00007','C1','A','correo','Abierta','u1',now(),'u1')"
espera_ok "dos solicitudes con el mismo pedido" "insert into solicitud(ref,cliente_id,pedido_ref,asunto,canal,estado,responsable_id,fecha_recepcion,registrada_por) values ('SOL-2026-00008','C1','PED1048','A','correo','Abierta','u1',now(),'u1'),('SOL-2026-00009','C1','PED1048','B','correo','Abierta','u1',now(),'u1')"
igual "ambas con el mismo pedido quedaron" "select count(*) from solicitud where pedido_ref='PED1048'" "2"
espera_error "anulada sin motivo" "insert into solicitud(ref,cliente_id,asunto,canal,estado,responsable_id,fecha_recepcion,registrada_por,anulada) values ('SOL-2026-00010','C1','A','correo','Abierta','u1',now(),'u1',true)"
espera_error "rol fuera del catálogo" "insert into colaborador(id,nombre,rol) values ('u9','Nueve','jefe')"
espera_error "origen inválido" "update solicitud set origen='otro' where ref='SOL-2026-00001'"

# demostración
"$RAIZ/cargar_demo.sh" "$CONN" >/dev/null 2>&1 && { echo "OK   carga de demostración"; OK=$((OK+1)); } || { echo "FALLA carga de demostración"; FALLA=$((FALLA+1)); }
igual "demostración: no pisa solicitudes existentes (4 ya existían)" "select count(*) from solicitud where origen='demo'" "21"
igual "demostración: total de solicitudes" "select count(*) from solicitud" "25"
igual "demostración: clientes" "select count(*) from cliente" "16"
"$RAIZ/cargar_demo.sh" "$CONN" >/dev/null 2>&1
igual "demostración repetida no duplica" "select count(*) from solicitud" "25"
igual "contador ajustado" "select ultimo from contador_referencia where anio=2026" "25"
echo "---- $OK correctas, $FALLA fallidas"
[ "$FALLA" -eq 0 ]
