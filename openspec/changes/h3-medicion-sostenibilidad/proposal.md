## Why

La gerencia pide demostrar la mejora a 90 días sin mejora aparente: no vale registrar menos, mover la recepción ni excluir casos vencidos (E03). Las líneas base se obtuvieron con una verificación puntual contra los canales y una muestra de 60 (E03), y la definición de los indicadores está pendiente de formalizar (E08). Este cambio corresponde al **Horizonte 3** y a la oportunidad OP-09: calcular los indicadores desde el registro, con definiciones estables y verificación independiente.

## What Changes

- Cálculo automático de los indicadores del servicio desde el registro, sin excluir vencidas.
- Definiciones formales y versionadas de cada indicador.
- Tablero de indicadores con acceso a las solicitudes que los componen.
- Verificación independiente de la cobertura contra los canales, por una persona distinta de quien registra.
- Seguimiento de las horas liberadas y de su destino en actividades de servicio.
- Datos exportables para el análisis financiero.

## Capabilities

### New Capabilities
- `indicadores`: cálculo, definiciones versionadas, tablero y exportación.
- `verificacion`: contraste independiente de la cobertura.
- `uso-capacidad`: tiempo administrativo, horas liberadas y su destino.

### Modified Capabilities
Ninguna.

## Impact

- Depende de H1 y H2 archivados.
- Rol nuevo: **verificador**, distinto del agente que registra. Amplía los roles de `acceso-datos` (supuesto de diseño).
- Usuarios: coordinador, gerencia y finanzas.
- No calcula retorno de inversión ni ahorro monetario; el ahorro de retrabajos (K40) requiere evidencia externa (E10).

## Preguntas abiertas

1. Periodicidad de los indicadores (¿mensual, semanal?) y del contraste con canales: `[por definir]`.
2. Tamaño y método de la muestra de tiempo administrativo: el caso usó 60 solicitudes con varios agentes y los tres canales (E03); `[por definir]` para repetirla.
3. Quién actúa como verificador y qué se cuenta en cada canal: `[por definir]` con la gerencia.
4. Metas para los indicadores sin meta en el caso (K02, K03, K05, K07, K08, K09, K11, K30): `[por definir]`.
5. Actividades de servicio que aprovecharán las horas liberadas: el caso exige identificarlas (E10) y no las lista.
