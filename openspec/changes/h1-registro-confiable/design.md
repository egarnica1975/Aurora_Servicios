## Contexto

Aurora no tiene equipo de desarrollo; un proveedor externo administra accesos y respaldos y acompaña un piloto de 6 semanas (E07). El ERP sigue siendo la referencia de clientes y pedidos. Volumen: unas 600 solicitudes al mes (E01), por lo que el rendimiento no es una restricción del caso.

## Objetivos / No objetivos

- **Objetivos:** que los escenarios de `specs/` pasen de forma verificable y que un agente aprenda a registrar en una sesión corta (E10).
- **No objetivos en H1:** resolución y reapertura, vista de vencimientos, consulta a ventas y logística, validación contra el ERP, indicadores y retiro de la hoja (H2 y H3).

## Decisiones

### D1. Realización de APP-05: opción C en su forma V1 (decisión, 23-nov-2026)

Se elige la opción C (desarrollo a la medida con SDD) como primera versión. Las opciones A y B quedan descartadas para este ciclo por decisión del equipo del curso, no por una comparación de costos: el caso no trae precios, así que no hay base para afirmar que C sea la más económica. La V1 sirve para validar el flujo y el alcance con datos ficticios; la V2 (servidor y base de datos) se especifica en cambios nuevos.

### D2. Stack de la V1

| Componente | Tecnología | Función |
|---|---|---|
| Interfaz | HTML5 | Formularios, bandeja e historial |
| Diseño visual | CSS3 | Presentación adaptable a distintos tamaños de pantalla |
| Lógica de negocio | JavaScript | Registro, asignación, estados y cálculo de plazos |
| Datos durante el uso | Objetos y arreglos de JavaScript | Gestionar clientes, usuarios y solicitudes |
| Guardado y recuperación | Archivos JSON | Exportar los datos y cargarlos al volver a abrir la aplicación |
| Importación de clientes | JSON y CSV | Cargar el directorio de pruebas |
| Ejecución | Navegador instalado | Abrir un archivo HTML con doble clic |
| Distribución | Un archivo HTML con CSS y JavaScript | Entregar la aplicación lista para usar (`app/index.html`) |

Las reglas de negocio (referencia, historial, reasignación) viven en funciones de JavaScript separadas de la pantalla.

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

### D6. Cobertura de la V1 frente a los requisitos de H1

Los requisitos no cambian; esta tabla declara qué se cumple de verdad con un archivo HTML sin servidor.

| Capacidad | Requisito | Cobertura | Justificación |
|---|---|---|---|
| solicitudes | Referencia única | Completa | La referencia se genera al guardar y no cambia; la unicidad es dentro del archivo de datos. El escenario de dos agentes al mismo tiempo solo se cumple dentro de un archivo, porque no hay servidor compartido |
| solicitudes | Registro en una sola acción | Completa | Formulario único con fecha de recepción y fecha de registro por separado |
| solicitudes | Campos obligatorios | Completa | Validación en la función de guardado |
| solicitudes | Listas controladas | Completa | Canal: mensajería, correo, teléfono; estado: Abierta, En gestión |
| solicitudes | Pedido opcional y compartido | Completa | Varias solicitudes pueden apuntar al mismo pedido |
| solicitudes | Búsqueda | Completa | Filtros de la bandeja y aviso de posible duplicado |
| asignacion | Los cuatro requisitos | Completa | Responsable único, reasignación con motivo, ausencia y lote, permisos por rol |
| historial | Historia automática y línea de tiempo | Completa | Se genera en la misma función que cambia el dato |
| historial | Inmutable y sin borrado | Parcial | La aplicación no ofrece editar ni borrar; el JSON exportado se puede editar fuera de ella |
| acceso-datos | Cuentas individuales | Simulada | Selector de usuario sin contraseña; no hay credenciales ni bloqueo de ingreso |
| acceso-datos | Roles y permisos | Simulada | Se aplican en pantalla; «el proveedor no ve datos de clientes» solo oculta la vista |
| acceso-datos | Datos de contacto mínimos | Completa | El formulario solo admite nombre y un medio |
| acceso-datos | Registro de auditoría | Parcial | Registra cambios de usuario activo y acciones administrativas; no existe ingreso fallido |
| acceso-datos | Ambiente de capacitación | Completa | Conjunto de datos ficticios separado del de trabajo |
| respaldo | Respaldo programado | No cubierta | Sin servidor no hay ejecución programada ni aviso de fallo; el respaldo es manual (exportar JSON) |
| respaldo | Recuperación comprobada | Parcial | Importar un JSON y comparar conteos de solicitudes y cambios; el procedimiento se documenta en el README |

La V1 no debe usarse con datos reales de clientes.

### D7. Decisiones de construcción de la V1 (23-nov-2026)

- **Referencia:** formato `SOL-AAAA-NNNNN` (año y consecutivo de cinco dígitos que reinicia cada año). La referencia nunca se reutiliza.
- **Pantallas:** bandeja con búsqueda y filtros; formulario de registro; panel del coordinador (ausencias, solicitudes sin responsable activo y reasignación por lote). El detalle de cada solicitud, con su línea de tiempo, el cambio de estado, la anulación y la reasignación, es un panel lateral de la bandeja, no una pantalla aparte.
- **Datos de prueba:** conjunto pequeño y ficticio en JSON y CSV, sin datos reales.
- **Ingreso y roles:** selector de usuario sin contraseña, con los cuatro roles de la especificación.

## Riesgos y compensaciones

- **Falsa sensación de seguridad en la V1:** los accesos y el respaldo son simulados o manuales (D6). Se declara en el README y no se usan datos reales.
- **Doble digitación durante el piloto** por la convivencia con la hoja: se acepta como costo temporal; se mide con K28 en H3.
- **Resistencia a campos obligatorios** (tensión «control vs. registro excesivo», E04): se limitan a los mínimos del caso (E08).
- **Dependencia del proveedor** para accesos y respaldo (E07): los escenarios de `respaldo` y `acceso-datos` se verifican con él.

## Preguntas abiertas

Ver `proposal.md`.
