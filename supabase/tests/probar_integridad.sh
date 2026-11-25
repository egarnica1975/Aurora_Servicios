#!/usr/bin/env bash
# Pruebas de v2-integridad-historial sobre una base local VACÍA.
# Las pruebas "app" usan el rol aurora_app (sin privilegios de propietario).
# Uso: supabase/tests/probar_integridad.sh "<cadena de conexión>"
set -uo pipefail
CONN="${1:?Falta la cadena de conexión}"
RAIZ="$(cd "$(dirname "$0")/.." && pwd)"
export PGOPTIONS="-c client_min_messages=warning"
OK=0; FALLA=0
q()   { psql "$CONN" -Atq -v ON_ERROR_STOP=1 -c "$1" 2>&1; }
# app USUARIO MOTIVO "sql": una sola transacción con el rol de la aplicación
app() { psql "$CONN" -Atq -v ON_ERROR_STOP=1 -c "set role aurora_app; select set_config('app.usuario_id','$1',true), set_config('app.motivo','$2',true); $3" 2>&1; }
ok()    { echo "OK   $1"; OK=$((OK+1)); }
fail()  { echo "FALLA $1: $2"; FALLA=$((FALLA+1)); }
igual() { r=$(q "$2"); [ "$r" = "$3" ] && ok "$1" || fail "$1" "obtuvo '$r', esperaba '$3'"; }
app_ok()    { out=$(app "$2" "$3" "$4") && ok "$1" || fail "$1" "$out"; }
app_error() { out=$(app "$2" "$3" "$4") && fail "$1" "se aceptó" || ok "$1"; }
own_error() { out=$(q "$2") && fail "$1" "se aceptó" || ok "$1"; }

"$RAIZ/migrar.sh" "$CONN" >/dev/null || { echo "FALLA migraciones"; exit 1; }
q "insert into cliente values ('C1','Cliente Uno'),('C2','Cliente Dos');
   insert into colaborador(id,nombre,rol) values ('u1','Uno','agente'),('u2','Dos','coordinador'),('u3','Tres','agente');" >/dev/null
ANIO=$(q "select extract(year from now() at time zone 'America/Bogota')::int")
INS="insert into solicitud(cliente_id,asunto,canal,estado,responsable_id,fecha_recepcion,registrada_por) values"

# --- referencia y registro
app_ok "registrar sin indicar referencia" u1 "" "$INS ('C1','Entrega incompleta','correo','Abierta','u1', now() - interval '2 days','u1')"
igual "referencia asignada con formato y consecutivo" "select ref from solicitud" "SOL-$ANIO-00001"
igual "la historia registra el alta" "select campo||'|'||usuario_id from cambio" "registro|u1"
igual "fecha de recepción distinta de la de registro" "select fecha_recepcion < fecha_registro from solicitud" "t"
REF="SOL-$ANIO-00001"
app_error "la aplicación no puede indicar la referencia" u1 "" "insert into solicitud(ref,cliente_id,asunto,canal,estado,responsable_id,fecha_recepcion,registrada_por) values ('SOL-2026-99999','C1','A','correo','Abierta','u1',now(),'u1')"
app_error "la aplicación no puede indicar la fecha de registro" u1 "" "insert into solicitud(cliente_id,asunto,canal,estado,responsable_id,fecha_recepcion,registrada_por,fecha_registro) values ('C1','A','correo','Abierta','u1',now(),'u1','2000-01-01')"
app_error "la aplicación no puede escribir historia directamente" u1 "" "insert into cambio(solicitud_ref,usuario_id,campo) values ('$REF','u1','estado')"

# --- historia generada
app_ok "cambio de estado por la aplicación" u1 "" "update solicitud set estado='En gestión' where ref='$REF'"
igual "historia: estado anterior y nuevo con usuario" "select anterior||'>'||nuevo||'|'||usuario_id from cambio where campo='estado'" "Abierta>En gestión|u1"
igual "historia: fecha del servidor" "select (fecha > now() - interval '1 minute') from cambio where campo='estado'" "t"
app_ok "cambio de asunto con SQL directo identificando al usuario" u2 "" "update solicitud set asunto='Entrega incompleta de resmas' where ref='$REF'"
igual "historia: el SQL directo queda registrado" "select usuario_id from cambio where campo='asunto'" "u2"
out=$(q "update solicitud set asunto='Sin autor' where ref='$REF'") && fail "cambio sin autor" "se aceptó" || ok "cambio sin autor es rechazado"
igual "cambio sin autor no modificó la solicitud" "select asunto from solicitud where ref='$REF'" "Entrega incompleta de resmas"
app_ok "cambio de pedido y cliente" u1 "" "update solicitud set pedido_ref='PED1', cliente_id='C2' where ref='$REF'"
igual "historia: pedido y cliente con nombres" "select string_agg(campo||':'||anterior||'>'||nuevo, ';' order by campo) from cambio where campo in ('pedido','cliente')" "cliente:Cliente Uno>Cliente Dos;pedido:(sin pedido)>PED1"

