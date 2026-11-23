# Guía V1 · Aplicación de Gestión de Solicitudes de Comercial Aurora

Versión 1.0 · Entorno: Claude Code + GitHub (`egarnica1975/Aurora_Servicios`, rama `main`)
Deriva de la Guía maestra SDD con OpenSpec, con los datos de Aurora ya incorporados y sin lo que no se necesita para la V1.

**Resultado esperado:** una aplicación web de un solo archivo HTML (HTML5 + CSS3 + JavaScript), que se abre con doble clic, y que implementa el cambio `h1-registro-confiable` ya especificado en OpenSpec.

---

## 1. Qué se construye y con qué

**Caso.** Comercial Aurora distribuye suministros de oficina a pequeñas empresas y colegios de una ciudad colombiana. Atiende 300 clientes activos y procesa cerca de 1.200 pedidos al mes (unas 600 solicitudes al mes). Compite por la confiabilidad de sus entregas y la cercanía de la atención. La recompra es relevante porque muchos clientes hacen pedidos periódicos.

**Especificación.** Cambio `h1-registro-confiable` (Horizonte 1, "Registro confiable"): cinco capacidades (`solicitudes`, `asignacion`, `historial`, `acceso-datos`, `respaldo`), 20 requisitos y 32 tareas. H2 y H3 permanecen en el repositorio sin tocarse.

**Stack de la V1**

| Componente | Tecnología | Función |
|---|---|---|
| Interfaz | HTML5 | Formularios, bandeja e historial |
| Diseño visual | CSS3 | Presentación adaptable a distintos tamaños de pantalla |
| Lógica de negocio | JavaScript | Registro, asignación, estados y cálculo de plazos |
| Datos durante el uso | Objetos y arreglos de JavaScript | Gestionar clientes, usuarios y solicitudes |
| Guardado y recuperación | Archivos JSON | Exportar los datos y cargarlos al volver a abrir la aplicación |
| Importación de clientes | JSON y CSV | Cargar el directorio de pruebas |
| Ejecución | Navegador instalado | Abrir un archivo HTML con doble clic |
| Distribución | Un archivo HTML con CSS y JavaScript | Entregar la aplicación lista para usar |

---

## 2. Límites de la V1 frente a H1 (leer antes de empezar)

H1 se escribió sin atarse a una tecnología. Algunos de sus requisitos no se pueden cumplir de verdad con un archivo HTML sin servidor. En vez de ocultarlo, la V1 los cubre de forma **simulada o parcial** y lo declara; la V2 (Python, base de datos y nube) los cierra.

| Capacidad de H1 | Qué cubre la V1 | Qué queda limitado (se cierra en V2) |
|---|---|---|
| `solicitudes` | Completa: registro en una acción, referencia única, campos obligatorios, listas de canal y estado, pedido opcional, búsqueda | Sin límite conocido para el volumen del caso; la unicidad de la referencia solo se garantiza dentro de un mismo archivo de datos |
| `asignacion` | Completa: responsable único, reasignación con evidencia, ausencia de un agente | Sin límite conocido |
| `historial` | Historia automática generada en la misma operación que el cambio; la aplicación no ofrece editar ni borrar | El archivo JSON exportado se puede editar fuera de la aplicación, así que la inmutabilidad es de la aplicación, no del dato |
| `acceso-datos` | Selección de usuario y roles en pantalla, datos de contacto mínimos, registro de auditoría dentro de la aplicación, datos ficticios de capacitación | **No hay cuentas individuales reales ni contraseñas**: cualquiera con el archivo puede elegir cualquier usuario. Queda como simulación para demostrar flujos |
| `respaldo` | Exportar e importar JSON a mano, y probar la recuperación cargando un respaldo | **No hay respaldo programado** ni responsable externo; el respaldo es una acción manual |

Consecuencia: la V1 sirve para **validar el flujo y el alcance con el equipo de Aurora y usar datos ficticios**. No debe usarse con datos reales de clientes.

---

## 3. Fases

Cada fase tiene su prompt y una verificación. No pases a la siguiente sin cumplirla.

### Fase 1 · Preparar el repositorio

1. Abre `egarnica1975/Aurora_Servicios` en Claude Code (rama `main`).
2. Sube al repositorio el contenido de la carpeta `aurora/` del archivo `Aurora_Especificacion_OpenSpec.zip` (incluye `openspec/`, `.agents/skills/`, `.claude/skills/`, `docs/` y `README.md`) y el `CLAUDE.md` que acompaña esta guía.

**Verificación:** Claude Code lista `openspec/changes/h1-registro-confiable`, `.claude/skills/` y `CLAUDE.md`.

### Fase 2 · Configurar y comprobar OpenSpec

```text
Configura este proyecto para desarrollar software con Spec Driven Development
utilizando OpenSpec y Claude Code, sincronizado con GitHub.

1. Verifica Node.js y npm.
2. Instala la versión estable más reciente de @fission-ai/openspec.
3. Comprueba que OpenSpec esté inicializado en la raíz para Claude Code; si falta,
   ejecuta openspec init --tools claude --scope project. No sobrescribas
   openspec/config.yaml ni los cambios existentes.
4. Verifica que las skills estén en .agents/skills/ y .claude/skills/.
5. Ejecuta openspec validate --all --strict y openspec list.

Informa las versiones, los comandos disponibles y la estructura del proyecto.
```

