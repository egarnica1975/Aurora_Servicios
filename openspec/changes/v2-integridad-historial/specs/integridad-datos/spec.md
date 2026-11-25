# Delta para Integridad de datos

## ADDED Requirements

### Requirement: Historia generada por la base de datos
El sistema SHALL registrar cada cambio en cliente, pedido, asunto, canal, estado, responsable o anulación en la misma transacción que lo produce, con usuario, fecha y hora del servidor, valor anterior y valor nuevo, y SHALL rechazar un cambio cuyo autor no esté identificado.

_Trazabilidad: L02 · H1 «historial» (historia automática) · E07, E08._

#### Scenario: Cambio hecho por la aplicación
- **WHEN** un agente cambia el estado de «Abierta» a «En gestión»
- **THEN** la historia registra usuario, fecha y hora, valor anterior y valor nuevo

#### Scenario: Cambio hecho directamente en la base de datos
- **WHEN** se modifica el asunto con SQL directo identificando al usuario
- **THEN** el cambio queda registrado igual que si lo hubiera hecho la aplicación

#### Scenario: Cambio sin autor
- **WHEN** se intenta modificar una solicitud sin identificar al usuario
- **THEN** el cambio es rechazado y la solicitud no se modifica

### Requirement: Historia inmutable
El sistema SHALL rechazar la modificación y el borrado de cualquier cambio registrado, para cualquier rol de la aplicación, incluido el coordinador.

_Trazabilidad: L02 · H1 «historial» (historia inmutable) · E03._

#### Scenario: Intento de modificar un cambio
- **WHEN** un rol de la aplicación intenta actualizar un cambio registrado
- **THEN** la base de datos rechaza la operación y el registro permanece igual

#### Scenario: Intento de borrar un cambio
- **WHEN** un rol de la aplicación intenta borrar un cambio registrado
- **THEN** la base de datos rechaza la operación

### Requirement: Auditoría inmutable
El sistema SHALL rechazar la modificación y el borrado de los registros de auditoría y SHALL asignarles la fecha y hora del servidor.

_Trazabilidad: L02 · H1 «acceso-datos» (registro de auditoría) · E08._

#### Scenario: Intento de alterar la auditoría
- **WHEN** un rol de la aplicación intenta modificar o borrar un registro de auditoría
- **THEN** la base de datos rechaza la operación

### Requirement: Solicitudes sin borrado
El sistema SHALL rechazar el borrado de solicitudes y SHALL permitir anularlas únicamente con un motivo, conservando su historia.

_Trazabilidad: L02 · H1 «historial» (anulación con motivo) · E03._

#### Scenario: Intento de borrar una solicitud
- **WHEN** un rol de la aplicación intenta borrar una solicitud
- **THEN** la base de datos rechaza la operación

#### Scenario: Anulación sin motivo
- **WHEN** se intenta anular una solicitud sin motivo
- **THEN** la base de datos rechaza el cambio

#### Scenario: Anulación con motivo
- **WHEN** el coordinador anula una solicitud e indica el motivo
- **THEN** la solicitud sigue existiendo, queda anulada y su historia se conserva

### Requirement: Referencia única, estable y sin repeticiones
El sistema SHALL asignar a cada solicitud una referencia con el formato SOL-AAAA-NNNNN mediante una secuencia anual dentro de la transacción, SHALL NOT reutilizarla ni permitir cambiarla, y SHALL asignar referencias distintas aunque dos registros ocurran al mismo tiempo.

_Trazabilidad: L03, L10 · H1 «solicitudes» (referencia única) · E06, E07._

#### Scenario: Registros simultáneos
- **WHEN** dos agentes guardan solicitudes al mismo tiempo
- **THEN** cada solicitud recibe una referencia distinta

#### Scenario: La referencia no cambia
- **WHEN** se intenta modificar la referencia de una solicitud existente
- **THEN** la base de datos rechaza el cambio

#### Scenario: Cambio de año
- **WHEN** se registra la primera solicitud de un año nuevo
- **THEN** su referencia lleva el año nuevo y el consecutivo 00001

### Requirement: Campos de registro fijos
El sistema SHALL asignar la fecha y hora de registro con el reloj del servidor, SHALL guardar por separado la fecha de recepción informada, y SHALL NOT permitir cambiar la fecha de registro ni quien registró.

_Trazabilidad: L02 · H1 «solicitudes» (registro posterior al contacto) · E03, E07._

#### Scenario: Registro posterior al contacto
- **WHEN** un agente registra una solicitud e indica una fecha de recepción anterior
- **THEN** se guardan la fecha de recepción informada y, por separado, la fecha y hora del registro del servidor

#### Scenario: Alterar la fecha de registro
- **WHEN** se intenta modificar la fecha de registro de una solicitud
- **THEN** la base de datos rechaza el cambio

### Requirement: Reasignación con motivo obligatorio
El sistema SHALL mantener exactamente un responsable por solicitud y SHALL rechazar en la base de datos un cambio de responsable que no traiga motivo.

_Trazabilidad: L04 · H1 «asignacion» (reasignación con evidencia) · E03, E06._

#### Scenario: Reasignación sin motivo
- **WHEN** se intenta cambiar el responsable sin motivo
- **THEN** la base de datos rechaza el cambio

#### Scenario: Reasignación registrada
- **WHEN** se cambia el responsable indicando el motivo
- **THEN** la historia muestra persona, fecha y hora, responsable anterior, responsable nuevo y motivo
