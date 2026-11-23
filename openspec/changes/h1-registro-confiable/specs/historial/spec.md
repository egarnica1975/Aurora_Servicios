# Delta para Historial

## ADDED Requirements

### Requirement: Historia automática de cambios
El sistema SHALL registrar automáticamente cada cambio en cliente, pedido, asunto, canal, estado y responsable, con fecha y hora, usuario, valor anterior y valor nuevo.

_Trazabilidad: OP-05 · K26 · E07, E08._

#### Scenario: Cambio de estado
- **WHEN** un agente cambia el estado de «Abierta» a «En gestión»
- **THEN** el historial registra usuario, fecha y hora, valor anterior y valor nuevo

#### Scenario: Cambio sin registro manual
- **WHEN** se modifica un campo vigilado
- **THEN** el registro del cambio se crea sin que el usuario haga nada adicional

### Requirement: Historia inmutable y sin borrado
El sistema SHALL NOT permitir editar ni eliminar cambios registrados, y SHALL NOT permitir eliminar solicitudes; una solicitud solo puede anularse con motivo y conserva su historia.

_Trazabilidad: OP-05 · K01, K26 · E03._

#### Scenario: Intento de modificar la historia
- **WHEN** cualquier usuario, incluido el coordinador, intenta editar o borrar un cambio registrado
- **THEN** el sistema lo impide

#### Scenario: Anulación con motivo
- **WHEN** el coordinador anula una solicitud e indica el motivo
- **THEN** la solicitud sigue existiendo, queda marcada como anulada y cuenta en la cobertura de registro

### Requirement: Línea de tiempo de la solicitud
El sistema SHALL mostrar, para cada solicitud, la línea de tiempo de sus cambios en orden cronológico.

_Trazabilidad: OP-05 · E09._

#### Scenario: Reconstruir lo ocurrido
- **WHEN** un agente abre una solicitud que cambió de responsable dos veces
- **THEN** ve ambas reasignaciones, con quién y cuándo, sin consultar otra herramienta
