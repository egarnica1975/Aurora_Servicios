# Delta para Uso de la capacidad liberada

## ADDED Requirements

### Requirement: Muestras de tiempo administrativo
El sistema SHALL permitir registrar muestras de minutos de trabajo administrativo por solicitud, con fecha, canal y persona que midió, y SHALL calcular el promedio por periodo.

_Trazabilidad: OP-02, OP-09 · K28 · E03._

#### Scenario: Promedio de la muestra
- **WHEN** se registran muestras de una misma semana
- **THEN** el sistema muestra el promedio en minutos, el tamaño de la muestra y la comparación con la línea base de 20 minutos

### Requirement: Horas liberadas frente a la línea base
El sistema SHALL calcular las horas liberadas al mes como (minutos de la línea base menos minutos actuales) por solicitudes del mes, entre 60, y SHALL presentarlas como capacidad disponible.

_Trazabilidad: OP-09 · K29 · E03, E10._

#### Scenario: Cálculo con las cifras del caso
- **WHEN** el promedio actual es 12 minutos y hay 600 solicitudes al mes
- **THEN** las horas liberadas son 80 al mes

### Requirement: Destino de las horas liberadas
El sistema SHALL permitir asignar las horas liberadas a actividades de servicio identificadas y registrar qué porcentaje tiene destino.

_Trazabilidad: OP-09 · K30 · E10._

#### Scenario: Horas sin destino
- **WHEN** hay horas liberadas sin actividad asignada
- **THEN** el tablero muestra el porcentaje sin destino

### Requirement: Sin ahorro monetario automático
El sistema SHALL NOT presentar las horas liberadas como ahorro monetario ni como reducción de nómina.

_Trazabilidad: OP-09 · K40 · E10._

#### Scenario: Valoración de la capacidad
- **WHEN** el tablero muestra las horas liberadas valoradas a COP 30.000 la hora
- **THEN** las etiqueta como capacidad disponible y no como ahorro
