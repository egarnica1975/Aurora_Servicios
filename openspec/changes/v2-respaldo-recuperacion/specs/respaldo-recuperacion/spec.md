# Delta para Respaldo y recuperación

## ADDED Requirements

### Requirement: Respaldo manual de la base de datos
El sistema SHALL permitir al administrador técnico generar una copia completa de la base de datos, con esquema y datos, mediante un procedimiento documentado, que se ejecuta como mínimo una vez por semana.

_Trazabilidad: L08 · H1 «respaldo» (respaldo) · OP-12 · E04, E08. Parcial: sin programación ni aviso de fallo._

#### Scenario: Generar la copia
- **WHEN** el administrador técnico ejecuta el procedimiento de respaldo
- **THEN** obtiene un archivo que contiene el esquema y los datos de la base

#### Scenario: Periodicidad semanal
- **WHEN** se revisa el registro de respaldos de las últimas dos semanas
- **THEN** hay al menos un respaldo registrado por cada semana

#### Scenario: Archivo fuera del repositorio
- **WHEN** se revisa el repositorio después de un respaldo
- **THEN** el archivo de respaldo no está en el repositorio

### Requirement: Registro del resultado de cada respaldo
El sistema SHALL permitir registrar el resultado de cada respaldo y de cada prueba, con fecha y hora, persona, éxito o fallo y conteos, en un registro que no pueda modificarse ni borrarse.

_Trazabilidad: L08 · H1 «respaldo» · OP-12 · K42 · E08._

#### Scenario: Registrar un respaldo
- **WHEN** el administrador técnico registra el resultado de un respaldo
- **THEN** el registro queda con la fecha y hora, la persona y el resultado

#### Scenario: Registro inmutable
- **WHEN** un rol de la aplicación intenta modificar o borrar un registro de respaldo
- **THEN** la operación es rechazada

### Requirement: Recuperación comprobada
El sistema SHALL poder restaurarse desde un respaldo en una base distinta mediante un procedimiento documentado, y SHALL existir al menos una prueba de restauración exitosa y registrada antes de la demostración o del piloto.

_Trazabilidad: L09 · H1 «respaldo» (recuperación comprobada) · OP-12 · K43 · E08._

#### Scenario: Prueba de restauración
- **WHEN** el administrador técnico restaura el último respaldo en una base de prueba
- **THEN** el número de solicitudes y de cambios coincide con el del origen y queda registrado

#### Scenario: Prueba previa
- **WHEN** se consulta el registro antes de la demostración o del piloto
- **THEN** existe al menos una prueba de restauración exitosa

### Requirement: Procedimiento de recuperación disponible
El sistema SHALL ofrecer a las personas autorizadas el procedimiento de respaldo y recuperación, con los pasos, los responsables y el resultado de la última prueba.

_Trazabilidad: L09 · H1 «respaldo» (procedimiento disponible) · OP-12 · K43 · E08._

#### Scenario: Consultar el procedimiento
- **WHEN** un integrante autorizado consulta el procedimiento
- **THEN** encuentra los pasos, los responsables y el último resultado de prueba
