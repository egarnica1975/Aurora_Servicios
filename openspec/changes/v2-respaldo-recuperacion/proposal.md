## Why

En la V1 el respaldo es una exportación manual a JSON y no existe respaldo programado ni aviso de fallo (límites L08 y L09 del plan V2). H1 exige respaldo programado con registro de resultado, aviso de fallo y una prueba de recuperación exitosa y registrada antes del piloto (E04, E07, E08). El caso no tiene equipo de desarrollo y depende de un proveedor para respaldos (E07).

Este cambio entrega respaldo programado, registro de resultados, aviso de fallo, prueba de restauración en un proyecto aparte y el procedimiento documentado. Corresponde a OP-12 del Horizonte 1.

## What Changes

- Respaldo programado de la base de datos de trabajo (nuevo).
- Registro del resultado de cada respaldo en `respaldo_registro` (nuevo).
- Aviso al administrador técnico cuando un respaldo falla (nuevo).
- Prueba de restauración en un proyecto distinto, con conteos y tiempo registrados (nuevo).
- Procedimiento de recuperación documentado con responsables y último resultado (nuevo).

## Capabilities

### New Capabilities
- `respaldo-recuperacion`: respaldo programado, registro, aviso, restauración comprobada y procedimiento.

### Modified Capabilities
Ninguna.

## Impact

- Depende de `v2-modelo-de-datos` y de `v2-integridad-historial` (los conteos de la prueba incluyen cambios).
- El plan de Supabase del ambiente de trabajo debe incluir respaldos automáticos; según su documentación, el plan gratuito no los tiene. El costo es parte de la decisión D-12 del plan V2.
- Operación: el caso limita la operación a COP 300.000 al mes (E10).

## Preguntas abiertas

1. Frecuencia de respaldo y tiempo máximo aceptable de recuperación: `[por definir]` con el proveedor (heredada de H1). Con respaldos diarios nativos se pueden perder hasta 24 horas de datos.
2. Canal del aviso de fallo (correo, mensajería): `[por definir]`.
3. ¿Se guarda una copia lógica fuera del proveedor de base de datos? Se propone que sí (D2); depende del costo y de dónde se almacene.
4. Plazo de retención de los respaldos: `[por definir]`.
