## Contexto

Aurora no tiene equipo de desarrollo y un proveedor externo administra respaldos (E07). Datos verificados el 25-nov-2026 en la documentación de Supabase:

- Los respaldos diarios automáticos se hacen en los planes Pro, Team y Enterprise; Pro conserva 7 días. Con solo respaldos diarios se pueden perder hasta 24 horas de datos.
- La recuperación al punto en el tiempo (PITR) es un complemento de pago que reduce la pérdida a minutos (peor caso de dos minutos según la documentación) y reemplaza a los respaldos diarios.
- Las fuentes están en `docs/plan-v2.md`. Los precios no se citan aquí: deben consultarse vigentes.

## Objetivos / No objetivos

- **Objetivos:** respaldo programado con resultado registrado, aviso de fallo, restauración comprobada y procedimiento.
- **No objetivos:** alta disponibilidad, réplicas ni recuperación ante desastre entre regiones.

## Decisiones

### D1. Respaldo nativo del proveedor como base (supuesto de diseño)

El ambiente de trabajo corre en un plan de Supabase con respaldos automáticos. PITR se evalúa solo si el caso fija un punto de recuperación menor a 24 horas (`[por definir]`).

### D2. Copia lógica complementaria programada (propuesta abierta)

Un trabajo programado en GitHub Actions ejecuta `pg_dump` cada día y guarda el archivo cifrado fuera de Supabase. Aporta tres cosas que el respaldo nativo no da por sí solo: un registro de resultado propio en `respaldo_registro`, un aviso de fallo (la falla del trabajo notifica por correo al administrador técnico) y una copia que no depende del proveedor de base de datos. Si el costo o la complejidad no se justifican, se descarta y el registro y el aviso se resuelven de otra forma.

### D3. Prueba de restauración en un proyecto distinto

Se restaura el último respaldo en un proyecto de prueba y se comparan los conteos de solicitudes y de cambios, y el tiempo de recuperación. La prueba debe estar registrada antes del piloto (E08). El tiempo no tiene meta en el caso: `[por definir]`.

### D4. Registro de resultados

Cada respaldo y cada prueba insertan una fila en `respaldo_registro` (tipo, resultado, detalle, usuario). La tabla es de solo inserción para el rol de la aplicación.

## Riesgos y compensaciones

- **Plan sin respaldos:** si el ambiente de trabajo se crea en el plan gratuito no habrá respaldos nativos; el cambio lo detecta y lo bloquea (tarea 1.2).
- **Respaldo no restaurable:** se mitiga con la prueba de restauración periódica, no solo con el respaldo.
- **Dependencia del proveedor (E07):** el procedimiento debe poder ejecutarlo quien tenga el rol de administrador técnico, siguiendo pasos escritos.

## Preguntas abiertas

Ver `proposal.md`.
