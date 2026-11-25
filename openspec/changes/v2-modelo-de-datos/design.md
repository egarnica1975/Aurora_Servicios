## Contexto

Aurora no tiene equipo de desarrollo; un proveedor externo administra accesos y respaldos (E07). Volumen: unas 600 solicitudes al mes (E01), por lo que el rendimiento no es una restricción. La V1 (HTML único) ya implementa las reglas de H1 en JavaScript; este cambio mueve la persistencia y las restricciones de integridad a la base de datos.

## Objetivos / No objetivos

- **Objetivos:** que los datos sobrevivan entre sesiones; que el motor imponga las restricciones de integridad; que el esquema sea reproducible desde cero con migraciones; que los datos ficticios no lleguen al ambiente de trabajo.
- **No objetivos:** historia inmutable y referencia transaccional (`v2-integridad-historial`), respaldo (`v2-respaldo-recuperacion`), API y autenticación (`v2-api-backend`).

## Decisiones

### D1. Motor: PostgreSQL gestionado por Supabase (decisión del 25-nov-2026)

Decidido por la dirección del curso. SQLite queda descartado para la nube porque guarda los datos en un archivo local y no sirve para varios usuarios simultáneos (supuesto de diseño; no se comparó con costos porque el caso no los trae).

### D2. Migraciones como SQL versionado (supuesto, por confirmar)

Archivos SQL numerados en `supabase/migrations/`, aplicados con la CLI de Supabase. Alternativa: Alembic, que es nativo de Python. Se elige SQL puro para que el proveedor pueda leer el esquema sin conocer Python.

### D3. Esquema (supuesto de diseño derivado del modelo conceptual y de la V1)

```sql
create table canal  (nombre text primary key);
create table estado (nombre text primary key);
create table cliente (id text primary key, nombre text not null);
create table colaborador (
  id text primary key,                    -- identificador único de acceso
  auth_user_id uuid unique,               -- vínculo con la autenticación; nulo = pendiente de cuenta
  nombre text not null,
  rol text not null check (rol in ('agente','coordinador','consulta','administrador técnico')),
  ausente boolean not null default false,
  activo boolean not null default true
);
create table contador_referencia (anio int primary key, ultimo int not null);
create table solicitud (
  ref text primary key check (ref ~ '^SOL-[0-9]{4}-[0-9]{5}$'),
  cliente_id text not null references cliente(id),
  contacto_nombre text, contacto_medio text,
  check ((contacto_nombre is null) = (contacto_medio is null)),
  pedido_ref text,                        -- referencia de texto; la validación contra el ERP es de H2
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
  origen text not null default 'v2'
);
create table cambio (
  id bigint generated always as identity primary key,
  solicitud_ref text not null references solicitud(ref),
  fecha timestamptz not null default now(),
  usuario_id text not null references colaborador(id),
  campo text not null,
  anterior text not null default '', nuevo text not null default '', motivo text not null default '',
  origen text not null default 'v2'
);
create table auditoria (
  id bigint generated always as identity primary key,
  fecha timestamptz not null default now(),
  usuario_id text, accion text not null, detalle text not null default ''
);
create table respaldo_registro (
  id bigint generated always as identity primary key,
  fecha timestamptz not null default now(),
  tipo text not null, resultado text not null, detalle text not null default '', usuario_id text
);
```

Los catálogos se cargan con «mensajería, correo, teléfono» y «Abierta, En gestión». La V2 usa los mismos nombres que la V1 para que la migración no traduzca valores.

### D4. Un solo ambiente y datos de demostración en CSV (decisión del usuario, 25-nov-2026)

Proyecto académico no comercial: un único proyecto de Supabase. La capacitación se queda en la V1. Los datos ficticios viven en CSV (`supabase/demo/`: clientes, colaboradores y solicitudes) y se cargan con `supabase/cargar_demo.sh` cuando haya que presentar, marcados con `origen = 'demo'`. La historia de esas solicitudes la genera la base de datos al insertarlas (cambio `v2-integridad-historial`); los CSV no traen cambios.

Consecuencia declarada: L11 (ambientes separados) no se cierra en la V2, y los datos de demostración conviven con los de trabajo. Como la historia es inmutable y las solicitudes no se borran, quitar la demostración exige un reinicio de la base por el rol propietario (fuera de los roles de la aplicación). Es un supuesto a confirmar.

### D5. Contacto dentro de la solicitud

Se conserva el modelo de la V1 (nombre y un medio en la solicitud, ambos o ninguno) por minimización de datos (E08). La tabla de contactos se difiere a H2.

## Riesgos y compensaciones

- **Demostración mezclada con trabajo:** sin ambiente separado, los datos de demostración quedan junto a los de trabajo; se marcan con `origen = 'demo'` y no hay datos reales durante el proyecto académico.
- **Dependencia del proveedor de nube:** el esquema es SQL estándar de PostgreSQL, lo que permite mover la base a otro servicio de PostgreSQL con un `pg_dump`.
- **Migraciones aplicadas a mano:** se prohíben por requisito; el proceso de integración continua verifica que el esquema se reconstruya desde cero.

## Preguntas abiertas

Ver `proposal.md`.
