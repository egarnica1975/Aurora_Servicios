# Delta para Asignación

## ADDED Requirements

### Requirement: Responsable único y vigente
El sistema SHALL mantener exactamente un responsable por solicitud en todo momento.

_Trazabilidad: OP-03 · K04 · E03, E06._

#### Scenario: Solicitud sin responsable
- **WHEN** se intenta guardar una solicitud sin responsable
- **THEN** el sistema la rechaza

#### Scenario: Un solo responsable
- **WHEN** se asigna una solicitud a otra persona
- **THEN** la persona anterior deja de figurar como responsable

### Requirement: Reasignación con evidencia
El sistema SHALL registrar en cada reasignación quién la hizo, cuándo, de quién a quién y el motivo, y SHALL exigir el motivo.

_Trazabilidad: OP-03 · K05 · E03, E06._

#### Scenario: Reasignación registrada
- **WHEN** el coordinador reasigna una solicitud e indica el motivo
- **THEN** el historial muestra persona, fecha y hora, responsable anterior, responsable nuevo y motivo

#### Scenario: Reasignación sin motivo
- **WHEN** se intenta reasignar sin motivo
- **THEN** el sistema rechaza la reasignación

### Requirement: Continuidad ante la ausencia de un agente
El sistema SHALL permitir marcar a un colaborador como ausente y reasignar de una sola vez sus solicitudes abiertas.

_Trazabilidad: OP-03 · K04, K05 · E09._

#### Scenario: Agente ausente
- **WHEN** el coordinador marca ausente a un agente
- **THEN** el sistema lista sus solicitudes abiertas como «sin responsable activo»

#### Scenario: Reasignación por lote
- **WHEN** el coordinador reasigna las solicitudes de un agente ausente a otro con un motivo único
- **THEN** cada solicitud queda con el responsable nuevo y su propio registro de reasignación

### Requirement: Permisos de asignación
El sistema SHALL permitir que un agente asuma solicitudes sin responsable activo y que solo el coordinador reasigne solicitudes de otro agente.

_Trazabilidad: OP-03 · E04._

#### Scenario: Agente intenta reasignar una solicitud ajena
- **WHEN** un agente intenta reasignar una solicitud cuyo responsable activo es otro agente
- **THEN** el sistema lo rechaza e indica que debe hacerlo el coordinador
