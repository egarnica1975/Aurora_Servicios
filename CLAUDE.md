# CLAUDE.md · Gestión de Solicitudes de Comercial Aurora

## Proyecto
Aplicación de registro y seguimiento de solicitudes para Comercial Aurora, que distribuye suministros de oficina a pequeñas empresas y colegios de una ciudad colombiana. Atiende 300 clientes activos y procesa cerca de 1.200 pedidos al mes. Compite por la confiabilidad de sus entregas y la cercanía de la atención. La recompra es relevante porque muchos clientes hacen pedidos periódicos.

Es un caso ficticio de un curso de arquitectura empresarial.

## Método
Spec Driven Development con OpenSpec. La especificación manda: todo cambio de comportamiento pasa primero por `openspec/changes/`.

- Cambio vigente: `h1-registro-confiable` (Horizonte 1). H2 y H3 no se tocan hasta archivar el anterior.
- Orden: H1 → archivar → H2 → archivar → H3.
- Skills (en `.claude/skills/`): `/openspec-explore`, `/openspec-propose`, `/openspec-apply-change`, `/openspec-update-change`, `/openspec-sync-specs`, `/openspec-archive-change`.
- Si la CLI no está instalada: `npm install -g @fission-ai/openspec@latest`.
- Antes de cada commit: `openspec validate --all --strict`.

## Versión 1 (alcance actual)
Un único archivo HTML (`app/index.html`) con HTML5, CSS3 y JavaScript. Datos en objetos y arreglos; guardado y recuperación en JSON; importación de clientes en JSON y CSV; se abre con doble clic en el navegador.

Fuera de alcance de la V1: servidor, base de datos, autenticación real, respaldo programado y despliegue en la nube (es la V2).

Los límites de la V1 frente a H1 están en la tabla de cobertura de `openspec/changes/h1-registro-confiable/design.md` y en `docs/guia-v1-aurora.md`. No presentes como cumplido lo que la V1 solo simula.

## Reglas
1. No inventes datos ni cifras. Lo que el caso no documenta se marca `[por definir]` y se lista como pregunta abierta.
2. Separa lo documentado de lo supuesto; cada requisito conserva su línea de trazabilidad.
3. Usa solo datos ficticios en pruebas y en el repositorio.
4. La especificación se escribe en español. Las palabras clave de OpenSpec (`ADDED`, `MODIFIED`, `Requirement`, `Scenario`, `SHALL`, `WHEN`, `THEN`) se mantienen en inglés.
5. Las reglas de negocio (referencia única, historia, reasignación) van en funciones separadas de la pantalla. La historia se genera en la misma operación que cambia el dato y la aplicación no permite editarla ni borrarla.
6. Si algo de la especificación es ambiguo, detente y pregunta; no supongas.
7. No cambies requisitos de comportamiento sin confirmación; si hace falta, usa `/openspec-update-change`.
8. No archives un cambio si algún escenario marcado como cubierto falla.
9. Commits pequeños, con mensaje descriptivo, en la rama `main` de `egarnica1975/Aurora_Servicios`.

## Estructura
- `openspec/config.yaml`: contexto del proyecto.
- `openspec/specs/`: especificaciones vigentes (se llena al archivar).
- `openspec/changes/`: cambios en curso; `archive/` los cerrados.
- `docs/hoja-de-ruta-base.md`: agrupación derivada de los tres horizontes (supuesto de diseño).
- `docs/guia-v1-aurora.md`: guía paso a paso de la V1.
- `app/index.html`: la aplicación (se crea en la implementación).
