-- Instalación completa de la base de datos de Aurora V2 (generado por construir_sql.py)

-- ===== 0001_esquema.sql =====
-- 0001 · Esquema relacional de H1 (v2-modelo-de-datos, D3)
create table canal  (nombre text primary key);
create table estado (nombre text primary key);

create table cliente (
  id text primary key,
  nombre text not null check (btrim(nombre) <> '')
);

create table colaborador (
  id text primary key,
  auth_user_id uuid unique,
  nombre text not null check (btrim(nombre) <> ''),
  rol text not null check (rol in ('agente','coordinador','consulta','administrador técnico')),
  ausente boolean not null default false,
  activo boolean not null default true
);

create table contador_referencia (
  anio int primary key,
  ultimo int not null check (ultimo >= 0)
);

create table solicitud (
  ref text primary key check (ref ~ '^SOL-[0-9]{4}-[0-9]{5}$'),
  cliente_id text not null references cliente(id),
  contacto_nombre text,
  contacto_medio text,
  check ((contacto_nombre is null) = (contacto_medio is null)),
  pedido_ref text,
  asunto text not null check (btrim(asunto) <> ''),
  canal text not null references canal(nombre),
  estado text not null references estado(nombre),
  responsable_id text not null references colaborador(id),
  fecha_recepcion timestamptz not null,
  fecha_registro timestamptz not null default now(),
  registrada_por text not null references colaborador(id),
  anulada boolean not null default false,
  motivo_anulacion text,
  check (anulada = (motivo_anulacion is not null)),
  origen text not null default 'v2' check (origen in ('v2','demo'))
);
create index solicitud_cliente_idx on solicitud(cliente_id);
create index solicitud_pedido_idx on solicitud(pedido_ref);
create index solicitud_responsable_idx on solicitud(responsable_id);

create table cambio (
  id bigint generated always as identity primary key,
  solicitud_ref text not null references solicitud(ref),
  fecha timestamptz not null default now(),
  usuario_id text not null references colaborador(id),
  campo text not null,
  anterior text not null default '',
  nuevo text not null default '',
  motivo text not null default '',
  origen text not null default 'v2' check (origen in ('v2','demo'))
);
create index cambio_solicitud_idx on cambio(solicitud_ref);

create table auditoria (
  id bigint generated always as identity primary key,
  fecha timestamptz not null default now(),
  usuario_id text,
  accion text not null,
  detalle text not null default ''
);

create table respaldo_registro (
  id bigint generated always as identity primary key,
  fecha timestamptz not null default now(),
  tipo text not null,
  resultado text not null,
  detalle text not null default '',
  usuario_id text
);

-- ===== 0002_catalogos.sql =====
-- 0002 · Catálogos iniciales (mismos nombres que la V1)
insert into canal(nombre) values ('mensajería'), ('correo'), ('teléfono');
insert into estado(nombre) values ('Abierta'), ('En gestión');

-- ===== 0003_integridad.sql =====
-- 0003 · Integridad e historial (v2-integridad-historial)
-- La historia, la referencia y la inmutabilidad las impone la base de datos.

-- ---------- Contexto de la transacción ----------
create function usuario_actual() returns text language sql stable as
  $$ select nullif(btrim(coalesce(current_setting('app.usuario_id', true), '')), '') $$;
create function motivo_actual() returns text language sql stable as
  $$ select nullif(btrim(coalesce(current_setting('app.motivo', true), '')), '') $$;

-- ---------- Referencia única por año (D3) ----------
create function siguiente_referencia(p_anio int) returns text
language plpgsql security definer set search_path = public as $$
declare n int;
begin
  insert into contador_referencia(anio, ultimo) values (p_anio, 1)
  on conflict (anio) do update set ultimo = contador_referencia.ultimo + 1
  returning ultimo into n;
  return 'SOL-' || p_anio || '-' || lpad(n::text, 5, '0');
end $$;

create function solicitud_antes_insertar() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  if new.ref is null then
    new.ref := siguiente_referencia(extract(year from new.fecha_registro at time zone 'America/Bogota')::int);
  end if;
  return new;
end $$;
create trigger solicitud_ref_bi before insert on solicitud
  for each row execute function solicitud_antes_insertar();

