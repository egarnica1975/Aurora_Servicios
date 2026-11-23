# Especificación preliminar (OpenSpec): Registro único de solicitudes de Comercial Aurora

Caso ficticio. Esta carpeta es un **borrador para completar**: está escrita con el formato de OpenSpec (propuesta, especificaciones delta, diseño y tareas) y organizada en **tres cambios**, uno por horizonte de la hoja de ruta.

## Estado y límites

- El **paso 6 del ejercicio (brechas y hoja de ruta) aún no se ha ejecutado**. La agrupación en tres horizontes de `docs/hoja-de-ruta-base.md` se **deriva de las dependencias entre las 13 oportunidades OP-01 a OP-13** (supuesto de diseño). Reemplázala o confírmala cuando exista el paso 6; los tres cambios se reorganizan moviendo requisitos entre carpetas.
- Los requisitos describen **comportamiento** (qué), no tecnología (cómo). Por eso valen para cualquiera de las tres opciones de realización (A hoja mejorada, B herramienta de casos como servicio, C desarrollo a la medida) y sirven como criterios de aceptación para elegir. La decisión está abierta en `changes/h1-registro-confiable/design.md`.
- No se inventaron cifras. Lo que el caso no define aparece como `[por definir]` y se lista en «Preguntas abiertas» de cada propuesta.
- Las palabras clave `SHALL`, `WHEN` y `THEN` se dejan en inglés porque el validador de OpenSpec las busca; el resto del texto está en español.

## Validación realizada

Los tres cambios pasan `openspec validate <cambio> --strict` con OpenSpec 2.1.0. El de H2 muestra un aviso informativo esperado: su requisito modificado (`solicitudes`) solo se puede archivar cuando H1 ya esté archivado, porque modifica una especificación que H1 crea. Por eso se implementan y archivan en orden.

## Contenido

```
openspec/
├── config.yaml                          contexto y reglas para la IA
└── changes/
    ├── h1-registro-confiable/           Horizonte 1: registrar y asignar con evidencia
    ├── h2-ciclo-completo/               Horizonte 2: resolver, dar seguimiento y conectar
    └── h3-medicion-sostenibilidad/      Horizonte 3: medir y verificar
docs/
└── hoja-de-ruta-base.md                 agrupación en horizontes y trazabilidad
```

Cada cambio trae `proposal.md`, `design.md`, `tasks.md` y `specs/<capacidad>/spec.md`. La carpeta `openspec/specs/` queda vacía: se llena sola al archivar cada cambio.

## Cómo usarla

1. Instala OpenSpec (requiere Node.js): `npm install -g @fission-ai/openspec@latest`.
2. En tu repositorio ejecuta `openspec init` y elige tu asistente de IA.
3. Copia el contenido de la carpeta `openspec/` de este paquete sobre la que creó `init` (conserva tu `config.yaml` si ya ajustaste algo y fusiona el contexto).
4. Verifica el formato: `openspec list` y `openspec validate h1-registro-confiable`.
5. Completa los `[por definir]` con el coordinador de atención y el proveedor, y afina los requisitos con tu asistente.
6. Implementa por horizonte: aplica el cambio (en las versiones recientes, `/opsx:apply h1-registro-confiable`), verifica los escenarios y archívalo (`/opsx:archive`). Solo entonces empieza el siguiente. Los nombres de los comandos pueden variar según la versión: confirma con `openspec --help`.

## Trazabilidad

Cada requisito indica la oportunidad (OP-xx) que lo origina, los indicadores (K-xx) que lo miden y la fuente del caso (E01–E10). Los códigos están definidos en el Excel `Aurora_Subcapacidades_KPIs.xlsx` y en los diagramas AS-IS y TO-BE.

## Fuentes

- Caso: documento estratégico Comercial Aurora, versión 1, noviembre de 2026 (E01–E10).
- Estructura y formato de OpenSpec verificados en la documentación pública del proyecto (github.com/Fission-AI/openspec) y en el esquema `spec-driven`: propuesta → especificaciones → diseño → tareas; requisitos con `SHALL` y al menos un escenario `WHEN`/`THEN`.

## Configuración para Claude Code (SDD con OpenSpec)

- Las skills de OpenSpec están en `.agents/skills/` y se exponen a Claude Code mediante enlaces simbólicos en `.claude/skills/`. Ambas carpetas deben versionarse en git (los enlaces simbólicos se conservan en Linux y macOS; en Windows requieren `core.symlinks=true`).
- Skills: `openspec-explore`, `openspec-propose`, `openspec-apply-change`, `openspec-update-change`, `openspec-sync-specs`, `openspec-archive-change`. Se invocan como `/openspec-propose`, `/openspec-apply-change`, etc.
- Las skills ejecutan la CLI `openspec`: `npm install -g @fission-ai/openspec@latest`.
- Se regeneran con `openspec update`.
- Orden de trabajo: H1 → archivar → H2 → archivar → H3.
