# Plan de decisiones y ejecución · Versión 2 (Aurora)

Fecha: 25-nov-2026. Stack fijado por el usuario: **Supabase (PostgreSQL), Python y FastAPI**.
La V2 cierra los límites de la V1 declarados en `openspec/changes/h1-registro-confiable/design.md` (D6) y en `docs/verificacion-h1.md`.

Leyenda: **Decidido** (lo fijó el usuario) · **Supuesto** (propuesta de diseño por confirmar) · **Abierto** (`[por definir]`).

## 1. Límites de la V1 que la V2 cierra

| ID | Límite de la V1 | Cambio que lo cierra |
|---|---|---|
| L01 | Persistencia manual en JSON | v2-modelo-de-datos, v2-front-conectado, v2-migracion-v1 |
| L02 | Historia inmutable solo en la aplicación | v2-integridad-historial, v2-migracion-v1 |
| L03 | Referencia única solo dentro del archivo | v2-integridad-historial, v2-migracion-v1 |
| L04 | Integridad aplicada en el navegador | v2-modelo-de-datos, v2-api-backend, v2-front-conectado, v2-despliegue |
| L05 | Cuentas simuladas (selector sin contraseña) | v2-api-backend, v2-migracion-v1, v2-front-conectado |
| L06 | Roles aplicados en pantalla | v2-api-backend, v2-front-conectado, v2-despliegue |
| L07 | Ingreso fallido sin registro | v2-api-backend, v2-front-conectado |
| L08 | Sin respaldo programado ni aviso | v2-respaldo-recuperacion, v2-despliegue (costo) |
| L09 | Recuperación no comprobada | v2-respaldo-recuperacion, v2-migracion-v1 |
| L10 | Sin uso simultáneo | v2-api-backend, v2-despliegue |
| L11 | Ambientes separados solo en memoria | v2-modelo-de-datos, v2-front-conectado, v2-despliegue |

## 2. Registro de decisiones

| ID | Decisión | Estado | Alternativa / nota | Dónde se resuelve |
|---|---|---|---|---|
| D-01 | PostgreSQL gestionado por Supabase | Decidido | — | v2-modelo-de-datos |
| D-02 | Python + FastAPI para el servidor | Decidido | — | v2-api-backend |
| D-03 | Acceso a datos directo con psycopg (consultas parametrizadas) | Supuesto | SQLAlchemy | v2-api-backend D2 |
| D-04 | Migraciones SQL versionadas en `supabase/migrations/` con Supabase CLI | Supuesto | Alembic | v2-modelo-de-datos |
| D-05 | Supabase Auth con JWT validado por FastAPI; el ingreso pasa por la API para registrar fallos | Supuesto | Que Supabase exponga los fallos (no confirmado) | v2-api-backend D3 y prueba de concepto 1.2 |
| D-06 | Un solo proyecto de Supabase (trabajo); sin ambiente de capacitación en la V2 (se cubre en la V3) | Decidido (25-nov) | Requiere ajustar las especificaciones que hoy exigen capacitación; ver pendiente | v2-modelo-de-datos, v2-despliegue |
| D-07 | Respaldo de muy bajo costo: nativo de Supabase Pro (7 días) y, opcionalmente, manual y copia lógica programada; alternativas en `docs/costos-v2.md` | Abierto (a elegir A, B o C) | PITR si el caso exige menos de 24 h de pérdida | v2-respaldo-recuperacion |
| D-08 | API en Vercel; Supabase no aloja Python (sus Edge Functions son TypeScript sobre Deno) | Decidido (25-nov); se valida con la prueba de concepto | Consolidar en Supabase obligaría a reescribir la API en TypeScript y contradice D-02 | v2-despliegue 1.2 |
| D-09 | Front en HTML, CSS y JavaScript sin compilación, separado en archivos | Supuesto | Herramienta de construcción solo si se justifica | v2-front-conectado D1 |
| D-10 | Pruebas con pytest sobre PostgreSQL local; 48 escenarios de H1 como pruebas de contrato; CI con GitHub Actions | Supuesto | — | v2-api-backend 4, v2-despliegue 3 |
| D-11 | El piloto se hace solo en la V2; la migración desde la V1 pierde su razón principal | Decidido (25-nov) | `v2-migracion-v1` queda por reducir o aplazar; pendiente de confirmar | v2-migracion-v1 |
| D-12 | Costo total dentro de COP 300.000 al mes de operación y COP 12.000.000 de inversión | En seguimiento | TCO de referencia en `docs/costos-v2.md` (consulta 25-nov-2026) | v2-despliegue 4.1 |
| D-13 | Node.js sin rol en la V2 | Decidido (25-nov) | — | v2-front-conectado D1 |
| D-14 | Autorización en dos capas (API y base de datos) para que el administrador técnico no lea el contenido | Supuesto | Solo en la API (más riesgo) | v2-api-backend D4 |

