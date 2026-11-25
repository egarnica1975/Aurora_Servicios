## Why

Los datos que se registren en la V1, incluidos los del piloto, viven en archivos JSON de respaldo (límite L01). Si la V2 no puede recibirlos, el piloto con la V1 no deja continuidad. H1 exige recuperación comprobada con conteos que coincidan (E08).

Este cambio entrega una importación del respaldo JSON de la V1 a la base de datos de la V2, conservando referencias, fechas y historia, con verificación por conteos y sin duplicar al repetirse. Corresponde a OP-05 y OP-12 del Horizonte 1.

## What Changes

- Importación de un respaldo JSON de la V1 a la base de datos (nuevo).
- Conservación de referencias, fechas, responsables, cambios y motivos (nuevo).
- Informe de conteos origen y destino, todo o nada (nuevo).
- Importación repetible sin duplicados (nuevo).
- Marca del origen de los datos migrados (nuevo).
- Colaboradores migrados sin acceso hasta que se les asigne una cuenta (nuevo).

## Capabilities

### New Capabilities
- `migracion-v1`: importación del respaldo JSON de la V1 con conservación de identidad y verificación.

### Modified Capabilities
Ninguna.

## Impact

- Depende de `v2-modelo-de-datos` y de `v2-integridad-historial` (los triggers deben permitir cargar historia existente sin duplicarla: ver `design.md`).
- Los datos de la V1 vienen de un archivo editable; se marcan como migrados para no presentarlos como si hubieran pasado por la historia inmutable de la V2.
- Solo se migra el ambiente de la V1 con el mismo nombre; capacitación y trabajo no se mezclan.

## Preguntas abiertas

1. ¿Se migrará el piloto de la V1 al ambiente de trabajo de la V2, o el piloto se hará directamente en la V2? Decide Aurora; si el piloto ocurre en la V2 este cambio solo sirve para capacitación y pruebas.
2. ¿Qué se hace con el registro de auditoría de la V1? Se propone migrarlo marcado como origen V1.
