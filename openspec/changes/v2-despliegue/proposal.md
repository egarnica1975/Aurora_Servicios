## Why

Sin despliegue, la V2 no sale del equipo de quien la construye. H1 exige control de acceso y protección de datos (E04, E08), y el caso limita el costo de operación a COP 300.000 al mes y la inversión a COP 12.000.000 (E10). El caso no tiene equipo de desarrollo (E07), así que el despliegue debe ser sencillo y repetible.

Este cambio entrega la publicación de la API y la interfaz, la gestión de secretos, la integración continua, el despliegue reversible y la verificación del costo. Corresponde a OP-11 y OP-12 del Horizonte 1.

## What Changes

- Despliegue de la API y de la interfaz en Vercel, conectadas al proyecto de Supabase (nuevo).
- Gestión de secretos fuera del repositorio (nuevo).
- Integración continua que ejecuta pruebas y valida las especificaciones antes de desplegar (nuevo).
- Despliegue reproducible con posibilidad de volver a la versión anterior (nuevo).
- Documento de costos frente al límite del caso (nuevo).
- Observabilidad mínima (nuevo).

## Capabilities

### New Capabilities
- `despliegue`: publicación, secretos, conexión cifrada, integración continua, reversión, costo y observabilidad.

### Modified Capabilities
Ninguna.

## Impact

- Depende de `v2-api-backend`, `v2-front-conectado` y `v2-respaldo-recuperacion`.
- Proyecto académico no comercial: se usan los planes gratuitos de Supabase y Vercel (Hobby), con costo previsto de USD 0 (ver `docs/costos-v2.md`). Si el uso pasara a comercial, Vercel Hobby deja de ser apropiado.

## Preguntas abiertas

1. Alojamiento: decidido Vercel (FastAPI soportado en su runtime de Python, con arranque en frío); se valida con una prueba de concepto temprana y, si no cumple, se reabre.
2. Un solo proyecto de Supabase y un solo ambiente (decisión del 25-nov-2026); la capacitación queda en la V1.
3. Dominio, certificados y quién administra el DNS: `[por definir]`.
4. Herramienta de observabilidad y retención de registros: `[por definir]`.
5. ¿Cuánto cuesta cada componente hoy? Consultar precios vigentes antes de decidir.
