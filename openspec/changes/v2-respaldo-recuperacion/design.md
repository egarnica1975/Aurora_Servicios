## Contexto

Decisión del 25-nov-2026: proyecto académico, solución más económica y sin respaldos programados. Datos verificados el 25-nov-2026: según la documentación de Supabase, los respaldos automáticos diarios son de los planes de pago y para proyectos gratuitos recomienda exportar los datos con `supabase db dump` y conservar copias fuera del proveedor. Fuentes en `docs/plan-v2.md`.

## Objetivos / No objetivos

- **Objetivos:** poder sacar una copia completa de la base, comprobar que se restaura y dejar el procedimiento escrito.
- **No objetivos:** respaldo programado, aviso de fallo, recuperación al punto en el tiempo, alta disponibilidad.

## Decisiones

### D1. Volcado lógico con `pg_dump` o `supabase db dump` (supuesto)

El administrador técnico ejecuta el volcado desde su equipo con la cadena de conexión de la base. Se usa formato personalizado de `pg_dump` para poder restaurar con `pg_restore`. Nota de la documentación: `supabase db dump` entrega solo el esquema si no se indica `--data-only`; el procedimiento debe cubrir esquema y datos.

### D2. Registro del resultado

Tras cada volcado o prueba, el administrador técnico registra el resultado (fecha, tipo, éxito o fallo, conteos) en `respaldo_registro` a través de una operación de la API. La tabla es de solo inserción para el rol de la aplicación. El registro es manual: la V2 no puede detectar un volcado que nadie ejecutó.

### D3. Restauración en una base distinta

La prueba restaura el volcado en una base local o en un proyecto gratuito temporal (el plan gratuito permite hasta dos proyectos activos), y compara los conteos de solicitudes y de cambios. El tiempo de recuperación no tiene meta en el caso: `[por definir]`.

### D4. Protección del archivo

El volcado no se sube al repositorio; se guarda en un lugar con acceso restringido definido por Aurora `[por definir]`.

## Riesgos y compensaciones

- **Pérdida de datos entre volcados:** sin respaldo programado, todo lo registrado después del último volcado puede perderse. Se acepta por ser un proyecto académico y se declara como límite L08 abierto.
- **Olvido del volcado:** no hay aviso; la periodicidad queda como compromiso manual.
- **Pausa por inactividad del plan gratuito:** puede dejar la base sin servicio; se mitiga reactivándola y con el volcado reciente.

## Preguntas abiertas

Ver `proposal.md`.