# --- reasignación
app_error "reasignar sin motivo" u2 "" "update solicitud set responsable_id='u3' where ref='$REF'"
igual "responsable no cambió" "select responsable_id from solicitud where ref='$REF'" "u1"
app_ok "reasignar con motivo" u2 "Ausencia de Uno" "update solicitud set responsable_id='u3' where ref='$REF'"
igual "historia de reasignación" "select anterior||'>'||nuevo||'|'||usuario_id||'|'||motivo from cambio where campo='responsable'" "Uno>Tres|u2|Ausencia de Uno"

# --- campos fijos
app_error "no se puede cambiar la referencia" u1 "" "update solicitud set ref='SOL-2026-00099' where ref='$REF'"
own_error "propietario tampoco cambia la referencia" "update solicitud set ref='SOL-2026-00099' where ref='$REF'"
own_error "no se puede cambiar la fecha de registro" "update solicitud set fecha_registro=now() where ref='$REF'"
own_error "no se puede cambiar quién registró" "update solicitud set registrada_por='u3' where ref='$REF'"
own_error "no se puede cambiar el origen" "update solicitud set origen='demo' where ref='$REF'"
app_error "la aplicación no puede tocar columnas fijas" u1 "" "update solicitud set fecha_registro=now() where ref='$REF'"

# --- inmutabilidad
app_error "app: no modifica un cambio" u2 "" "update cambio set nuevo='x'"
app_error "app: no borra un cambio" u2 "" "delete from cambio"
own_error "propietario: trigger rechaza modificar un cambio" "update cambio set nuevo='x'"
own_error "propietario: trigger rechaza borrar un cambio" "delete from cambio"
own_error "propietario: no se puede truncar la historia" "truncate cambio"
app_ok "app: inserta auditoría" u2 "" "insert into auditoria(fecha,usuario_id,accion) values ('2000-01-01','u2','ingreso')"
igual "auditoría con fecha del servidor" "select fecha > now() - interval '1 minute' from auditoria" "t"
app_error "app: no modifica la auditoría" u2 "" "update auditoria set accion='x'"
own_error "propietario: trigger rechaza borrar auditoría" "delete from auditoria"
app_ok "app: registra un respaldo" u3 "" "insert into respaldo_registro(tipo,resultado) values ('volcado','exitoso')"
own_error "respaldo_registro es inmutable" "update respaldo_registro set resultado='x'"

# --- sin borrado y anulación
app_error "app: no borra solicitudes" u2 "" "delete from solicitud"
own_error "propietario: trigger rechaza borrar solicitudes" "delete from solicitud"
app_error "anular sin motivo" u2 "" "update solicitud set anulada=true, motivo_anulacion='x' where ref='$REF'"
app_ok "anular con motivo" u2 "Duplicada" "update solicitud set anulada=true, motivo_anulacion='Duplicada' where ref='$REF'"
igual "la solicitud anulada sigue existiendo con su historia" "select (select anulada from solicitud where ref='$REF') || '|' || (select count(*) from cambio where solicitud_ref='$REF')" "true|7"
igual "historia de la anulación" "select motivo from cambio where campo='anulada'" "Duplicada"
app_error "una solicitud anulada no se reabre" u2 "Otro" "update solicitud set anulada=false, motivo_anulacion=null where ref='$REF'"

# --- concurrencia y cambio de año
for i in $(seq 1 20); do
  psql "$CONN" -Atq -c "begin; $INS ('C1','Concurrente $i','correo','Abierta','u1',now(),'u1'); select pg_sleep(0.1); commit;" >/dev/null 2>&1 &
done
wait
igual "20 registros simultáneos: referencias distintas" "select count(distinct ref) from solicitud where asunto like 'Concurrente %'" "20"
igual "20 registros simultáneos: consecutivo sin huecos" "select count(*) from contador_referencia c, solicitud s where c.anio=$ANIO and s.ref='SOL-$ANIO-'||lpad(c.ultimo::text,5,'0')" "1"
igual "el contador coincide con el número de solicitudes del año" "select ultimo from contador_referencia where anio=$ANIO" "21"
out=$(q "$INS ('C1','Primera del año','correo','Abierta','u1',now(),'u1')" 2>&1); 
q "insert into solicitud(cliente_id,asunto,canal,estado,responsable_id,fecha_recepcion,registrada_por,fecha_registro) values ('C1','Año nuevo','correo','Abierta','u1','2027-01-04','u1','2027-01-05 10:00-05')" >/dev/null
igual "cambio de año: reinicia el consecutivo" "select ref from solicitud where asunto='Año nuevo'" "SOL-2027-00001"
igual "una transacción fallida no consume consecutivo" "select (select ultimo from contador_referencia where anio=2027)" "1"
q "begin; $INS ('C1','Falla','paloma','Abierta','u1',now(),'u1'); commit;" >/dev/null 2>&1
igual "tras un fallo el contador no avanzó" "select ultimo from contador_referencia where anio=$ANIO" "22"
echo "---- $OK correctas, $FALLA fallidas"
[ "$FALLA" -eq 0 ]
