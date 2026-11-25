## Contexto

Datos verificados el 25-nov-2026 (fuentes en `docs/plan-v2.md`): Vercel documenta soporte para FastAPI con su runtime de Python, con funciones sin estado y posible arranque en frío; Supabase ofrece respaldos diarios solo en planes de pago.

## Objetivos / No objetivos

- **Objetivos:** despliegue sencillo, repetible y reversible; costo dentro del límite; secretos protegidos.
- **No objetivos:** alta disponibilidad multirregión, autoescalado complejo, contenedores orquestados.

## Decisiones

### D1. Prueba de concepto de alojamiento primero (supuesto)

Antes de construir el resto, desplegar una API mínima con conexión a Supabase en la opción elegida y medir arranque en frío, conexiones a la base y costo. Si Vercel no cumple (por ejemplo por el manejo de conexiones), se usa un servidor siempre encendido.

### D2. Conexiones a la base de datos

Funciones sin estado agotan conexiones; se usa el pooler de conexiones de Supabase. A verificar en la prueba de concepto (D1).

### D3. Secretos

Variables de entorno del proveedor y de GitHub Actions; ningún secreto en el repositorio. Un escaneo de secretos corre en la integración continua.

### D4. Integración continua

GitHub Actions ejecuta `openspec validate --all --strict`, las pruebas de contrato y el análisis básico; el despliegue solo ocurre si todo pasa y sobre la rama `main`.

### D5. Reversión

Cada despliegue de la API es una versión identificable; volver a la anterior no requiere reconstruir. Las migraciones de base de datos son hacia adelante; las que no pueden revertirse se documentan.

### D6. Costo

Un documento `docs/costos-v2.md` lista cada servicio, su plan, su precio vigente en la fecha de consulta y el total mensual, comparado con COP 300.000. No se estima sin consultar los precios.

## Riesgos y compensaciones

- **Costo sobre el límite:** los respaldos de pago pueden empujar el total; se evalúa un solo proyecto y alternativas antes de decidir.
- **Arranque en frío:** puede degradar la experiencia del registro; medir en D1.

## Preguntas abiertas

Ver `proposal.md`.