**Verificación:** `openspec validate --all --strict` pasa (H2 muestra un aviso informativo esperado) y `openspec list` muestra los tres cambios.

### Fase 3 · Contexto de la V1 en `config.yaml`

```text
Actualiza openspec/config.yaml, sin borrar lo existente, para añadir esta decisión:
la versión 1 de la aplicación de registro y seguimiento de solicitudes de Comercial Aurora
se construye como un único archivo HTML (HTML5, CSS3 y JavaScript, datos en memoria,
guardado y recuperación en JSON, importación de clientes en JSON y CSV), que se abre
con doble clic en el navegador. Solo se usan datos ficticios. Lo que el caso no documenta
se marca como [por definir]. La versión 2 (Python, base de datos y nube) queda fuera de
este alcance.
```

**Verificación:** `git diff` solo muestra `openspec/config.yaml`.

### Fase 4 · Adaptar H1 a la V1 (con preguntas, una por una)

```text
Vamos a implementar el cambio h1-registro-confiable como un único archivo HTML con CSS y
JavaScript, con el stack de la sección 1 de docs/guia-v1-aurora.md. La aplicación se debe
poder visualizar y probar desde mi navegador.

Lee proposal.md, design.md, tasks.md y las cinco especificaciones del cambio. Antes de
modificar nada:
1) Resume qué requisitos y escenarios se pueden cumplir completos, cuáles solo de forma
   simulada y cuáles no se pueden cumplir con este stack (guíate por la sección 2 de la guía).
2) Hazme preguntas, una por una, solo sobre lo que haga falta decidir para construir:
   formato de la referencia, pantallas mínimas, datos de prueba y roles.
```

Luego, con las decisiones tomadas:

```text
Usa la skill openspec-update-change para actualizar h1-registro-confiable: en design.md
fija la decisión de realización (opción C con este stack), añade la tabla de cobertura
completa / simulada / no cubierta con su justificación, y refleja en proposal.md las
preguntas ya resueltas. No cambies los requisitos de comportamiento salvo que yo lo
confirme. Valida con openspec validate h1-registro-confiable --strict.
```

**Verificación:** el cambio valida sin errores; `design.md` contiene la tabla de cobertura; las preguntas abiertas que siguen sin respuesta quedan como `[por definir]`.

### Fase 5 · Tareas de arranque

```text
Actualiza tasks.md de h1-registro-confiable para incluir: (1) .gitignore, (2) README.md
con instrucciones de configuración e inicio (abrir el HTML, cargar datos de prueba,
exportar e importar JSON, límites de la V1), y (3) un archivo de datos de prueba ficticios
en JSON y CSV. Mantén el orden lógico y no elimines tareas existentes.
```

**Verificación:** `tasks.md` incluye las tres tareas.

### Fase 6 · Commit y envío a GitHub

```text
Valida con openspec validate --all --strict, haz commit con el mensaje
"Configura OpenSpec y adapta H1 para la V1 de Aurora" y sube los cambios a la rama main
de egarnica1975/Aurora_Servicios.
```

**Verificación:** el commit aparece en GitHub e incluye `.agents/`, `.claude/`, `openspec/` y `CLAUDE.md`.

### Fase 7 · Implementación

```text
Implementa el cambio h1-registro-confiable (skill openspec-apply-change) en un único
archivo app/index.html, siguiendo tasks.md en orden y marcando cada tarea al completarla.
Si algo es ambiguo, detente y pregúntame en vez de suponer. Haz commit al terminar
cada grupo de tareas.
```

Reglas durante la implementación:
- Las reglas de negocio (referencia, historial, reasignación) van en funciones de JavaScript separadas de la pantalla.
- La historia se genera en la misma función que cambia el dato.
- Todos los datos de prueba son ficticios.

**Verificación:** `app/index.html` abre con doble clic; se puede registrar, asignar, reasignar, ver la línea de tiempo, exportar e importar JSON.

### Fase 8 · Verificación y archivo

```text
Verifica la implementación contra los escenarios de las cinco especificaciones de H1:
ejecuta o describe una prueba por escenario y dame una tabla con escenario, resultado
(pasa / pasa simulado / no cubierto) y evidencia. No archives si algún escenario que la
tabla de cobertura marca como completo falla.
```

Después, si todo pasa:

```text
Archiva h1-registro-confiable (skill openspec-archive-change), confirma que las
especificaciones vigentes quedaron en openspec/specs/, haz commit y sube a main.
```

**Verificación:** el cambio está en `openspec/changes/archive/`, `openspec/specs/` contiene las cinco capacidades y H2 sigue validando (ya no muestra el aviso, porque `solicitudes` existe).

---

## 4. Después de la V1

- La V2 (Python, base de datos y nube) cierra los límites de la sección 2 y se hace con cambios nuevos de OpenSpec, no editando H1. Ver la guía maestra, sección 9.3.
- H2 y H3 se implementan después, en ese orden, con su propio ciclo de las fases 4 a 8.

## 5. Preguntas abiertas heredadas de H1

Siguen como `[por definir]` y se resuelven en la fase 4 o con Aurora: formato de la referencia, frecuencia de respaldo y tiempo de recuperación (en V1 el respaldo es manual), registro de la fecha real de recepción cuando se registra después del contacto, y plazo de retención.
