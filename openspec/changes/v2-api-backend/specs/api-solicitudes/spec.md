# Delta para API de solicitudes

## ADDED Requirements

### Requirement: Operaciones de H1 expuestas
El sistema SHALL ofrecer a través de la API todas las operaciones de H1: registrar, consultar y filtrar solicitudes, cambiar estado, reasignar, anular, consultar la historia y administrar clientes, de acuerdo con el rol de la persona.

_Trazabilidad: L04 · H1 «solicitudes», «clientes», «historial» · OP-01, OP-05 · E03, E07._

#### Scenario: Registro por la API
- **WHEN** un asesor autenticado registra una solicitud con los datos obligatorios
- **THEN** la respuesta incluye la referencia asignada y la solicitud queda guardada

#### Scenario: Operación sin permiso
- **WHEN** un usuario sin el rol necesario invoca una operación restringida
- **THEN** la API la rechaza con un mensaje que indica el permiso que falta

### Requirement: Reglas de negocio aplicadas en el servidor
El sistema SHALL validar y aplicar en el servidor las reglas de H1 (campos obligatorios, canal y estado válidos, contacto completo, motivo de reasignación y de anulación), sin depender de la interfaz.

_Trazabilidad: L04 · H1 «solicitudes» (campos obligatorios, valores controlados) · OP-01 · E07._

#### Scenario: Petición que omite la interfaz
- **WHEN** se envía directamente a la API una solicitud sin cliente
- **THEN** la API la rechaza y no guarda nada

#### Scenario: Reasignar sin motivo
- **WHEN** se invoca la reasignación sin motivo
- **THEN** la API rechaza la operación y el responsable no cambia

### Requirement: Mensajes de error claros
El sistema SHALL responder cada error con un mensaje en español que indique qué falló y cómo corregirlo, sin mostrar detalles internos.

_Trazabilidad: L04 · H1 «solicitudes» (mensajes claros) · OP-01 · E04._

#### Scenario: Campo obligatorio ausente
- **WHEN** falta el asunto al registrar
- **THEN** la respuesta nombra el campo y pide completarlo

#### Scenario: Error interno
- **WHEN** ocurre una falla inesperada en el servidor
- **THEN** la persona recibe un mensaje general y el detalle queda solo en el registro del servidor

### Requirement: Uso simultáneo sin pérdida de datos
El sistema SHALL permitir que varias personas trabajen al mismo tiempo y SHALL detectar la modificación concurrente de una misma solicitud, rechazando la segunda con un aviso.

_Trazabilidad: L10 · H1 «solicitudes» · OP-01 · E04, E07._

#### Scenario: Registros simultáneos
- **WHEN** dos asesores registran solicitudes al mismo tiempo
- **THEN** cada una recibe una referencia distinta y ninguna se pierde

#### Scenario: Edición simultánea
- **WHEN** dos personas modifican la misma solicitud desde la misma versión
- **THEN** la segunda recibe un aviso de que los datos cambiaron y no sobrescribe a la primera

### Requirement: Aviso de posible duplicado
El sistema SHALL avisar, antes de registrar, cuando exista una solicitud abierta del mismo cliente con el mismo asunto, y SHALL permitir continuar solo con confirmación.

_Trazabilidad: L04 · H1 «solicitudes» (duplicados) · OP-01 · E07._

#### Scenario: Posible duplicado
- **WHEN** se registra una solicitud igual a una abierta del mismo cliente
- **THEN** la API informa la referencia existente y exige confirmación para continuar

### Requirement: Pruebas de contrato de los escenarios de H1
El sistema SHALL tener una prueba automatizada por cada escenario de H1 cubierto, ejecutable sin datos reales, y SHALL NOT declarar cubierto un escenario cuya prueba falle.

_Trazabilidad: L04 · H1 (todas las capacidades) · OP-01, OP-05, OP-11 · E07, E08._

#### Scenario: Ejecución de las pruebas
- **WHEN** se ejecutan las pruebas contra una base de datos local con datos ficticios
- **THEN** cada escenario cubierto de H1 tiene una prueba y todas pasan