-- ---------- Validaciones de cambios en solicitud (D1, D2, D4) ----------
create function solicitud_validar_cambio() returns trigger
language plpgsql set search_path = public as $$
begin
  if new.ref is distinct from old.ref or new.fecha_registro is distinct from old.fecha_registro
     or new.registrada_por is distinct from old.registrada_por or new.origen is distinct from old.origen then
    raise exception 'La referencia, la fecha de registro, quien registró y el origen no se pueden modificar';
  end if;
  if old.anulada and (new.anulada is distinct from old.anulada or new.motivo_anulacion is distinct from old.motivo_anulacion) then
    raise exception 'Una solicitud anulada no se puede modificar';
  end if;
  if (new.cliente_id, new.pedido_ref, new.asunto, new.canal, new.estado, new.responsable_id, new.anulada)
     is distinct from (old.cliente_id, old.pedido_ref, old.asunto, old.canal, old.estado, old.responsable_id, old.anulada) then
    if usuario_actual() is null then
      raise exception 'Falta identificar al usuario que hace el cambio (app.usuario_id)';
    end if;
    if (new.responsable_id is distinct from old.responsable_id or new.anulada is distinct from old.anulada)
       and motivo_actual() is null then
      raise exception 'El cambio de responsable y la anulación exigen un motivo (app.motivo)';
    end if;
  end if;
  return new;
end $$;
create trigger solicitud_validar_bu before update on solicitud
  for each row execute function solicitud_validar_cambio();

-- ---------- Historia generada por la base de datos (D1) ----------
create function solicitud_registrar_cambios() returns trigger
language plpgsql security definer set search_path = public as $$
declare u text := usuario_actual(); m text := coalesce(motivo_actual(), '');
begin
  if tg_op = 'INSERT' then
    insert into cambio(solicitud_ref, fecha, usuario_id, campo, nuevo, origen)
    values (new.ref, new.fecha_registro, new.registrada_por, 'registro',
            'Solicitud registrada con estado ' || new.estado, new.origen);
    return new;
  end if;
  if new.cliente_id is distinct from old.cliente_id then
    insert into cambio(solicitud_ref, usuario_id, campo, anterior, nuevo, motivo)
    values (new.ref, u, 'cliente', (select nombre from cliente where id = old.cliente_id),
            (select nombre from cliente where id = new.cliente_id), '');
  end if;
  if new.pedido_ref is distinct from old.pedido_ref then
    insert into cambio(solicitud_ref, usuario_id, campo, anterior, nuevo)
    values (new.ref, u, 'pedido', coalesce(old.pedido_ref, '(sin pedido)'), coalesce(new.pedido_ref, '(sin pedido)'));
  end if;
  if new.asunto is distinct from old.asunto then
    insert into cambio(solicitud_ref, usuario_id, campo, anterior, nuevo)
    values (new.ref, u, 'asunto', old.asunto, new.asunto);
  end if;
  if new.canal is distinct from old.canal then
    insert into cambio(solicitud_ref, usuario_id, campo, anterior, nuevo)
    values (new.ref, u, 'canal', old.canal, new.canal);
  end if;
  if new.estado is distinct from old.estado then
    insert into cambio(solicitud_ref, usuario_id, campo, anterior, nuevo)
    values (new.ref, u, 'estado', old.estado, new.estado);
  end if;
  if new.responsable_id is distinct from old.responsable_id then
    insert into cambio(solicitud_ref, usuario_id, campo, anterior, nuevo, motivo)
    values (new.ref, u, 'responsable', (select nombre from colaborador where id = old.responsable_id),
            (select nombre from colaborador where id = new.responsable_id), m);
  end if;
  if new.anulada is distinct from old.anulada then
    insert into cambio(solicitud_ref, usuario_id, campo, anterior, nuevo, motivo)
    values (new.ref, u, 'anulada', 'No', 'Sí', m);
  end if;
  return new;
end $$;
create trigger solicitud_historia_ai after insert on solicitud
  for each row execute function solicitud_registrar_cambios();
create trigger solicitud_historia_au after update on solicitud
  for each row execute function solicitud_registrar_cambios();

-- ---------- Fecha del servidor en registros de apoyo ----------
create function fecha_del_servidor() returns trigger language plpgsql as
  $$ begin new.fecha := now(); return new; end $$;
