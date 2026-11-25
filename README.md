# Gestión de solicitudes · Comercial Aurora (versión 1)

Aplicación web de un solo archivo (`app/index.html`) para registrar y dar seguimiento a las solicitudes de clientes de Comercial Aurora, una distribuidora ficticia de suministros de oficina (caso de un curso de arquitectura empresarial). Implementa el cambio de OpenSpec `h1-registro-confiable`.

> **Versión 1: solo datos ficticios.** No tiene contraseñas, servidor ni respaldo programado. No cargues datos reales de clientes. Los límites exactos están en [Límites de la V1](#límites-de-la-v1).

## Cómo iniciar

1. Descarga o clona el repositorio.
2. Abre `app/index.html` con doble clic en un navegador actual (Chrome, Edge, Firefox o Safari). No requiere instalar nada.
3. La aplicación abre en el **ambiente de capacitación**, con datos ficticios ya cargados: 15 clientes, 6 colaboradores, 1 administrador técnico y 25 solicitudes.
4. Elige una persona en el selector de ingreso y explora según su rol.

## Roles de práctica (ambiente de capacitación)

| Persona | Rol | Qué puede hacer |
|---|---|---|
| Ana Ruiz, Luis Mora, Camila Pardo, Diego Salas | agente | Registrar solicitudes propias, editar las propias, asumir las que no tienen responsable activo |
| Marta Vélez | coordinador | Todo lo anterior, más reasignar, reasignar por lote, anular y marcar ausencias |
| Julián Ortiz (Ventas) | consulta | Ver la bandeja; no modifica |
| Soporte Técnico (proveedor) | administrador técnico | Cuentas, auditoría, respaldo y datos; no ve el contenido de las solicitudes |

## Cómo usar

- **Registrar:** pestaña «Registrar solicitud». Obligatorios: cliente, asunto, canal, fecha de recepción y responsable. La referencia tiene el formato `SOL-AAAA-NNNNN` y se muestra al guardar para comunicarla al cliente.
- **Buscar y ver historia:** pestaña «Bandeja». Filtra por referencia, cliente, pedido, responsable, estado o fechas; al elegir una fila se abre el detalle con la línea de tiempo.
- **Ausencias y lotes:** pestaña «Panel del coordinador».
- **Anular:** solo el coordinador y con motivo; las solicitudes nunca se eliminan.

## Guardar y recuperar datos

La aplicación guarda en memoria: **al cerrar o recargar la pestaña se pierden los cambios** que no hayas exportado. Un aviso del navegador lo recuerda.

1. Ingresa como administrador técnico → «Respaldo y datos» → **Exportar respaldo** (descarga un JSON).
2. Para volver a trabajar: «Importar respaldo» con ese archivo (reemplaza los datos del ambiente actual).
3. **Probar la recuperación:** «Probar recuperación» compara el número de solicitudes y de cambios del archivo con los datos actuales, sin reemplazar nada, y deja el resultado registrado.
4. **Importar clientes:** «Importar directorio de clientes» acepta CSV (`id,nombre`, con `,` o `;`) o JSON (lista de `{id, nombre}`). Hay ejemplos en `datos-prueba/`.

El ambiente de trabajo empieza vacío: crea la cuenta inicial del administrador técnico, luego las demás cuentas e importa el directorio de clientes. Los respaldos de un ambiente no se pueden importar en el otro.

## Límites de la V1

La tabla completa está en `openspec/changes/h1-registro-confiable/design.md` (D6) y el resultado de las pruebas en [`docs/verificacion-h1.md`](docs/verificacion-h1.md).

- **Cuentas y roles simulados:** se elige una persona de una lista; no hay contraseña ni bloqueo de acceso. Los permisos se aplican en pantalla y no son seguridad real.
- **Sin ingreso fallido:** la auditoría solo registra ingresos exitosos y acciones administrativas.
- **Historia inmutable dentro de la aplicación:** el archivo JSON exportado sí se puede editar fuera de ella.
- **Respaldo manual:** no hay respaldo programado ni aviso de fallo.
- **Un solo archivo de datos:** la unicidad de la referencia vale dentro de ese archivo; no hay uso simultáneo de varias personas.
- **Pendiente de definir** (`[por definir]`): frecuencia de respaldo y tiempo de recuperación, fecha real de recepción cuando se registra después del contacto, y plazo de retención.

La versión 2 (Supabase/PostgreSQL, Python y FastAPI) cierra estos límites. Está especificada en siete cambios `v2-*` de `openspec/changes/`; el plan de decisiones y ejecución está en [`docs/plan-v2.md`](docs/plan-v2.md).

## Desarrollo con OpenSpec y Claude Code

- Reglas del proyecto: [`CLAUDE.md`](CLAUDE.md). Guía paso a paso: [`docs/guia-v1-aurora.md`](docs/guia-v1-aurora.md).
- Skills en `.agents/skills/` (enlazadas desde `.claude/skills/`): `/openspec-explore`, `/openspec-propose`, `/openspec-apply-change`, `/openspec-update-change`, `/openspec-sync-specs`, `/openspec-archive-change`.
- Instalar la CLI si falta: `npm install -g @fission-ai/openspec@latest`.
- Validar antes de cada commit: `openspec validate --all --strict`.
- Orden de los cambios: H1 → archivar → H2 → archivar → H3. H2 modifica una especificación que crea H1.

## Pruebas

`python3 tests/verificar_h1.py` abre la aplicación en Chrome con Playwright, ejecuta un caso por escenario de H1 y escribe `docs/verificacion-h1.md`. Requiere Python, la librería `playwright` y Chrome; la ruta del navegador está en el script.

## Estructura

```
app/index.html            la aplicación (HTML, CSS y JavaScript)
datos-prueba/             datos ficticios en JSON y CSV
docs/                     guía V1, hoja de ruta base y verificación
tests/verificar_h1.py     pruebas de los escenarios
openspec/                 configuración, cambios H1-H3 y especificaciones
.agents/ .claude/         skills de OpenSpec para Claude Code
CLAUDE.md                 reglas del proyecto
```
