# Delta para Autenticación

## ADDED Requirements

### Requirement: Cuentas individuales
El sistema SHALL exigir una cuenta individual con credenciales propias para ingresar, y SHALL NOT permitir cuentas compartidas ni ingreso sin autenticación.

_Trazabilidad: L05 · H1 «acceso-datos» (cuentas individuales) · OP-11 · E04, E08._

#### Scenario: Ingreso con credenciales
- **WHEN** una persona ingresa con su correo y su contraseña correctos
- **THEN** accede con su propia identidad

#### Scenario: Sin autenticación
- **WHEN** se invoca una operación sin sesión válida
- **THEN** la API la rechaza

### Requirement: Permisos por rol aplicados en el servidor
El sistema SHALL aplicar en el servidor los permisos de los cuatro roles (asesor, coordinador, jefe de operaciones y administrador técnico), y el administrador técnico SHALL NOT poder leer el contenido de las solicitudes.

_Trazabilidad: L06 · H1 «acceso-datos» (permisos por rol) · OP-11 · E04, E08._

#### Scenario: Asesor sin permiso de anular
- **WHEN** un asesor intenta anular una solicitud
- **THEN** la operación es rechazada

#### Scenario: Administrador técnico y contenido
- **WHEN** el administrador técnico intenta leer el asunto de una solicitud
- **THEN** el sistema se lo impide

### Requirement: Auditoría de ingreso y de ingreso fallido
El sistema SHALL registrar cada ingreso y cada intento fallido, con persona o correo, fecha y hora y resultado, en un registro que no pueda modificarse.

_Trazabilidad: L07 · H1 «acceso-datos» (auditoría de acceso) · OP-11 · E04, E08._

#### Scenario: Ingreso fallido
- **WHEN** alguien ingresa con una contraseña incorrecta
- **THEN** el intento queda registrado con el correo, la fecha y hora y el resultado fallido

#### Scenario: Ingreso exitoso
- **WHEN** una persona ingresa correctamente
- **THEN** el ingreso queda registrado con su identidad y la fecha y hora

### Requirement: Administración de usuarios sin borrar historia
El sistema SHALL permitir al administrador técnico crear cuentas, asignarlas a colaboradores y desactivarlas, y SHALL conservar toda la historia de quien se desactive.

_Trazabilidad: L05 · H1 «acceso-datos» (administración de usuarios) · OP-11 · E04, E08._

#### Scenario: Desactivar a un colaborador
- **WHEN** el administrador técnico desactiva la cuenta de un colaborador con cambios registrados
- **THEN** la persona ya no puede ingresar y sus cambios anteriores siguen visibles

#### Scenario: Asignar cuenta a colaborador migrado
- **WHEN** el administrador técnico asigna una cuenta a un colaborador pendiente
- **THEN** el colaborador puede ingresar con su rol

### Requirement: Sesión con expiración
El sistema SHALL cerrar la sesión tras el tiempo de inactividad acordado `[por definir]` y SHALL exigir autenticación de nuevo.

_Trazabilidad: L05 · H1 «acceso-datos» · OP-11 · E04._

#### Scenario: Sesión expirada
- **WHEN** se usa una sesión que superó el tiempo acordado
- **THEN** la API la rechaza y pide ingresar de nuevo
