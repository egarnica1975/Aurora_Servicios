## Why

Sin despliegue, la V2 no sale del equipo de quien la construye. H1 exige ambientes separados, respaldo y control de acceso (E04, E08), y el caso limita el costo de operación a COP 300.000 al mes y la inversión a COP 12.000.000 (E10). El caso no tiene equipo de desarrollo (E07), así que el despliegue debe ser sencillo y repetible.

Este cambio entrega la publicación de la API y la interfaz, la gestión de secretos, la integración continua, el despliegue reversible y la verificación del costo. Corresponde a OP-11 y OP-12 del Horizonte 1.

## What Changes

- Despliegue de la API y de la interfaz en los ambientes de capacitación y de trabajo (nuevo).
- Gestión de secretos fuera del repositorio (nuevo).
- Integración continua que ejecuta pruebas y valida las especificaciones antes de desplegar (nuevo).
- Despliegue reproducible con posibilidad de volver a la versión anterior (nuevo).
- Documento de costos frente al límite del caso (nuevo).
- Observabilidad mínima (nuevo).

## Capabilities

### New Capabilities
- `despliegue`: publicación, secretos, ambientes, integración continua, reversión y costo.

### Modified Capabilities
Ninguna.

## Impact

- Depende de `v2-api-backend`, `v2-front-conectado` y `v2-respaldo-recuperacion`.
- Introduce costos recurrentes que deben compararse con COP 300.000 al mes; los precios se consultan vigentes y no se fijan aquí.

## Preguntas abiertas

1. Dónde se aloja la API: Vercel (FastAPI soportado en su runtime de Python, con arranque en frío) u otro servidor siempre encendido: `[por definir]`, se decide con una prueba de concepto temprana.
2. Uno o dos proyectos de Supabase, o dos esquemas en un proyecto: `[por definir]`, depende del costo.
3. Dominio, certificados y quién administra el DNS: `[por definir]`.
4. Herramienta de observabilidad y retención de registros: `[por definir]`.
5. ¿Cuánto cuesta cada componente hoy? Consultar precios vigentes antes de decidir.
