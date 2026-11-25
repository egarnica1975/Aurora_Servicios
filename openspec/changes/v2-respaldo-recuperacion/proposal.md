## Why

En la V1 el respaldo es una exportación manual a JSON dentro de la aplicación (límites L08 y L09 del plan V2). H1 pide respaldo programado, aviso de fallo y una prueba de recuperación registrada (E04, E07, E08). El proyecto es académico y no comercial: se elige la opción más económica y se sacrifica lo no crítico (decisión del 25-nov-2026).

Este cambio entrega respaldo **manual por volcado (dump) de la base de datos**, con registro del resultado, prueba de restauración en una base aparte y procedimiento documentado. **No** entrega respaldo programado ni aviso de fallo: quedan fuera de la V2 y se declaran como límite abierto. Corresponde parcialmente a OP-12 del Horizonte 1.

## What Changes

- Respaldo manual de la base de datos mediante volcado lógico, ejecutado por el administrador técnico (nuevo).
- Registro del resultado de cada respaldo y de cada prueba en `respaldo_registro` (nuevo).
- Prueba de restauración en una base distinta (local o un proyecto gratuito temporal), con conteos registrados (nuevo).
- Procedimiento de respaldo y recuperación documentado (nuevo).
- Retirados del alcance de la V2: respaldo programado, aviso de fallo y copia automática fuera del proveedor.

## Capabilities

### New Capabilities
- `respaldo-recuperacion`: respaldo manual por volcado, registro, restauración comprobada y procedimiento.

### Modified Capabilities
Ninguna.

## Impact

- Depende de `v2-modelo-de-datos` y de `v2-integridad-historial` (los conteos de la prueba incluyen cambios).
- Costo: USD 0 adicional (ver `docs/costos-v2.md`). El plan gratuito de Supabase no tiene respaldos automáticos, así que el volcado manual es la única copia.
- El archivo de volcado contiene datos: debe guardarse fuera del repositorio y con acceso restringido.
- Límites que quedan abiertos frente a H1: L08 (respaldo programado y aviso de fallo). L09 (recuperación comprobada) sí se cierra.

## Preguntas abiertas

1. Decidido (25-nov): el volcado lo hace el administrador técnico una vez por semana.
2. Dónde se guarda el archivo y cuánto tiempo: `[por definir]`.
3. Decidido (25-nov): se acepta que el plan gratuito de Supabase se pause por inactividad y se reactive antes de usarlo.
