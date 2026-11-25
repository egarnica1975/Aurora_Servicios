## Why

La V1 guarda todo en objetos de JavaScript y solo persiste mediante archivos JSON exportados a mano (límites L01, L04, L11 del plan V2). Cerrar la pestaña pierde los datos no exportados, la integridad depende del código de la pantalla y el mismo archivo puede copiarse y editarse fuera de la aplicación. H1 exige referencia única, historia confiable y datos ficticios solo fuera del trabajo (E03, E07, E08); sin una base de datos relacional esos requisitos solo se cumplen de forma parcial (tabla D6 de `h1-registro-confiable`).

Este cambio entrega el cimiento de la V2: una base de datos PostgreSQL con el esquema relacional de H1, catálogos controlados, migraciones versionadas y datos de prueba ficticios fuera del ambiente de trabajo. Corresponde a las oportunidades OP-01, OP-04, OP-05 y OP-11 del Horizonte 1.

## What Changes

- Base de datos PostgreSQL (gestionada por Supabase) como fuente de verdad (nuevo).
- Esquema relacional de solicitudes, cambios, colaboradores, clientes y catálogos (nuevo).
- Migraciones versionadas en el repositorio (nuevo).
- Un solo proyecto de Supabase (ambiente de trabajo); la capacitación se mantiene en la V1 y no continúa en la V2 (nuevo).
- Carga reproducible de los datos ficticios de `datos-prueba/` solo en bases locales o de prueba (nuevo).

## Capabilities

### New Capabilities
- `base-de-datos`: persistencia, esquema relacional, catálogos, migraciones y datos de prueba fuera del trabajo.

### Modified Capabilities
Ninguna.

## Impact

- Es el primer paso de la V2; los demás cambios (`v2-integridad-historial`, `v2-respaldo-recuperacion`, `v2-api-backend`) dependen de este.
- No toca la V1 ni los cambios H1 a H3; la V1 sigue funcionando sin base de datos.
- El ERP no se toca.
- Costo: el caso fija operación hasta COP 300.000 al mes (E10). Proyecto académico no comercial: se usa la opción más económica (ver `docs/costos-v2.md`).

## Preguntas abiertas

1. Retención de solicitudes e historia: `[por definir]` (heredada de H1).
2. ¿Se modela el contacto como tabla propia? Se propone no hacerlo en este cambio: en V1 el contacto vive en la solicitud (nombre y un medio) y la entidad ENT-02 llega con la validación contra el ERP en H2.
