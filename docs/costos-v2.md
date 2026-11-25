# Costos de la V2 (TCO de referencia)

Consulta: 25-nov-2026. Precios en USD de las páginas oficiales; conversión con la TRM de 3.309,55 COP/USD (18-nov-2026, Portafolio), que cambia a diario. Límite del caso (E10): operación hasta COP 300.000 al mes ≈ USD 90,6 a esa TRM; inversión hasta COP 12.000.000.

Estado: **referencia, no presupuesto.** Faltan: dominio, correo de avisos, horas del proveedor (no hay datos en el caso) y uso real.

**Decisión del 25-nov-2026:** proyecto académico no comercial; se usan Supabase Free y Vercel Hobby (USD 0/mes). Lo que sigue es la referencia si el proyecto pasara a ser comercial.

## Supuestos de esta tabla
- Un solo proyecto de Supabase (ambiente de trabajo); la capacitación sigue en la V1.
- API en Python/FastAPI y front estático en Vercel.
- Consumo dentro de lo incluido; no se estimó uso real.

## Componentes

| Componente | Plan | USD/mes | COP/mes aprox. | Fuente y notas |
|---|---|---|---|---|
| Supabase | Pro (por organización) | 25 | 82.700 | supabase.com/pricing. Incluye $10 de crédito de cómputo (una instancia Micro), 8 GB de disco, respaldos diarios con 7 días de retención. |
| Supabase | Free | 0 | 0 | 500 MB; los proyectos se pausan tras una semana sin actividad; sin respaldos automáticos según la documentación de respaldos. No apto para producción. |
| Vercel | Pro (1 usuario) | 20 | 66.200 | vercel.com/pricing. Incluye $20 de crédito de uso; cobra uso adicional (CPU activa, invocaciones). |
| Vercel | Hobby | 0 | 0 | Para uso personal no comercial según Vercel; no recomendado para la operación de Aurora. |
| GitHub Actions | repositorio ya existente | 0 | 0 | Para pruebas y respaldo lógico; revisar minutos incluidos. |

## Escenarios

| Escenario | USD/mes | COP/mes aprox. | Frente a COP 300.000 |
|---|---|---|---|
| E1. Supabase Pro + Vercel Pro | 45 | 148.900 | Dentro (≈50 %) |
| E2. Supabase Pro + Vercel Hobby | 25 | 82.700 | Dentro, pero Hobby no es comercial |
| E3. E1 + PITR de 7 días (USD 100/mes por proyecto) | 145 | 479.900 | **Excede** |

## Respaldo (decisión: solo volcado manual)

| Opción | Costo adicional | Pérdida máxima de datos | Estado |
|---|---|---|---|
| Volcado manual de la base (`pg_dump` o `supabase db dump`) | USD 0 | Todo lo posterior al último volcado | **Elegida** |
| Respaldo diario nativo (Supabase Pro, 7 días) | Incluido en USD 25 | Hasta 24 h | Descartada: no comercial |
| Copia lógica programada con GitHub Actions | USD 0 a muy bajo | Hasta 24 h | Descartada por decisión del usuario (sin respaldo programado) |
| PITR 7 días | USD 100 | Minutos | Descartada |

## Pendiente
Si el proyecto se hiciera comercial, completar dominio, correo y horas del proveedor, y recalcular con la TRM del día.
