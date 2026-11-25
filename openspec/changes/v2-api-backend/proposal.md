## Why

En la V1 las reglas viven en el navegador: cualquiera puede alterar los datos desde fuera, no hay cuentas individuales, los roles se simulan, el ingreso fallido no se registra y el uso simultáneo no es posible (límites L04, L05, L06, L07 y L10). H1 exige cuentas individuales, permisos por rol, auditoría de ingreso y fallo, e integridad en el registro (E04, E07, E08).

Este cambio entrega una API en Python con FastAPI que expone las operaciones de H1, aplica las reglas y los permisos en el servidor y autentica con cuentas reales. Corresponde a OP-01, OP-05 y OP-11 del Horizonte 1.

## What Changes

- API con las operaciones de H1: registrar, consultar, filtrar, cambiar estado, reasignar, anular, consultar historia, clientes y administración (nuevo).
- Reglas de negocio en el servidor, separadas de las rutas (nuevo).
- Autenticación con cuentas individuales, cuatro roles aplicados en el servidor y auditoría de ingreso y fallo (nuevo).
- Alta, desactivación y asignación de cuentas por el administrador técnico, sin borrar historia (nuevo).
- Pruebas de contrato que cubren los escenarios de H1 (nuevo).

## Capabilities

### New Capabilities
- `api-solicitudes`: operaciones de H1 expuestas, reglas en el servidor, errores, concurrencia y pruebas de contrato.
- `autenticacion`: cuentas, roles, sesión, auditoría de ingreso y administración de usuarios.

### Modified Capabilities
Ninguna.

## Impact

- Depende de `v2-modelo-de-datos` y `v2-integridad-historial`.
- Reemplaza la lógica del módulo `Negocio` de la V1; sus funciones sirven como referencia de comportamiento.
- Define el contrato que consume `v2-front-conectado`.

## Preguntas abiertas

1. Expiración de la sesión y política de contraseñas: `[por definir]`.
2. Mecanismo para registrar el ingreso fallido: Supabase Auth no garantiza exponer los fallos, por eso se propone que el ingreso pase por la API (D3). Verificar en la prueba de concepto.
3. Acciones del administrador técnico sobre el contenido de las solicitudes: el caso lo excluye de la lectura del contenido (E04); la forma de aplicarlo en la base de datos queda como supuesto (D4).
4. Límite de solicitudes por página y de resultados de búsqueda: `[por definir]`.
