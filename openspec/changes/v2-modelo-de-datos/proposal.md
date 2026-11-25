## Why

La V1 guarda todo en objetos de JavaScript y solo persiste mediante archivos JSON exportados a mano (límites L01, L04, L11 del plan V2). Cerrar la pestaña pierde los datos no exportados, la integridad depende del código de la pantalla y el mismo archivo puede copiarse y editarse fuera de la aplicación. H1 exige referencia única, historia confiable y capacitación con datos ficticios separados (E03, E07, E08); sin una base de datos relacional esos requisitos solo se cumplen de forma parcial (tabla D6 de `h1-registro-confiable`).

Este cambio entrega el cimiento de la V2: una base de datos PostgreSQL con el esquema relacional de H1, catálogos controlados, migraciones versionadas, ambientes separados y datos de prueba ficticios. Corresponde a las oportunidades OP-01, OP-04, OP-05 y OP-11 del Horizonte 1.

## What Changes

- Base de datos PostgreSQL (gestionada por Supabase) como fuente de verdad (nuevo).
- Esquema relacional de solicitudes, cambios, colaboradores, clientes y catálogos (nuevo).
- Migraciones versionadas en el repositorio (nuevo).
- Dos ambientes en bases separadas: capacitación y trabajo (nuevo).
- Carga reproducible de los datos ficticios de `datos-prueba/` (nuevo).

## Capabilities

### New Capabilities
- `base-de-datos`: persistencia, esquema relacional, catálogos, migraciones, ambientes y datos de prueba.

### Modified Capabilities
Ninguna.

## Impact

- Es el primer paso de la V2; los demás cambios (`v2-integridad-historial`, `v2-respaldo-recuperacion`, `v2-migracion-v1`, `v2-api-backend`) dependen de este.
- No toca la V1 ni los cambios H1 a H3; la V1 sigue funcionando sin base de datos.
- El ERP no se toca.
- Costo: el caso fija operación hasta COP 300.000 al mes (E10). El costo de dos proyectos en Supabase no está calculado: `[por definir]` (ver `docs/plan-v2.md`, D-12).

## Preguntas abiertas

1. ¿Dos proyectos de Supabase (capacitación y trabajo) o uno con dos esquemas? Se propone dos proyectos por la separación fuerte; depende del costo (`docs/plan-v2.md`, D-06).
2. Retención de solicitudes e historia: `[por definir]` (heredada de H1).
3. ¿Se modela el contacto como tabla propia? Se propone no hacerlo en este cambio: en V1 el contacto vive en la solicitud (nombre y un medio) y la entidad ENT-02 llega con la validación contra el ERP en H2.
