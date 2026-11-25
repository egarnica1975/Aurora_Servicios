# Delta para Despliegue

## ADDED Requirements

### Requirement: Ambientes separados con configuración propia
El sistema SHALL ejecutarse en un ambiente de capacitación y uno de trabajo con bases de datos, credenciales y configuración distintas, de modo que una acción en uno no afecte al otro.

_Trazabilidad: L11 · H1 «ambientes» · OP-12 · E04, E08._

#### Scenario: Acción en capacitación
- **WHEN** se registra una solicitud en capacitación
- **THEN** no aparece en el ambiente de trabajo

### Requirement: Secretos fuera del repositorio
El sistema SHALL mantener credenciales, claves y cadenas de conexión fuera del repositorio y SHALL detectar su presencia accidental antes de desplegar.

_Trazabilidad: L06 · H1 «acceso-datos» · OP-11 · E04, E08._

#### Scenario: Secreto en el código
- **WHEN** un cambio incluye una clave en un archivo
- **THEN** la integración continua lo detecta y bloquea el despliegue

### Requirement: Conexión cifrada
El sistema SHALL servirse únicamente por HTTPS y SHALL conectarse a la base de datos con cifrado.

_Trazabilidad: L06 · H1 «acceso-datos» · OP-11 · E04._

#### Scenario: Petición sin cifrado
- **WHEN** se solicita la dirección por HTTP
- **THEN** el sistema responde solo por HTTPS

### Requirement: Integración continua con bloqueo
El sistema SHALL ejecutar en cada cambio la validación de las especificaciones y las pruebas de contrato, y SHALL NOT desplegar si alguna falla.

_Trazabilidad: L04 · H1 (todas las capacidades) · OP-01, OP-11 · E07, E08._

#### Scenario: Prueba fallida
- **WHEN** una prueba de contrato falla en un cambio
- **THEN** el despliegue no se realiza

### Requirement: Despliegue reproducible y reversible
El sistema SHALL desplegarse mediante un procedimiento automatizado y repetible y SHALL permitir volver a la versión anterior de la API.

_Trazabilidad: L04 · H1 «respaldo» (recuperación) · OP-12 · E07, E08._

#### Scenario: Volver a la versión anterior
- **WHEN** una versión nueva presenta un fallo grave
- **THEN** el administrador técnico restablece la versión anterior sin reconstruir

### Requirement: Costo documentado frente al límite
El sistema SHALL contar con un documento de costos que liste cada servicio, su precio vigente consultado y su fecha, y el total mensual comparado con el límite de operación del caso.

_Trazabilidad: L08 · H1 «respaldo» · OP-12 · E10._

#### Scenario: Revisión del costo
- **WHEN** se revisa el documento de costos
- **THEN** cada precio indica su fuente y fecha y el total se compara con COP 300.000 al mes

### Requirement: Observabilidad mínima
El sistema SHALL registrar errores y disponibilidad de la API de forma que el administrador técnico pueda diagnosticar una falla, sin registrar datos personales de clientes.

_Trazabilidad: L10 · H1 «acceso-datos» · OP-11 · E04, E08._

#### Scenario: Falla de la API
- **WHEN** la API devuelve errores
- **THEN** el administrador técnico encuentra el momento y el tipo de error sin ver datos de clientes
