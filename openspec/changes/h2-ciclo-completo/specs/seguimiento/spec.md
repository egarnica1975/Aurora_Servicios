# Delta para Seguimiento

## ADDED Requirements

### Requirement: Vista única de pendientes y vencimientos
El sistema SHALL ofrecer una vista de las solicitudes abiertas, ordenable por vencimiento y filtrable por responsable, canal y estado, que indique cuáles están vencidas y cuáles próximas a vencer según un umbral `[por definir]`.

_Trazabilidad: OP-08 · K10, K11 · E03, E06._

#### Scenario: Agente revisa sus pendientes
- **WHEN** un agente abre la vista filtrada por su nombre
- **THEN** ve sus solicitudes abiertas ordenadas por vencimiento, con las vencidas señaladas

#### Scenario: Pendientes vencidas no desaparecen
- **WHEN** una solicitud supera su vencimiento sin resolverse
- **THEN** permanece en la vista, marcada como vencida

### Requirement: Vista del coordinador
El sistema SHALL mostrar al coordinador las pendientes de todo el equipo, las solicitudes sin responsable activo y la antigüedad de las abiertas.

_Trazabilidad: OP-08 · K11 · E04, E09._

#### Scenario: Control del equipo
- **WHEN** el coordinador abre su vista
- **THEN** ve el número de abiertas por agente, las vencidas y las que no tienen responsable activo

### Requirement: Enlace desde la vista al detalle
El sistema SHALL permitir abrir desde cada línea de la vista la solicitud completa con su historia.

_Trazabilidad: OP-08 · E09._

#### Scenario: Del listado al detalle
- **WHEN** el usuario selecciona una solicitud de la vista
- **THEN** se abre su detalle con la línea de tiempo
