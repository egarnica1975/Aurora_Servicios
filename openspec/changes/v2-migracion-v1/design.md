## Contexto

El respaldo de la V1 es un JSON con `version: 1`, `ambiente`, `clientes`, `colaboradores`, `solicitudes`, `cambios`, `auditoria`, `respaldos` y `contadores`. Las solicitudes llevan su `id` igual a la referencia. Los cambios guardan nombres de persona en `anterior` y `nuevo` para responsable y cliente.

## Objetivos / No objetivos

- **Objetivos:** cargar sin perder identidad ni historia, verificar por conteos, ser repetible.
- **No objetivos:** convertir la historia de la V1 en historia «verificada» de la V2; migrar cuentas con contraseña (no existen en la V1).

## Decisiones

### D1. Carga con un script de Python dentro de una sola transacción (supuesto)

Un script (`api/scripts/migrar_v1.py`) lee el JSON, valida estructura y ambiente, y carga todo en una transacción: o entra todo o nada. Reutiliza la validación de la V1 (versión y ambiente).

### D2. Cómo conviven los triggers con la carga

Los triggers de historia (`v2-integridad-historial`) no deben duplicar la historia al insertar solicitudes migradas. Se propone una configuración de transacción `app.migracion = 'v1'` que solo el rol de migración puede fijar, con la que el trigger no genera historia al insertar y la fila de `cambio` se inserta tal como viene, con `origen = 'v1'`. El rol de la aplicación no puede usarla.

### D3. Idempotencia

La clave natural es la referencia. Si una referencia ya existe con `origen = 'v1'` el script la omite y lo informa; si existe con otro origen aborta. El contador del año se ajusta al máximo importado.

### D4. Colaboradores sin cuenta

Los colaboradores se cargan con `auth_user_id` nulo: figuran como «pendiente de cuenta» y no pueden ingresar hasta que el administrador técnico les cree una cuenta en `v2-api-backend`. La V1 no tiene contraseñas, así que no hay credenciales que migrar.

### D5. Honestidad sobre el origen

Cada fila migrada lleva `origen = 'v1'` y la auditoría registra la migración con conteos. Un archivo de la V1 editado a mano entra tal cual: la migración no puede certificar su integridad.

## Riesgos y compensaciones

- **Archivo alterado:** declarado en D5; la marca de origen permite distinguir esos datos.
- **Nombres en lugar de identificadores en la historia:** los cambios de responsable y cliente guardan el nombre; se conserva así, sin reinterpretar.
- **Colisión de referencias:** si el ambiente destino ya tiene solicitudes de la V2, el script aborta (D3).

## Preguntas abiertas

Ver `proposal.md`.