## 3. Plan de ejecución

| Fase | Cambios | Resultado | Criterio de salida |
|---|---|---|---|
| F0 Preparación | — | Decisiones D-06, D-08, D-12 y D-13 confirmadas; repositorio con `supabase/`, `api/`, `web/` | Decisiones registradas en este plan |
| F1 Base de datos | v2-modelo-de-datos → v2-integridad-historial → (v2-respaldo-recuperacion ∥ v2-migracion-v1) | Esquema, triggers, respaldo y migración probados en local y en Supabase | Escenarios de las cuatro especificaciones pasan |
| F2 API | v2-api-backend | API con reglas, roles y auditoría | Una prueba de contrato por escenario de H1; todas pasan |
| F3 Front | v2-front-conectado | Interfaz sobre la API | Escenarios de interfaz verificados con datos ficticios |
| F4 Despliegue | v2-despliegue (la prueba de concepto de alojamiento se adelanta a F0/F1) | Ambientes publicados, CI y reversión | Prueba de restauración registrada; costo documentado |
| F5 H2 y H3 | h2-ciclo-completo, h3-medicion-sostenibilidad | Extensión sobre la V2 | Tras archivar H1 y los cambios V2 |

Reglas de avance: no se archiva un cambio con escenarios fallidos (regla 8 del proyecto); H2 y H3 no se tocan hasta archivar los cambios anteriores.

## 4. Riesgos principales

- **Plan sin respaldos:** según la documentación de Supabase, los respaldos diarios existen solo en planes de pago; puede chocar con el límite de costo (D-12).
- **Alojamiento sin estado:** arranque en frío y agotamiento de conexiones; mitigar con el pooler y la prueba de concepto (D-08).
- **Fallo de ingreso no capturable en Supabase Auth:** mitigado por el ingreso mediado (D-05).
- **Inmutabilidad:** vale frente a los roles de la aplicación, no frente a un superusuario del proveedor; una cadena de hashes es opcional y está abierta.
- **Datos migrados editados a mano:** se marcan con origen `v1`; la migración no certifica su integridad.

## 5. Preguntas abiertas para el usuario

1. Respaldo: elegir entre las opciones A, B y C de `docs/costos-v2.md` (D-07) y fijar la pérdida máxima aceptable.
2. Confirmar los cambios a las especificaciones por no tener capacitación ni migración: quitar el ambiente de capacitación de `v2-modelo-de-datos`, `v2-front-conectado` y `v2-despliegue`; reducir o aplazar `v2-migracion-v1`. Esto deja sin cubrir el escenario de H1 de ambiente de capacitación hasta la V3 y debe declararse en la tabla de cobertura.
3. ¿Vercel Pro o Hobby? Hobby es para uso no comercial según Vercel; el costo de Pro está en el escenario E1.
4. Costos aún sin cifra: dominio, correo de avisos y horas del proveedor.

## 6. Fuentes consultadas (25-nov-2026)

- Supabase, documentación de respaldos de bases de datos (planes, retención, PITR).
- Vercel, documentación de FastAPI sobre el runtime de Python.
- Precios vigentes de Supabase y Vercel (páginas de precios oficiales) y TRM de Portafolio del 18-nov-2026; ver `docs/costos-v2.md`.
- Supabase, documentación de Edge Functions (TypeScript sobre Deno).
- Supabase, documentación de registros de auditoría de Auth.

Los precios cambian: consultar vigentes al decidir.
