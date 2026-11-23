# Delta para Verificación independiente

## ADDED Requirements

### Requirement: Contraste de cobertura contra los canales
El sistema SHALL permitir cargar, por periodo y canal, el número de solicitudes recibidas contado directamente en el canal, y SHALL calcular con él la cobertura de registro y su concordancia con lo reportado.

_Trazabilidad: OP-09 · K01, K26, K27 · E03._

#### Scenario: Contraste de un periodo
- **WHEN** el verificador carga 600 solicitudes recibidas contadas en los canales y el sistema tiene 540 registradas
- **THEN** la cobertura es 90 % y el contraste queda guardado con fecha y persona

#### Scenario: Registro del contraste
- **WHEN** se carga un contraste
- **THEN** cuenta como una verificación independiente realizada en el periodo

### Requirement: El verificador no es quien registra
El sistema SHALL NOT permitir que la persona que registró solicitudes en un periodo cargue la verificación de ese mismo periodo.

_Trazabilidad: OP-09 · K26 · E03._

#### Scenario: Verificación propia
- **WHEN** un agente que registró solicitudes del periodo intenta cargar su verificación
- **THEN** el sistema lo impide e indica que la hace otra persona

### Requirement: Rol de verificador
El sistema SHALL ofrecer un rol de verificador con permiso de lectura de las solicitudes y de carga de contrastes, y sin permiso de editar solicitudes.

_Trazabilidad: OP-09 · E03. Rol nuevo; supuesto de diseño._

#### Scenario: El verificador no edita
- **WHEN** el verificador intenta editar una solicitud
- **THEN** el sistema lo impide
