# Delta para Interfaz web

## ADDED Requirements

### Requirement: Misma funcionalidad que la V1 sobre la API
La interfaz SHALL ofrecer registro, bandeja con búsqueda y filtros, detalle con historia, cambio de estado, reasignación, anulación, panel del coordinador y administración de clientes, usando únicamente la API para leer y guardar datos.

_Trazabilidad: L01 · H1 «solicitudes», «seguimiento», «historial» · OP-01, OP-05 · E03, E04._

#### Scenario: Registrar desde la interfaz
- **WHEN** un asesor completa el formulario y confirma
- **THEN** la interfaz muestra la referencia devuelta por la API

#### Scenario: Datos desde la API
- **WHEN** se abre la bandeja
- **THEN** las solicitudes mostradas provienen de la base de datos y no de datos locales

### Requirement: Sin lógica de autoridad en el cliente
La interfaz SHALL NOT decidir por sí sola si una operación es válida o permitida; SHALL mostrar el resultado y el mensaje que devuelve el servidor.

_Trazabilidad: L04, L06 · H1 «solicitudes», «acceso-datos» · OP-01, OP-11 · E07._

#### Scenario: Operación rechazada por el servidor
- **WHEN** la API rechaza una operación
- **THEN** la interfaz muestra el mensaje recibido y no cambia lo mostrado

### Requirement: Ingreso con cuenta y sesión
La interfaz SHALL pedir correo y contraseña, SHALL mostrar el nombre y el rol de la persona autenticada y SHALL volver a la pantalla de ingreso cuando la sesión expire.

_Trazabilidad: L05, L07 · H1 «acceso-datos» · OP-11 · E04, E08._

#### Scenario: Ingreso exitoso
- **WHEN** la persona ingresa credenciales correctas
- **THEN** ve su nombre, su rol y las pantallas que le corresponden

#### Scenario: Credenciales incorrectas
- **WHEN** ingresa una contraseña incorrecta
- **THEN** ve un mensaje claro y no accede

### Requirement: Persistencia visible
La interfaz SHALL confirmar a la persona que sus cambios quedaron guardados y SHALL NOT pedirle exportar archivos para conservar los datos.

_Trazabilidad: L01 · H1 «solicitudes», «respaldo» · OP-12 · E04, E08._

#### Scenario: Cierre y reapertura
- **WHEN** una persona registra una solicitud, cierra el navegador y vuelve a ingresar
- **THEN** la solicitud sigue en la bandeja

### Requirement: Indicador de ambiente
La interfaz SHALL mostrar de forma visible si se está en el ambiente de capacitación o en el de trabajo.

_Trazabilidad: L11 · H1 «ambientes» · OP-12 · E04, E08._

#### Scenario: Ambiente de capacitación
- **WHEN** se ingresa al ambiente de capacitación
- **THEN** un aviso visible en todas las pantallas indica que son datos de práctica

### Requirement: Errores de conexión sin pérdida del borrador
La interfaz SHALL conservar lo digitado cuando una petición falle por problemas de red y SHALL informar la causa con un mensaje claro.

_Trazabilidad: L04 · H1 «solicitudes» (mensajes claros) · OP-01 · E04._

#### Scenario: Falla de red al guardar
- **WHEN** se pierde la conexión al registrar
- **THEN** el formulario conserva los datos digitados y se informa que no se pudo guardar

### Requirement: Importación de clientes desde la interfaz
La interfaz SHALL permitir al coordinador importar clientes desde un archivo JSON o CSV y SHALL mostrar el informe de la API con los registros cargados y rechazados.

_Trazabilidad: L04 · H1 «clientes» (importación) · OP-01 · E07._

#### Scenario: Importar un CSV con una fila inválida
- **WHEN** el coordinador importa un CSV con una fila sin nombre
- **THEN** se cargan las filas válidas y el informe señala la fila rechazada y el motivo
