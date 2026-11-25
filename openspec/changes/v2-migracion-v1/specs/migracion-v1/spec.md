# Delta para Migración desde la V1

## ADDED Requirements

### Requirement: Importación de un respaldo de la V1
El sistema SHALL cargar en la base de datos un archivo JSON de respaldo de la V1, y SHALL rechazar un archivo con estructura inválida o de un ambiente distinto al de destino.

_Trazabilidad: L01 · H1 «respaldo» (recuperación) · OP-12 · E08._

#### Scenario: Respaldo válido
- **WHEN** el administrador técnico importa un respaldo de la V1 del mismo ambiente
- **THEN** clientes, colaboradores, solicitudes y cambios quedan cargados en la base de datos

#### Scenario: Archivo inválido
- **WHEN** se importa un archivo que no tiene la estructura de un respaldo de la V1
- **THEN** la importación se rechaza y no se carga ningún dato

#### Scenario: Ambiente distinto
- **WHEN** se importa un respaldo de capacitación sobre el ambiente de trabajo
- **THEN** la importación se rechaza

### Requirement: Conservación de la identidad de los datos
El sistema SHALL conservar sin cambios las referencias, las fechas de recepción y de registro, los responsables, los cambios y sus motivos, y SHALL ajustar el consecutivo anual para que las referencias nuevas no repitan las importadas.

_Trazabilidad: L03 · H1 «solicitudes», «historial» · OP-01, OP-05 · E06, E07._

#### Scenario: Referencias idénticas
- **WHEN** se importa una solicitud con referencia SOL-2026-00012
- **THEN** queda guardada con esa misma referencia y las mismas fechas

#### Scenario: Consecutivo continúa
- **WHEN** se importa un respaldo cuya última referencia del año es SOL-2026-00025 y se registra una solicitud nueva
- **THEN** la solicitud nueva recibe SOL-2026-00026

### Requirement: Verificación por conteos y carga completa o nula
El sistema SHALL informar los conteos de clientes, colaboradores, solicitudes y cambios del archivo y de la base de datos, y SHALL cargar todo o nada.

_Trazabilidad: L09 · H1 «respaldo» (prueba de restauración) · OP-12 · K43 · E08._

#### Scenario: Conteos coinciden
- **WHEN** termina una importación exitosa
- **THEN** el informe muestra conteos iguales en el archivo y en la base de datos

#### Scenario: Falla a mitad de la carga
- **WHEN** un registro del archivo viola una restricción
- **THEN** no se carga ningún dato y el informe indica el registro con error

### Requirement: Importación repetible sin duplicados
El sistema SHALL poder repetir la importación del mismo archivo sin duplicar datos, y SHALL rechazarla si la referencia ya existe con datos que no provienen de la V1.

_Trazabilidad: L03 · H1 «solicitudes» (referencia única) · OP-01 · E07._

#### Scenario: Reimportar el mismo archivo
- **WHEN** se importa dos veces el mismo respaldo
- **THEN** los conteos de la base de datos no cambian en la segunda importación

#### Scenario: Colisión con datos de la V2
- **WHEN** el archivo contiene una referencia que ya existe con datos creados en la V2
- **THEN** la importación se rechaza y no modifica nada

### Requirement: Marca de origen de los datos migrados
El sistema SHALL marcar las solicitudes y los cambios migrados con su origen y SHALL registrar la migración en la auditoría con la persona, la fecha y hora y los conteos.

_Trazabilidad: L02 · H1 «historial» · OP-05 · E03._

#### Scenario: Distinguir lo migrado
- **WHEN** se consultan las solicitudes importadas
- **THEN** cada una indica que proviene de la V1

#### Scenario: Auditoría de la migración
- **WHEN** termina una importación
- **THEN** la auditoría muestra quién la hizo, cuándo y los conteos

### Requirement: Colaboradores migrados sin acceso inicial
El sistema SHALL cargar los colaboradores de la V1 como pendientes de cuenta y SHALL NOT permitirles ingresar hasta que el administrador técnico les asigne una cuenta individual.

_Trazabilidad: L05 · H1 «acceso-datos» (cuentas individuales) · OP-11 · E04, E08._

#### Scenario: Colaborador pendiente
- **WHEN** un colaborador migrado intenta ingresar antes de tener cuenta
- **THEN** el sistema no le permite el acceso
