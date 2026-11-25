#!/usr/bin/env python3
"""Genera los dos archivos SQL para pegar en el Editor SQL de Supabase (sin instalar nada).
   - instalar_supabase.sql: migraciones 0001 a 0004 y su registro.
   - demo/demo_supabase.sql: datos de demostración, generados desde demo/*.csv.
Uso: python3 supabase/construir_sql.py"""
import csv, pathlib
R = pathlib.Path(__file__).parent

# --- instalación
partes = ['-- Instalación completa de la base de datos de Aurora V2 (generado por construir_sql.py)\n']
registro = []
for f in sorted((R / 'migrations').glob('*.sql')):
    v, n = f.stem.split('_', 1)
    partes.append(f'\n-- ===== {f.name} =====\n' + f.read_text(encoding='utf-8'))
    registro.append(f"('{v}','{n}')")
partes.append('\n-- ===== Registro de migraciones aplicadas =====\n'
  'create schema if not exists supabase_migrations;\n'
  'create table if not exists supabase_migrations.schema_migrations (version text primary key, statements text[], name text);\n'
  'insert into supabase_migrations.schema_migrations(version,name) values ' + ','.join(registro) + ' on conflict do nothing;\n')
(R / 'instalar_supabase.sql').write_text(''.join(partes), encoding='utf-8')

# --- demostración
def lit(x):
    return 'null' if x == '' else "'" + x.replace("'", "''") + "'"
def filas(nombre):
    with open(R / 'demo' / nombre, encoding='utf-8', newline='') as f:
        return list(csv.DictReader(f))
o = ['-- Datos ficticios de demostración (generado desde demo/*.csv). Repetible: no duplica.\n']
o.append('insert into cliente(id,nombre) values\n' + ',\n'.join(f"({lit(c['id'])},{lit(c['nombre'])})" for c in filas('clientes.csv')) + '\non conflict do nothing;\n')
o.append('insert into colaborador(id,nombre,rol,ausente) values\n' + ',\n'.join(f"({lit(c['id'])},{lit(c['nombre'])},{lit(c['rol'])},{c['ausente']})" for c in filas('colaboradores.csv')) + '\non conflict do nothing;\n')
sol = filas('solicitudes.csv')
cols = 'ref,cliente_id,contacto_nombre,contacto_medio,pedido_ref,asunto,canal,estado,responsable_id,fecha_recepcion,fecha_registro,registrada_por,anulada,motivo_anulacion'.split(',')
o.append('insert into solicitud(' + ','.join(cols) + ',origen) values\n' + ',\n'.join('(' + ','.join(('true' if s[c] == 'true' else 'false') if c == 'anulada' else lit(s[c]) for c in cols) + ",'demo')" for s in sol) + '\non conflict do nothing;\n')
o.append("insert into contador_referencia(anio,ultimo)\nselect substring(ref from 5 for 4)::int, max(substring(ref from 10)::int) from solicitud where origen='demo' group by 1\n"
         "on conflict (anio) do update set ultimo = greatest(contador_referencia.ultimo, excluded.ultimo);\n")
(R / 'demo' / 'demo_supabase.sql').write_text('\n'.join(o), encoding='utf-8')
print('listo')
