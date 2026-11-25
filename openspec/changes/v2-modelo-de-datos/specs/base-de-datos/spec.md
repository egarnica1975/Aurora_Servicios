# Delta para Base de datos

## ADDED Requirements

### Requirement: Persistencia en base de datos relacional
El sistema SHALL guardar clientes, colaboradores, solicitudes, cambios, auditoría y registros de respaldo en una base de datos relacional y SHALL conservarlos entre sesiones sin que el usuario exporte ni importe archivos.

_Trazabilidad: L01 · H1 «solicitudes», «respaldo» · E07, E08._

#### Scenario: Los datos sobreviven al cierre
- **WHEN** un agente registra una solicitud y cierra el navegador
- **THEN** al volver a ingresar la solicitud existe con su referencia

#### Scenario: Sin exportación manual
- **WHEN** un usuario trabaja durante una jornada sin exportar ningún archivo
- **THEN** ningún dato registrado se pierde al día siguiente

### Requirement: Esquema relacional con integridad referencial
El sistema SHALL relacionar solicitudes, cambios, colaboradores, clientes, canales y estados mediante claves primarias y foráneas, y SHALL rechazar en la base de datos cualquier registro que las viole.

_Trazabilidad: L04 · H1 «asignacion» (responsable único) · E03, E07._

#### Scenario: Cliente inexistente
- **WHEN** se intenta guardar una solicitud con un cliente que no existe
- **THEN** la base de datos rechaza el registro

#### Scenario: Solicitud sin responsable
- **WHEN** se intenta guardar una solicitud sin responsable o con uno que no existe
- **THEN** la base de datos rechaza el registro

#### Scenario: Asunto vacío
- **WHEN** se intenta guardar una solicitud con asunto vacío
- **THEN** la base de datos rechaza el registro

### Requirement: Catálogos controlados de canal y estado
El sistema SHALL aceptar para canal solo los valores mensajería, correo y teléfono, y para estado solo los del catálogo vigente, y SHALL permitir ampliar un catálogo únicamente mediante una migración versionada.

_Trazabilidad: L04 · H1 «solicitudes» (listas controladas) · E03, E07, E08._

#### Scenario: Canal fuera del catálogo
- **WHEN** se intenta guardar un canal que no está en el catálogo
- **THEN** la base de datos rechaza el valor

#### Scenario: Catálogo de estados inicial
- **WHEN** se consulta el catálogo de estados
- **THEN** contiene «Abierta» y «En gestión»

#### Scenario: Ampliación del catálogo
- **WHEN** se agrega un estado nuevo al catálogo mediante una migración
- **THEN** las solicitudes existentes conservan su estado sin cambios

### Requirement: Datos de contacto mínimos y pedido opcional
El sistema SHALL almacenar del contacto solo un nombre y un medio, ambos o ninguno, y SHALL permitir que una solicitud no tenga pedido y que varias solicitudes se refieran al mismo pedido.

_Trazabilidad: L04 · H1 «acceso-datos» (contacto mínimo), «solicitudes» (pedido opcional) · E08._

#### Scenario: Contacto incompleto
- **WHEN** se intenta guardar un nombre de contacto sin medio
- **THEN** la base de datos rechaza el registro

#### Scenario: Pedido compartido
- **WHEN** se guardan dos solicitudes con el mismo pedido PED1048
- **THEN** ambas quedan guardadas y ninguna reemplaza a la otra

### Requirement: Migraciones versionadas y reproducibles
El sistema SHALL definir su esquema mediante migraciones numeradas y guardadas en el repositorio, y SHALL NOT admitir cambios de esquema hechos a mano sobre un ambiente.

_Trazabilidad: L04 · H1 «respaldo» (recuperación) · E04, E07._

#### Scenario: Reconstruir desde cero
- **WHEN** se aplican todas las migraciones sobre una base vacía
- **THEN** se obtiene el esquema completo y sus catálogos iniciales

#### Scenario: Migración pendiente
- **WHEN** existe una migración nueva en el repositorio
- **THEN** se aplica en orden y queda registrada como aplicada

### Requirement: Datos de demostración desde archivos CSV
El sistema SHALL poder cargar datos ficticios de demostración desde archivos CSV mediante un procedimiento repetible que el administrador técnico ejecuta cuando se requiera presentar, y SHALL marcar esos registros como de demostración.

_Trazabilidad: L01 · H1 «acceso-datos» (solo registros ficticios en prueba) · E08._

#### Scenario: Cargar la demostración
- **WHEN** el administrador técnico ejecuta la carga de demostración sobre una base con el esquema vigente
- **THEN** la base queda con los clientes, colaboradores y solicitudes ficticios de los archivos CSV

#### Scenario: Registros identificables
- **WHEN** se consultan las solicitudes cargadas por la demostración
- **THEN** cada una indica que es de demostración

#### Scenario: Carga repetida
- **WHEN** se ejecuta dos veces la carga de demostración
- **THEN** los conteos no cambian en la segunda ejecución
