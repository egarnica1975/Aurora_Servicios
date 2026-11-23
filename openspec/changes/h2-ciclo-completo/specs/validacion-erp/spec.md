# Delta para Validación contra el ERP

## ADDED Requirements

### Requirement: Validar cliente y pedido
El sistema SHALL validar contra el ERP que el cliente existe y que el pedido indicado pertenece a ese cliente.

_Trazabilidad: OP-10 · K31, K32 · E07, E08._

#### Scenario: Pedido de otro cliente
- **WHEN** el agente indica un pedido que el ERP asigna a otro cliente
- **THEN** el sistema advierte la inconsistencia y no guarda hasta corregirla

#### Scenario: Pedido inexistente
- **WHEN** el agente indica un número de pedido que no existe en el ERP
- **THEN** el sistema lo rechaza con un mensaje claro

#### Scenario: Solicitud sin pedido
- **WHEN** la solicitud no se refiere a un pedido
- **THEN** el sistema la guarda sin exigir pedido

### Requirement: Continuidad cuando el ERP no responde
El sistema SHALL permitir registrar la solicitud con la marca «pendiente de validación» si el ERP no está disponible, y SHALL validarla en cuanto vuelva a estarlo.

_Trazabilidad: OP-10 · K32 · E07._

#### Scenario: ERP no disponible
- **WHEN** el agente guarda una solicitud y el ERP no responde
- **THEN** la solicitud se guarda con la marca «pendiente de validación»

### Requirement: El ERP solo se lee
El sistema SHALL NOT escribir ni modificar datos en el ERP.

_Trazabilidad: OP-10 · E07._

#### Scenario: Sin escritura
- **WHEN** se corrige el cliente o el pedido de una solicitud
- **THEN** el ERP no recibe ningún cambio
