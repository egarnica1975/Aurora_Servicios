# Delta para Consulta a áreas

## ADDED Requirements

### Requirement: Consulta estructurada a ventas o logística
El sistema SHALL permitir que un agente cree desde una solicitud una consulta dirigida a ventas o a logística, con la pregunta, el destinatario y un plazo de respuesta `[por definir]`, asociada a la referencia.

_Trazabilidad: OP-07 · K09, K28 · E04, E06._

#### Scenario: Crear una consulta
- **WHEN** el agente crea una consulta a logística desde una solicitud
- **THEN** la consulta queda asociada a la referencia y la solicitud pasa a «Esperando consulta»

#### Scenario: Responder una consulta
- **WHEN** la persona de logística registra su respuesta
- **THEN** la respuesta queda en la consulta, el agente la ve y la solicitud vuelve a «En gestión»

### Requirement: Consultas pendientes visibles
El sistema SHALL mostrar las consultas sin respuesta en la vista de seguimiento, con quién debe responder y desde cuándo.

_Trazabilidad: OP-07, OP-08 · K10 · E06._

#### Scenario: Consulta sin respuesta
- **WHEN** una consulta supera su plazo sin respuesta
- **THEN** aparece señalada en la vista del coordinador

### Requirement: Las consultas no cambian el plazo ni la responsabilidad
El sistema SHALL mantener el vencimiento y el responsable de la solicitud mientras exista una consulta abierta.

_Trazabilidad: OP-07 · K06 · E03._

#### Scenario: Plazo durante una consulta
- **WHEN** una solicitud está «Esperando consulta»
- **THEN** su vencimiento de 48 horas sigue corriendo y su responsable no cambia