create trigger auditoria_fecha_bi before insert on auditoria for each row execute function fecha_del_servidor();
create trigger respaldo_fecha_bi before insert on respaldo_registro for each row execute function fecha_del_servidor();

-- ---------- Inmutabilidad (D2) ----------
create function rechazar_modificacion() returns trigger language plpgsql as $$
begin
  raise exception 'Operación % no permitida sobre %: el registro es inmutable', tg_op, tg_table_name;
end $$;
create trigger cambio_inmutable_bud before update or delete on cambio for each row execute function rechazar_modificacion();
create trigger auditoria_inmutable_bud before update or delete on auditoria for each row execute function rechazar_modificacion();
create trigger respaldo_inmutable_bud before update or delete on respaldo_registro for each row execute function rechazar_modificacion();
create trigger cambio_sin_truncar before truncate on cambio for each statement execute function rechazar_modificacion();
create trigger auditoria_sin_truncar before truncate on auditoria for each statement execute function rechazar_modificacion();
create trigger respaldo_sin_truncar before truncate on respaldo_registro for each statement execute function rechazar_modificacion();
create trigger solicitud_sin_borrar before delete on solicitud for each row execute function rechazar_modificacion();
create trigger solicitud_sin_truncar before truncate on solicitud for each statement execute function rechazar_modificacion();

-- ---------- Rol de la aplicación sin privilegios de modificación ----------
do $$ begin
  if not exists (select 1 from pg_roles where rolname = 'aurora_app') then create role aurora_app nologin; end if;
end $$;
grant usage on schema public to aurora_app;
grant select on all tables in schema public to aurora_app;
grant insert on auditoria, respaldo_registro to aurora_app;
grant insert on cliente, colaborador to aurora_app;
grant update (nombre) on cliente to aurora_app;
grant update (nombre, rol, ausente, activo, auth_user_id) on colaborador to aurora_app;
grant insert (cliente_id, contacto_nombre, contacto_medio, pedido_ref, asunto, canal, estado, responsable_id,
              fecha_recepcion, registrada_por) on solicitud to aurora_app;
grant update (cliente_id, pedido_ref, asunto, canal, estado, responsable_id, anulada, motivo_anulacion) on solicitud to aurora_app;
grant usage, select on all sequences in schema public to aurora_app;

-- ===== 0004_seguridad_supabase.sql =====
-- 0004 · Seguridad en Supabase: la API de datos de Supabase (PostgREST) no debe poder leer ni escribir.
-- La única vía de acceso es el servidor FastAPI con el rol aurora_app.
do $$
declare t text;
begin
  -- 1. Sin acceso para los roles públicos de Supabase (si existen)
  if exists (select 1 from pg_roles where rolname = 'anon') then
    revoke all on all tables in schema public from anon;
    revoke all on all sequences in schema public from anon;
    revoke all on all functions in schema public from anon;
    alter default privileges in schema public revoke all on tables from anon;
    alter default privileges in schema public revoke all on sequences from anon;
    alter default privileges in schema public revoke all on functions from anon;
  end if;
  if exists (select 1 from pg_roles where rolname = 'authenticated') then
    revoke all on all tables in schema public from authenticated;
    revoke all on all sequences in schema public from authenticated;
    revoke all on all functions in schema public from authenticated;
    alter default privileges in schema public revoke all on tables from authenticated;
    alter default privileges in schema public revoke all on sequences from authenticated;
    alter default privileges in schema public revoke all on functions from authenticated;
  end if;
  -- 2. Seguridad por filas activada en todas las tablas; solo aurora_app tiene política
  for t in select tablename from pg_tables where schemaname = 'public' loop
    execute format('alter table public.%I enable row level security', t);
    execute format('create policy aurora_app_todo on public.%I for all to aurora_app using (true) with check (true)', t);
  end loop;
end $$;
-- Las funciones sensibles no son ejecutables por el público
revoke execute on function siguiente_referencia(int) from public;

-- ===== Registro de migraciones aplicadas =====
create schema if not exists supabase_migrations;
create table if not exists supabase_migrations.schema_migrations (version text primary key, statements text[], name text);
insert into supabase_migrations.schema_migrations(version,name) values ('0001','esquema'),('0002','catalogos'),('0003','integridad'),('0004','seguridad_supabase') on conflict do nothing;
