## Contexto

Aurora no tiene equipo de desarrollo; un proveedor externo administra accesos y respaldos y acompaña un piloto de 6 semanas (E07). El ERP sigue siendo la referencia de clientes y pedidos. Volumen: unas 600 solicitudes al mes (E01), por lo que el rendimiento no es una restricción del caso.

## Objetivos / No objetivos

- **Objetivos:** que los escenarios de `specs/` pasen de forma verificable y que un agente aprenda a registrar en una sesión corta (E10).
- **No objetivos en H1:** resolución y reapertura, vista de vencimientos, consulta a ventas y logística, validación contra el ERP, indicadores y retiro de la hoja (H2 y H3).

## Decisiones

### D1. Realización de APP-05: abierta (supuesto de decisión)

| Opción | Descripción | Qué debe demostrar con los escenarios de H1 |
|---|---|---|
| A | Hoja mejorada con listas, campos obligatorios y protección | Que logra referencia única, historia inmutable, reasignación con evidencia y acceso individual; el caso exige justificar qué necesidad no cubre hoy (E07) |
| B | Herramienta de gestión de casos como servicio | Que cubre los escenarios sin desarrollo y que su costo mensual cabe en COP 300.000 (E10) |
| C | Desarrollo a la medida con SDD | Que el proveedor puede mantenerla sin equipo de desarrollo propio (E07, E04) |

**Procedimiento propuesto:** ejecutar los escenarios de H1 como prueba de aceptación contra cada opción y comparar cuántos pasan, el costo y el esfuerzo de mantenimiento. Sin datos de precio en el caso no se recomienda una opción.

### D2. Si se elige la opción C (supuesto, por confirmar con el proveedor)

Aplicación web de una sola base de datos relacional, con autenticación individual y un servicio de respaldo del proveedor. No se fija lenguaje ni plataforma: debe ser lo que el proveedor ya mantenga. Las reglas de negocio (referencia, historial, reasignación) viven en el servidor, no en la pantalla.

### D3. Modelo de datos (del modelo conceptual, ENT-xx)

- **Solicitud (ENT-04):** referencia, cliente, contacto, pedido opcional, asunto, canal, estado, responsable, fecha de recepción, fecha de registro.
- **Cambio de solicitud (ENT-08):** solicitud, fecha y hora, usuario, campo, valor anterior, valor nuevo, motivo opcional.
- **Colaborador (ENT-09):** persona con cuenta individual, rol y estado activo o ausente.
- **Canal (ENT-05) y Estado (ENT-06):** listas controladas.
- Cliente (ENT-01), Contacto (ENT-02) y Pedido (ENT-03): en H1 se capturan como identificador y nombre de referencia; H2 los valida contra el ERP.

### D4. Historia por diseño

La historia se genera en la misma operación que cambia el dato. Ninguna pantalla ni función permite editar o borrar un cambio registrado (E03: no aceptar mejora aparente).

### D5. Convivencia con la hoja A02

Durante H1 la hoja sigue siendo el sistema oficial en paralelo para no detener la atención. La importación y el retiro son de H2.

## Riesgos y compensaciones

- **Doble digitación durante el piloto** por la convivencia con la hoja: se acepta como costo temporal; se mide con K28 en H3.
- **Resistencia a campos obligatorios** (tensión «control vs. registro excesivo», E04): se limitan a los mínimos del caso (E08).
- **Dependencia del proveedor** para accesos y respaldo (E07): los escenarios de `respaldo` y `acceso-datos` se verifican con él.

## Preguntas abiertas

Ver `proposal.md`.
