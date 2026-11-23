# Delta para Indicadores

## ADDED Requirements

### Requirement: Definición formal y versionada de cada indicador
El sistema SHALL mantener para cada indicador su nombre, fórmula, unidad, fuente del dato y vigencia, y SHALL guardar una versión nueva, con fecha y persona, cada vez que cambie.

_Trazabilidad: OP-09 · K25 · E03, E08._

#### Scenario: Cambio de definición
- **WHEN** el coordinador modifica la fórmula de un indicador
- **THEN** el sistema crea una versión nueva con fecha y persona y conserva la anterior

#### Scenario: Medición con su definición
- **WHEN** se consulta una medición pasada
- **THEN** se ve el valor y la versión de la definición con la que se calculó

### Requirement: Indicadores de registro y asignación
El sistema SHALL calcular desde el registro, por periodo, la cobertura de registro (K01), las solicitudes con responsable identificable (K04), las reasignaciones con evidencia (K05), la completitud de campos (K33) y los registros con listas comunes (K34).

_Trazabilidad: OP-09 · K01, K04, K05, K33, K34 · E03._

#### Scenario: Solicitudes anuladas
- **WHEN** se calcula la cobertura del periodo
- **THEN** las solicitudes anuladas cuentan como registradas y no se excluyen del denominador

#### Scenario: Cambiar la fecha de recepción no mejora la medición en silencio
- **WHEN** se corrige la fecha de recepción de una solicitud
- **THEN** el cambio queda en el historial y el indicador se recalcula con la fecha corregida, a la vista de quien audite

### Requirement: Indicadores de resolución y seguimiento sin excluir vencidas
El sistema SHALL calcular desde el registro, por periodo, las solicitudes resueltas en 48 horas corridas (K06), la tasa de reapertura (K08), las abiertas vencidas (K10) y la antigüedad de pendientes (K11), y SHALL incluir siempre las abiertas vencidas en el denominador.

_Trazabilidad: OP-09 · K06, K08, K10, K11 · E03._

#### Scenario: Resueltas en 48 horas con vencidas incluidas
- **WHEN** en un periodo hay 600 solicitudes, 390 resueltas en 48 horas o menos y el resto tardías o abiertas
- **THEN** K06 es 65 % y las abiertas vencidas permanecen en el denominador

#### Scenario: Antigüedad de pendientes
- **WHEN** se calcula K11 con solicitudes abiertas de distinta edad
- **THEN** el sistema muestra la edad promedio y la máxima en horas corridas

### Requirement: Tablero con acceso a las solicitudes
El sistema SHALL mostrar cada indicador con su valor, su línea base, su meta cuando exista y el tamaño de la muestra, y SHALL permitir abrir las solicitudes que lo componen.

_Trazabilidad: OP-09 · K25, K26 · E03._

#### Scenario: Indicador sin meta
- **WHEN** un indicador no tiene meta definida
- **THEN** el tablero muestra su valor sin semáforo y lo indica

#### Scenario: Del indicador a las solicitudes
- **WHEN** el coordinador selecciona K10
- **THEN** ve la lista de solicitudes abiertas vencidas que lo componen

### Requirement: Exportación para el análisis financiero
El sistema SHALL permitir exportar a un archivo los datos y los valores de los indicadores de un periodo.

_Trazabilidad: OP-09 · K40 · E04, E10._

#### Scenario: Exportar un periodo
- **WHEN** finanzas exporta el periodo
- **THEN** obtiene un archivo con los indicadores, las definiciones vigentes y los datos de las solicitudes
