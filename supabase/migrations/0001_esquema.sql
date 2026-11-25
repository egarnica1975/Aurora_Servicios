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
