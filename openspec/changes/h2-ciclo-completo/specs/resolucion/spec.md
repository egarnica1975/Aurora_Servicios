# Delta para Resolución

## ADDED Requirements

### Requirement: Resuelta solo con respuesta final comunicada
El sistema SHALL permitir pasar una solicitud a «Resuelta» únicamente cuando exista una respuesta final con texto, fecha de comunicación al cliente y canal usado.

_Trazabilidad: OP-06 · K06, K08 · E03, E09._

#### Scenario: Resolver sin respuesta
- **WHEN** un agente intenta marcar «Resuelta» sin respuesta final
- **THEN** el sistema lo impide e indica que falta la respuesta comunicada

#### Scenario: Resolver con respuesta
- **WHEN** el agente registra la respuesta final con fecha y canal y marca «Resuelta»
- **THEN** la solicitud queda «Resuelta» y la respuesta queda asociada a ella

### Requirement: Vencimiento de 48 horas corridas
El sistema SHALL calcular para cada solicitud un vencimiento igual a la fecha y hora de recepción más 48 horas corridas, y SHALL considerar cumplida una solicitud cuya respuesta final se comunicó en o antes de ese vencimiento.

_Trazabilidad: OP-06, OP-08 · K06, K10 · E03._

#### Scenario: Respuesta dentro del plazo
- **WHEN** una solicitud recibida el lunes a las 10:00 recibe su respuesta final el miércoles a las 09:00
- **THEN** el sistema la considera cumplida

#### Scenario: Respuesta fuera del plazo
- **WHEN** esa misma solicitud recibe su respuesta final el miércoles a las 10:01
- **THEN** el sistema la considera incumplida

#### Scenario: Pendiente vencida
- **WHEN** pasan 48 horas corridas desde la recepción y la solicitud sigue abierta
- **THEN** el sistema la marca como vencida y sigue contándola como pendiente

### Requirement: Reapertura con motivo
El sistema SHALL permitir reabrir una solicitud «Resuelta» con un motivo obligatorio, conservando su referencia e historia.

_Trazabilidad: OP-06 · K08 · E03._

#### Scenario: Cliente vuelve a plantear el asunto
- **WHEN** el agente reabre una solicitud resuelta e indica el motivo
- **THEN** pasa a «Reabierta», conserva su referencia y el historial muestra la reapertura

#### Scenario: Reapertura sin motivo
- **WHEN** se intenta reabrir sin motivo
- **THEN** el sistema lo rechaza
