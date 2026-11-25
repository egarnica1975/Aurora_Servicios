## Why

En la V1 la historia es inmutable solo dentro de la aplicación: el JSON exportado se edita con cualquier editor y el contador de referencias vive en ese mismo archivo (límites L02, L03 y L10 del plan V2). H1 exige historia automática e inmutable, referencia única y responsable con evidencia (E03, E06, E07). Una base de datos puede imponer esas garantías aunque alguien acceda sin pasar por la aplicación.

Este cambio entrega la integridad en el motor: historia y auditoría de solo inserción, solicitudes sin borrado, referencia por secuencia transaccional, campos fijos y reasignación con motivo obligatorio. Corresponde a OP-03 y OP-05 del Horizonte 1.

## What Changes

- La base de datos genera la historia en la misma transacción que el cambio (nuevo).
- Historia y auditoría rechazan modificar o borrar (nuevo).
- Las solicitudes no se borran; se anulan con motivo (nuevo).
- La referencia se asigna con una secuencia anual dentro de la transacción (nuevo).
- La referencia, la fecha de registro y quien registró no cambian (nuevo).
- La reasignación sin motivo se rechaza en la base de datos (nuevo).

## Capabilities

### New Capabilities
- `integridad-datos`: historia y auditoría inmutables, sin borrado, referencia única y campos fijos.

### Modified Capabilities
Ninguna.

## Impact

- Depende de `v2-modelo-de-datos`.
- Las pruebas de este cambio se ejecutan directamente en SQL, sin API, para probar que las garantías no dependen de la aplicación.
- La inmutabilidad vale frente a los roles de la aplicación; una persona con acceso de superusuario al proveedor de base de datos sigue pudiendo alterar datos. Se declara en `design.md`.

## Preguntas abiertas

1. ¿Se añade un hash encadenado que haga detectable una alteración hecha por un superusuario? Se propone evaluarlo en un cambio posterior; el caso no lo exige.
2. ¿El proveedor externo tendrá acceso de superusuario? `[por definir]` con Aurora y el proveedor.
