# Hoja de ruta base en tres horizontes (derivada, por confirmar con el paso 6)

**Estado:** supuesto de diseño. Agrupa las oportunidades por dependencia técnica y de proceso. No contiene fechas: el caso solo fija el piloto de 6 semanas y la evaluación a 90 días. Los criterios de salida usan las metas O01–O04 del caso y los escenarios de cada especificación.

| Horizonte | Propósito | Oportunidades | Cambio OpenSpec | Indicadores que mueve |
|---|---|---|---|---|
| **H1. Registro confiable** | Toda solicitud tiene referencia, campos completos, responsable y historia; acceso individual y respaldo desde el primer día | OP-01, OP-02, OP-03, OP-04, OP-05, OP-11, OP-12 | `h1-registro-confiable` | K01–K05, K31–K36, K41–K43 |
| **H2. Ciclo completo** | La solicitud se resuelve con respuesta comunicada, se vigila su vencimiento, se consulta a ventas y logística, se valida contra el ERP y la hoja se retira | OP-06, OP-07, OP-08, OP-10, OP-13 | `h2-ciclo-completo` | K06–K11, K32 |
| **H3. Medición y sostenibilidad** | Los indicadores se calculan desde el registro con definiciones estables, se verifican de forma independiente y se sigue el uso de las horas liberadas | OP-09 | `h3-medicion-sostenibilidad` | K25–K30 y los de H1 y H2 |

## Por qué este orden

- **OP-01 y OP-02** (referencia y registro) son la base de todo lo demás.
- **OP-05** (historia) va en H1 porque **OP-03** (reasignación con evidencia) la necesita.
- **OP-11 y OP-12** (acceso individual, respaldo) son requisitos del caso (E08) y no deben esperar a que haya datos que proteger.
- **OP-06 y OP-08** requieren solicitudes bien registradas y con responsable (H1).
- **OP-10** (validación contra el ERP) se pospone a H2 para no frenar la atención en el piloto; en H1 cliente y pedido se registran como datos de referencia.
- **OP-13** (retirar la hoja) solo es seguro cuando el registro cubre el ciclo completo (H2).
- **OP-09** (indicadores) necesita el ciclo completo para calcular K06, K08 y K10 sin excluir vencidas (E03).

## Salida de cada horizonte (sin cifras nuevas)

- **H1:** todos los escenarios de H1 pasan; hay una prueba de recuperación registrada; un agente aprende a registrar en una sesión corta; en el piloto se mide cobertura (K01) y responsable (K04) frente a las metas del caso.
- **H2:** todos los escenarios de H2 pasan; las solicitudes abiertas de la hoja están importadas y la hoja deja de ser sistema de registro; se mide K06 sin excluir pendientes vencidas.
- **H3:** todos los escenarios de H3 pasan; cada indicador del tablero tiene definición formal (K25) y una verificación independiente registrada (K26, K27).

## Riesgos de la agrupación

- Si el paso 6 prioriza otra cosa (por ejemplo, indicadores antes del ciclo completo), mover requisitos entre cambios; los requisitos no dependen unos de otros salvo los indicados en cada `design.md`.
- La realización de APP-05 (opción A, B o C) puede dejar algunos requisitos fuera de alcance de una opción. Eso es un resultado válido de la evaluación, no un defecto de la especificación.
