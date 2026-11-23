# Delta para Canales y retiro de la hoja

## ADDED Requirements

### Requirement: Conversaciones vinculadas a la referencia
El sistema SHALL permitir asociar a una solicitud uno o varios registros de conversación, como texto o archivo, con su canal y fecha, para no depender de copiar entre herramientas.

_Trazabilidad: OP-13 · K01, K28 · E07._

#### Scenario: Vincular un correo
- **WHEN** el agente asocia el texto de un correo a una solicitud
- **THEN** queda guardado con su canal «correo», su fecha y la referencia

#### Scenario: Canales se mantienen
- **WHEN** el agente atiende por mensajería, correo o teléfono
- **THEN** puede seguir usando esa herramienta y registrar la solicitud una sola vez

### Requirement: Importación de la hoja A02
El sistema SHALL importar las solicitudes abiertas de la hoja A02 a partir de un archivo con sus columnas, y SHALL entregar un informe de las filas rechazadas con el motivo.

_Trazabilidad: OP-13 · K01, K33 · E07._

#### Scenario: Fila completa
- **WHEN** una fila de la hoja trae los campos obligatorios y valores de las listas
- **THEN** se crea la solicitud con referencia nueva y conserva la fecha de recepción original

#### Scenario: Fila incompleta
- **WHEN** una fila no trae asunto o responsable
- **THEN** no se importa y aparece en el informe con el motivo; el sistema no inventa valores

### Requirement: Corte de la hoja como sistema de registro
El sistema SHALL registrar la fecha del corte, a partir de la cual la hoja A02 deja de ser el sistema de registro.

_Trazabilidad: OP-13 · E07._

#### Scenario: Después del corte
- **WHEN** se consulta el estado de la migración
- **THEN** se ve la fecha del corte, el número de solicitudes importadas y el de rechazadas
