## Why

Hoy el seguimiento de solicitudes vive en una hoja compartida (A02) en texto libre, con campos vacíos y sin historial, alimentada por copia manual desde correo y mensajería (E07). Solo 540 de 600 solicitudes quedan registradas y 420 tienen responsable (E03). No hay una referencia común, la responsabilidad se pierde cuando un agente se ausenta y los clientes repiten su historia (E06, E09). La gerencia no acepta mejora aparente por registrar menos (E03).

Este cambio entrega la base: que cada solicitud nazca completa, con referencia única, responsable con evidencia, historia de cambios automática, acceso individual y respaldo comprobable. Corresponde al **Horizonte 1** de la hoja de ruta base y a las oportunidades OP-01, OP-02, OP-03, OP-04, OP-05, OP-11 y OP-12.

## What Changes

- Registro de solicitudes en una sola acción, con referencia única inmutable y campos obligatorios (nuevo).
- Listas controladas de canal y estado, en lugar de texto libre (nuevo).
- Responsable único y reasignación con evidencia, incluida la ausencia de un agente (nuevo).
- Historia de cambios automática e inmutable (nuevo).
- Cuentas individuales, roles, datos de contacto mínimos y registro de auditoría (nuevo).
- Respaldo programado y recuperación comprobada (nuevo).
- La hoja A02 sigue operando en paralelo durante este horizonte; se retira en H2.

## Capabilities

### New Capabilities
- `solicitudes`: registro, referencia única, campos obligatorios, listas controladas y búsqueda.
- `asignacion`: responsable único, reasignación con evidencia y solicitudes sin responsable activo.
- `historial`: historia automática e inmutable de cambios.
- `acceso-datos`: cuentas individuales, roles, datos mínimos y auditoría.
- `respaldo`: respaldo programado y recuperación comprobada.

### Modified Capabilities
Ninguna (primer cambio).

## Impact

- Usuarios: 4 agentes, 1 coordinador, personal de ventas y logística en consulta, gerencia y el proveedor de soporte.
- Datos: crea las entidades Solicitud, Cambio de solicitud, Colaborador, Canal y Estado del modelo conceptual (ENT-04, ENT-08, ENT-09, ENT-05, ENT-06); Cliente, Contacto y Pedido se registran como datos de referencia hasta H2.
- El ERP no se toca.
- Presupuesto del caso: inversión hasta COP 12.000.000 y operación hasta COP 300.000 al mes; el costo de la opción elegida aún no se conoce.

## Preguntas abiertas

1. ¿Qué opción de realización se usa para APP-05 (A, B o C)? Decide el caso de negocio con los criterios de `design.md`.
2. Formato de la referencia (por ejemplo, prefijo y consecutivo): `[por definir]` con el coordinador.
3. Frecuencia de respaldo y tiempo máximo aceptable de recuperación: `[por definir]` con el proveedor.
4. ¿Cómo se registra la fecha real de recepción cuando el agente registra después del contacto? Se propone guardar ambas fechas (escenario en `solicitudes`).
5. Plazo de retención del historial y de las solicitudes: `[por definir]`.
