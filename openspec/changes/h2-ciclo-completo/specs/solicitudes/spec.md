# Delta para Solicitudes

## MODIFIED Requirements

### Requirement: Listas controladas de canal y estado
El sistema SHALL aceptar para canal solo los valores mensajería, correo y teléfono, y para estado solo los valores del catálogo vigente, sin texto libre. El catálogo de estados SHALL contener «Abierta», «En gestión», «Esperando consulta», «Resuelta» y «Reabierta».

_Trazabilidad: OP-04, OP-06, OP-07 · K34 · E03, E07, E08._

#### Scenario: Valor fuera de la lista
- **WHEN** se intenta guardar un canal o un estado que no está en la lista
- **THEN** el sistema rechaza el valor y ofrece los de la lista

#### Scenario: Catálogo de estados ampliado
- **WHEN** se consulta el catálogo de estados
- **THEN** contiene «Abierta», «En gestión», «Esperando consulta», «Resuelta» y «Reabierta»

#### Scenario: Solicitudes anteriores
- **WHEN** se consultan solicitudes creadas antes de este cambio
- **THEN** conservan su estado «Abierta» o «En gestión» sin alteraciones
