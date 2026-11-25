#!/usr/bin/env bash
# Carga los datos ficticios de demostración desde supabase/demo/*.csv.
# Repetible: no duplica. Marca las solicitudes con origen 'demo'.
# Uso: supabase/cargar_demo.sh "<cadena de conexión>"
set -euo pipefail
CONN="${1:?Falta la cadena de conexión}"
D="$(cd "$(dirname "$0")" && pwd)/demo"
psql "$CONN" -v ON_ERROR_STOP=1 -q --single-transaction <<SQL
create temp table t_cli (id text, nombre text);
create temp table t_col (id text, nombre text, rol text, ausente boolean);
create temp table t_sol (ref text, cliente_id text, contacto_nombre text, contacto_medio text, pedido_ref text,
  asunto text, canal text, estado text, responsable_id text, fecha_recepcion timestamptz, fecha_registro timestamptz,
  registrada_por text, anulada boolean, motivo_anulacion text);
\copy t_cli from '$D/clientes.csv' csv header
\copy t_col from '$D/colaboradores.csv' csv header
\copy t_sol from '$D/solicitudes.csv' csv header
insert into cliente(id,nombre) select id,nombre from t_cli on conflict do nothing;
insert into colaborador(id,nombre,rol,ausente) select id,nombre,rol,ausente from t_col on conflict do nothing;
insert into solicitud(ref,cliente_id,contacto_nombre,contacto_medio,pedido_ref,asunto,canal,estado,responsable_id,
  fecha_recepcion,fecha_registro,registrada_por,anulada,motivo_anulacion,origen)
select ref,cliente_id,nullif(contacto_nombre,''),nullif(contacto_medio,''),nullif(pedido_ref,''),asunto,canal,estado,
  responsable_id,fecha_recepcion,fecha_registro,registrada_por,anulada,nullif(motivo_anulacion,''),'demo'
from t_sol on conflict do nothing;
insert into contador_referencia(anio,ultimo)
select substring(ref from 5 for 4)::int, max(substring(ref from 10)::int) from t_sol group by 1
on conflict (anio) do update set ultimo = greatest(contador_referencia.ultimo, excluded.ultimo);
SQL
echo "demostración cargada"
