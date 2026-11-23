# Delta para Solicitudes

## ADDED Requirements

### Requirement: Referencia única por solicitud
El sistema SHALL asignar a cada solicitud, al crearla, una referencia única que no cambie ni se reutilice, y SHALL mostrarla al agente para comunicarla al cliente.

_Trazabilidad: OP-01 · K02, K03 · E06, E07._

#### Scenario: Referencia generada al guardar
- **WHEN** un agente guarda una solicitud nueva
- **THEN** el sistema asigna una referencia única y la muestra en pantalla

#### Scenario: La referencia no cambia al editar
- **WHEN** se modifica cualquier campo de una solicitud existente
- **THEN** su referencia permanece igual

#### Scenario: Dos solicitudes nunca comparten referencia
- **WHEN** dos agentes guardan solicitudes al mismo tiempo
- **THEN** cada solicitud recibe una referencia distinta

### Requirement: Registro en el primer contacto con una sola acción
El sistema SHALL permitir registrar una solicitud completa en una sola acción, sin copiar datos de otra herramienta, con cliente, contacto, asunto, canal, fecha de recepción y responsable.

_Trazabilidad: OP-02 · K01, K28 · E03, E07._

#### Scenario: Registro completo en un paso
- **WHEN** el agente completa los campos mínimos y guarda
- **THEN** la solicitud queda registrada con estado «Abierta» y con la referencia asignada

#### Scenario: Registro posterior al contacto
- **WHEN** el agente registra una solicitud después de haber recibido el contacto y indica la fecha y hora reales de recepción
- **THEN** el sistema guarda la fecha de recepción real y, por separado, la fecha y hora del registro

### Requirement: Campos obligatorios
El sistema SHALL impedir guardar una solicitud si falta cliente, asunto, canal, fecha de recepción o responsable.

_Trazabilidad: OP-04 · K33 · E07, E08._

#### Scenario: Falta un campo obligatorio
- **WHEN** el agente intenta guardar sin indicar el asunto
- **THEN** el sistema rechaza el guardado y señala el campo faltante

### Requirement: Listas controladas de canal y estado
El sistema SHALL aceptar para canal solo los valores mensajería, correo y teléfono, y para estado solo los valores del catálogo vigente, sin texto libre.

_Trazabilidad: OP-04 · K34 · E03, E07, E08._

#### Scenario: Valor fuera de la lista
- **WHEN** se intenta guardar un canal que no está en la lista
- **THEN** el sistema rechaza el valor y ofrece los de la lista

#### Scenario: Catálogo de estados inicial
- **WHEN** se consulta el catálogo de estados de este horizonte
- **THEN** contiene «Abierta» y «En gestión»

### Requirement: Pedido opcional y compartido
El sistema SHALL permitir que una solicitud no tenga pedido y que varias solicitudes se refieran al mismo pedido.

_Trazabilidad: OP-01 · E08._

#### Scenario: Solicitud sin pedido
- **WHEN** el agente registra una aclaración comercial sin número de pedido
- **THEN** el sistema la guarda sin pedido

#### Scenario: Varias solicitudes del mismo pedido
- **WHEN** se registran dos solicitudes que refieren el pedido PED1048
- **THEN** ambas quedan asociadas a ese pedido y ninguna reemplaza a la otra

### Requirement: Búsqueda de solicitudes
El sistema SHALL permitir buscar solicitudes por referencia, cliente, pedido, responsable, estado y rango de fechas de recepción.

_Trazabilidad: OP-01, OP-02 · K03, K28 · E09._

#### Scenario: Evitar que el cliente repita su historia
- **WHEN** un agente busca por el pedido PED1048
- **THEN** ve todas las solicitudes asociadas con su estado, responsable y fechas

#### Scenario: Aviso de posible duplicado
- **WHEN** el agente guarda una solicitud con el mismo cliente y pedido de otra abierta
- **THEN** el sistema avisa de la posible duplicidad y permite continuar o abrir la existente
