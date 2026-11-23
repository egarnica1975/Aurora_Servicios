# Delta para Acceso y datos

## ADDED Requirements

### Requirement: Cuentas individuales
El sistema SHALL exigir una cuenta individual por persona y SHALL NOT permitir cuentas compartidas.

_Trazabilidad: OP-11 · K35, K41 · E04, E08._

#### Scenario: Alta de usuario
- **WHEN** el administrador técnico crea una cuenta
- **THEN** debe indicar el nombre de una persona y un identificador único de acceso

#### Scenario: Ingreso sin cuenta propia
- **WHEN** alguien intenta ingresar sin credenciales individuales
- **THEN** el sistema no le permite el acceso

### Requirement: Roles y permisos
El sistema SHALL aplicar cuatro roles con permisos diferenciados: agente, coordinador, consulta y administrador técnico.

_Trazabilidad: OP-11 · K35 · E04, E08. Los roles salen de las partes interesadas del caso (E04: agentes, coordinador, ventas, logística, gerencia, proveedor); los permisos exactos son supuesto de diseño._

#### Scenario: Agente registra y edita lo propio
- **WHEN** un agente registra o edita una solicitud de la que es responsable
- **THEN** el sistema lo permite

#### Scenario: Coordinador reasigna
- **WHEN** el coordinador reasigna la solicitud de otro agente
- **THEN** el sistema lo permite

#### Scenario: Consulta no modifica
- **WHEN** un usuario con rol de consulta, como ventas, logística o gerencia, intenta editar una solicitud
- **THEN** el sistema lo impide y le permite verla

#### Scenario: El proveedor no ve datos de clientes
- **WHEN** el administrador técnico ingresa
- **THEN** puede gestionar cuentas y respaldos pero no ve el contenido de las solicitudes

### Requirement: Datos de contacto mínimos
El sistema SHALL almacenar del contacto solo el nombre y un medio de contacto, sin otros datos personales.

_Trazabilidad: OP-11 · K36 · E08._

#### Scenario: Campos permitidos
- **WHEN** el agente registra un contacto
- **THEN** solo puede indicar nombre y teléfono o correo

### Requirement: Registro de auditoría
El sistema SHALL registrar cada inicio de sesión, éxito o fallo, y cada acción administrativa, con persona y fecha y hora.

_Trazabilidad: OP-11 · K35 · E08._

#### Scenario: Inicio de sesión fallido
- **WHEN** alguien falla el ingreso
- **THEN** queda registrado el intento con su fecha y hora

#### Scenario: Cambio de rol
- **WHEN** el administrador técnico cambia el rol de un usuario
- **THEN** el registro de auditoría muestra quién lo hizo, cuándo y el rol anterior y nuevo

### Requirement: Ambiente de capacitación con datos ficticios
El sistema SHALL ofrecer un ambiente de capacitación separado que contenga solo registros ficticios.

_Trazabilidad: OP-11 · E08, E10._

#### Scenario: Separación de ambientes
- **WHEN** un agente practica en el ambiente de capacitación
- **THEN** ninguna de sus acciones aparece en los datos reales
