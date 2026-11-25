# Plan de decisiones y ejecución · Versión 2 (Aurora)

Fecha: 25-nov-2026. Stack fijado por el usuario: **Supabase (PostgreSQL), Python y FastAPI**.
La V2 cierra los límites de la V1 declarados en `openspec/changes/h1-registro-confiable/design.md` (D6) y en `docs/verificacion-h1.md`.

Alcance (25-nov-2026): **proyecto académico no comercial**. Se usa la solución más económica y se sacrifica lo no crítico: sin respaldo programado (solo volcado manual de la base), un solo ambiente y sin capacitación en la V2 (la capacitación queda en la V1). `v2-migracion-v1` se aplazó a `docs/aplazado/` porque el piloto es solo en la V2.

Leyenda: **Decidido** (lo fijó el usuario) · **Supuesto** (propuesta de diseño por confirmar) · **Abierto** (`[por definir]`).

## 1. Límites de la V1 que la V2 cierra

| ID | Límite de la V1 | Cambio que lo cierra |
|---|---|---|
| L01 | Persistencia manual en JSON | v2-modelo-de-datos, v2-front-conectado |
| L02 | Historia inmutable solo en la aplicación | v2-integridad-historial |
| L03 | Referencia única solo dentro del archivo | v2-integridad-historial |
| L04 | Integridad aplicada en el navegador | v2-modelo-de-datos, v2-api-backend, v2-front-conectado, v2-despliegue |
| L05 | Cuentas simuladas (selector sin contraseña) | v2-api-backend, v2-front-conectado |
| L06 | Roles aplicados en pantalla | v2-api-backend, v2-front-conectado, v2-despliegue |
| L07 | Ingreso fallido sin registro | v2-api-backend, v2-front-conectado |
| L08 | Sin respaldo programado ni aviso | **No se cierra en la V2** (solo volcado manual con registro: v2-respaldo-recuperacion) |
| L09 | Recuperación no comprobada | v2-respaldo-recuperacion |
| L10 | Sin uso simultáneo | v2-api-backend, v2-despliegue |
| L11 | Ambiente de capacitación separado | **No se cierra en la V2**: la capacitación sigue en la V1 |

## 2. Registro de decisiones

| ID | Decisión | Estado | Alternativa / nota | Dónde se resuelve |
|---|---|---|---|---|
| D-01 | PostgreSQL gestionado por Supabase | Decidido | — | v2-modelo-de-datos |
| D-02 | Python + FastAPI para el servidor | Decidido | — | v2-api-backend |
| D-03 | Acceso a datos directo con psycopg (consultas parametrizadas) | Supuesto | SQLAlchemy | v2-api-backend D2 |
| D-04 | Migraciones SQL versionadas en `supabase/migrations/` con Supabase CLI | Supuesto | Alembic | v2-modelo-de-datos |
| D-05 | Supabase Auth con JWT validado por FastAPI; el ingreso pasa por la API para registrar fallos | Supuesto | Que Supabase exponga los fallos (no confirmado) | v2-api-backend D3 y prueba de concepto 1.2 |
| D-06 | Un solo proyecto de Supabase (trabajo); sin capacitación en la V2, que sigue en la V1 | Decidido (25-nov) | Plan gratuito: se pausa tras una semana sin actividad | v2-modelo-de-datos |
| D-07 | Respaldo solo por volcado manual de la base (`pg_dump` o `supabase db dump`); sin respaldo programado ni aviso | Decidido (25-nov) | Periodicidad, responsable y lugar de guardado `[por definir]` | v2-respaldo-recuperacion |
| D-08 | API y front en Vercel (plan Hobby); Supabase no aloja Python (Edge Functions son TypeScript sobre Deno) | Decidido (25-nov); se valida con la prueba de concepto | Si Vercel no cumple, se reabre | v2-despliegue 1.2 |
| D-09 | Front en HTML, CSS y JavaScript sin compilación, separado en archivos | Supuesto | Herramienta de construcción solo si se justifica | v2-front-conectado D1 |
| D-10 | Pruebas con pytest sobre PostgreSQL local; 48 escenarios de H1 como pruebas de contrato; CI con GitHub Actions | Supuesto | — | v2-api-backend 4, v2-despliegue 3 |
| D-11 | Piloto solo en la V2; `v2-migracion-v1` aplazado (`docs/aplazado/v2-migracion-v1/`) | Decidido (25-nov) | Recuperable si el piloto de la V1 debe pasarse a la V2 | — |
| D-12 | Costo: planes gratuitos de Supabase y Vercel Hobby, previsto USD 0/mes por ser proyecto académico no comercial | Decidido (25-nov) | Referencia de planes de pago en `docs/costos-v2.md` | v2-despliegue 4.1 |
| D-13 | Node.js sin rol en la V2 | Decidido (25-nov) | — | v2-front-conectado D1 |
| D-14 | Autorización en dos capas (API y base de datos) para que el administrador técnico no lea el contenido | Supuesto | Solo en la API (más riesgo) | v2-api-backend D4 |

