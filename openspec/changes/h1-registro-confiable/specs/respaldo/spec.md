# Delta para Respaldo y recuperación

## ADDED Requirements

### Requirement: Respaldo programado
El sistema SHALL generar copias de respaldo de todos sus datos con la frecuencia acordada con el proveedor `[por definir]` y SHALL registrar el resultado de cada copia.

_Trazabilidad: OP-12 · K42 · E04, E07, E08._

#### Scenario: Respaldo exitoso
- **WHEN** llega la hora programada del respaldo
- **THEN** se genera la copia y queda un registro de éxito con fecha y hora

#### Scenario: Respaldo fallido
- **WHEN** un respaldo programado falla
- **THEN** el administrador técnico recibe un aviso `[canal por definir]` y el fallo queda registrado

### Requirement: Recuperación comprobada
El sistema SHALL poder restaurarse desde un respaldo mediante un procedimiento documentado, y SHALL existir al menos una prueba de recuperación exitosa y registrada antes de iniciar el piloto.

_Trazabilidad: OP-12 · K43 · E08._

#### Scenario: Prueba de restauración
- **WHEN** el proveedor restaura el último respaldo en un ambiente de prueba
- **THEN** el número de solicitudes y de cambios coincide con el del origen y queda registrado el tiempo de recuperación

#### Scenario: Procedimiento disponible
- **WHEN** un integrante autorizado consulta el procedimiento de recuperación
- **THEN** encuentra los pasos, los responsables y el último resultado de prueba
