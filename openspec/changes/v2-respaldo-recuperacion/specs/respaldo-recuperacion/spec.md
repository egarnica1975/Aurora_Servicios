# Delta para Respaldo y recuperación

## ADDED Requirements

### Requirement: Respaldo programado
El sistema SHALL generar copias de respaldo de todos los datos del ambiente de trabajo con la frecuencia acordada con el proveedor `[por definir]`, sin intervención manual.

_Trazabilidad: L08 · H1 «respaldo» (respaldo programado) · OP-12 · K42 · E04, E07, E08._

#### Scenario: Respaldo exitoso
- **WHEN** llega la hora programada del respaldo
- **THEN** se genera la copia sin intervención de ninguna persona

#### Scenario: Sin intervención manual
- **WHEN** pasan varios días sin que nadie exporte nada
- **THEN** existen copias de respaldo de cada día programado

### Requirement: Registro del resultado de cada respaldo
El sistema SHALL registrar el resultado de cada respaldo, con fecha y hora, éxito o fallo y detalle, en un registro que el administrador técnico pueda consultar y que no pueda modificarse.

_Trazabilidad: L08 · H1 «respaldo» · OP-12 · K42 · E08._

#### Scenario: Consulta del registro
- **WHEN** el administrador técnico consulta el registro de respaldos
- **THEN** ve cada respaldo con su fecha y hora y su resultado

#### Scenario: Registro inmutable
- **WHEN** un rol de la aplicación intenta modificar o borrar un registro de respaldo
- **THEN** la operación es rechazada

### Requirement: Aviso de respaldo fallido
El sistema SHALL avisar al administrador técnico por el canal acordado `[por definir]` cuando un respaldo programado falle, y SHALL dejar el fallo registrado.

_Trazabilidad: L08 · H1 «respaldo» (respaldo fallido) · OP-12 · E04, E08._

#### Scenario: Fallo de un respaldo
- **WHEN** un respaldo programado falla
- **THEN** el administrador técnico recibe un aviso y el fallo queda registrado con fecha y hora

### Requirement: Recuperación comprobada
El sistema SHALL poder restaurarse desde un respaldo en un ambiente distinto mediante un procedimiento documentado, y SHALL existir al menos una prueba de restauración exitosa y registrada antes de iniciar el piloto.

_Trazabilidad: L09 · H1 «respaldo» (recuperación comprobada) · OP-12 · K43 · E08._

#### Scenario: Prueba de restauración
- **WHEN** el proveedor restaura el último respaldo en un ambiente de prueba
- **THEN** el número de solicitudes y de cambios coincide con el del origen y queda registrado el tiempo de recuperación

#### Scenario: Prueba previa al piloto
- **WHEN** se consulta el registro antes de iniciar el piloto
- **THEN** existe al menos una prueba de restauración exitosa

### Requirement: Procedimiento de recuperación disponible
El sistema SHALL ofrecer a las personas autorizadas el procedimiento de recuperación, con los pasos, los responsables y el resultado de la última prueba.

_Trazabilidad: L09 · H1 «respaldo» (procedimiento disponible) · OP-12 · K43 · E08._

#### Scenario: Consultar el procedimiento
- **WHEN** un integrante autorizado consulta el procedimiento de recuperación
- **THEN** encuentra los pasos, los responsables y el último resultado de prueba