## 3. Plan de ejecución

| Fase | Cambios | Resultado | Criterio de salida |
|---|---|---|---|
| F0 Preparación | — | Decisiones de este plan registradas; repositorio con `supabase/`, `api/`, `web/` | Decisiones registradas en este plan |
| F1 Base de datos | v2-modelo-de-datos → v2-integridad-historial → v2-respaldo-recuperacion | Esquema, triggers y respaldo manual probados en local y en Supabase | Escenarios de las tres especificaciones pasan |
| F2 API | v2-api-backend | API con reglas, roles y auditoría | Una prueba de contrato por escenario de H1; todas pasan |
| F3 Front | v2-front-conectado | Interfaz sobre la API | Escenarios de interfaz verificados con datos ficticios |
| F4 Despliegue | v2-despliegue (la prueba de concepto de alojamiento se adelanta a F0/F1) | Despliegue en Vercel y Supabase, CI y reversión | Prueba de restauración registrada; secretos fuera del repositorio |
| F5 H2 y H3 | h2-ciclo-completo, h3-medicion-sostenibilidad | Extensión sobre la V2 | Tras archivar H1 y los cambios V2 |

Reglas de avance: no se archiva un cambio con escenarios fallidos (regla 8 del proyecto); H2 y H3 no se tocan hasta archivar los cambios anteriores.

## 4. Riesgos principales

- **Sin respaldo programado:** lo registrado después del último volcado manual puede perderse; se acepta por ser proyecto académico (L08 abierto).
- **Pausa del plan gratuito:** Supabase pausa el proyecto tras una semana sin actividad.
- **Alojamiento sin estado:** arranque en frío y agotamiento de conexiones; mitigar con el pooler y la prueba de concepto (D-08).
- **Fallo de ingreso no capturable en Supabase Auth:** mitigado por el ingreso mediado (D-05).
- **Inmutabilidad:** vale frente a los roles de la aplicación, no frente a un superusuario del proveedor; una cadena de hashes es opcional y está abierta.
- **Un solo ambiente:** una prueba hecha por error afecta datos de trabajo; los datos ficticios no se cargan allí.

## 5. Preguntas abiertas para el usuario

1. Periodicidad, responsable y lugar de guardado del volcado manual (D-07).
2. ¿Se acepta que el proyecto gratuito de Supabase se pause por inactividad durante la demostración, o se reactiva antes de cada uso?
3. Si la V2 llegara a usarse de forma comercial: cambiar a Vercel Pro y Supabase Pro (ver `docs/costos-v2.md`).

## 6. Fuentes consultadas (25-nov-2026)

- Supabase, documentación de respaldos de bases de datos (planes, retención, PITR).
- Vercel, documentación de FastAPI sobre el runtime de Python.
- Precios vigentes de Supabase y Vercel (páginas de precios oficiales) y TRM de Portafolio del 18-nov-2026; ver `docs/costos-v2.md`.
- Supabase, documentación de Edge Functions (TypeScript sobre Deno).
- Supabase, documentación de registros de auditoría de Auth.

Los precios cambian: consultar vigentes al decidir.
