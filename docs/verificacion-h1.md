# Verificación de h1-registro-confiable (V1)

Generado por `tests/verificar_h1.py` contra `app/index.html`.
Resultados: **Pasa** = cumple; **Pasa (parcial)** = cumple con el límite indicado; **Simulado** = se aplica en pantalla sin seguridad real; **No cubierto** = la V1 no lo implementa; **Falla** = defecto.

| Capacidad | Escenario | Resultado | Evidencia |
|---|---|---|---|
| solicitudes | Referencia generada al guardar | Pasa | referencia SOL-2026-00026, estado Abierta |
| solicitudes | Registro completo en un paso (estado Abierta) | Pasa | estado Abierta con referencia asignada |
| solicitudes | La referencia no cambia al editar | Pasa | SOL-2026-00026 → SOL-2026-00026 |
| solicitudes | Dos solicitudes nunca comparten referencia | Pasa (parcial) | SOL-2026-00026 y SOL-2026-00027; la unicidad vale dentro de un archivo (sin servidor compartido) |
| solicitudes | Registro posterior al contacto (dos fechas) | Pasa | recepción 2026-11-20T13:00:00.000Z y registro 2026-11-23T15:00:00.000Z guardadas por separado |
| solicitudes | Falta un campo obligatorio | Pasa | Falta el campo obligatorio: asunto. |
| solicitudes | Valor fuera de la lista (canal) | Pasa | Canal no válido. Opciones: mensajería, correo, teléfono. |
| asignacion | Solicitud sin responsable | Pasa | Falta el campo obligatorio: responsable. |
| solicitudes | Catálogo de estados inicial | Pasa | Abierta, En gestión |
| solicitudes | Solicitud sin pedido | Pasa | guardada sin pedido |
| solicitudes | Varias solicitudes del mismo pedido | Pasa | 2 solicitudes asociadas a PED1048 |
| solicitudes | Evitar que el cliente repita su historia (búsqueda por pedido) | Pasa | SOL-2026-00020 · Abierta · Diego Salas; SOL-2026-00012 · En gestión · Ana Ruiz |
| solicitudes | Aviso de posible duplicado | Pasa | Posible duplicado: el cliente ya tiene la solicitud SOL-2026-00012 abierta para ese pedido. |
| solicitudes | Búsqueda por referencia, cliente, responsable, estado y fechas | Pasa | {"ref": 1, "resp": 9, "est": 5, "fechas": 4, "cli": 3} |
| asignacion | Un solo responsable | Pasa | ana.ruiz → luis.mora; el campo admite un único valor |
| asignacion | Reasignación registrada | Pasa | marta.velez · Ana Ruiz → Luis Mora · motivo «Balance de carga» · 2026-11-23T15:00:00.000Z |
| asignacion | Reasignación sin motivo | Pasa | La reasignación exige un motivo. |
| asignacion | Agente ausente: solicitudes «sin responsable activo» | Pasa | 8 solicitudes abiertas listadas |
| asignacion | Reasignación por lote (un registro por solicitud) | Pasa | 8 solicitudes, 8 registros de reasignación |
| asignacion | Agente intenta reasignar una solicitud ajena | Pasa | Solo el coordinador reasigna solicitudes de otro agente; solicítaselo. |
| asignacion | Un agente asume solicitudes sin responsable activo | Pasa | nuevo responsable camila.pardo |
| historial | Cambio de estado de «Abierta» a «En gestión» | Pasa | diego.salas · Abierta → En gestión · 2026-11-23T15:00:00.000Z |
| historial | Cambio sin registro manual | Pasa | el registro se crea en la misma operación; el formulario no pide nada adicional |
| historial | Intento de modificar la historia | Pasa | las funciones de edición y borrado rechazan; el registro está congelado en memoria (el JSON exportado sí se puede editar fuera: parcial) |
| historial | Anulación con motivo | Pasa | sigue existiendo, queda anulada, conserva historia y exige motivo; cuenta en el total registrado |
| historial | Reconstruir lo ocurrido (dos reasignaciones) | Pasa | Diego Salas→Camila Pardo por Marta Vélez / Camila Pardo→Ana Ruiz por Marta Vélez |
| acceso-datos | Alta de usuario (nombre e identificador único) | Pasa | exige persona e identificador único; rechaza identificador repetido y roles sin permiso |
| acceso-datos | Ingreso sin cuenta propia | Simulado | no hay credenciales: se elige una cuenta existente de una lista; no se bloquea el acceso |
| acceso-datos | Agente registra y edita lo propio | Simulado | permite lo propio y rechaza lo ajeno; el control es de pantalla, no de seguridad |
| acceso-datos | Coordinador reasigna | Simulado | permitido para el rol coordinador |
| acceso-datos | Consulta no modifica | Simulado | no edita ni registra y sí ve la bandeja |
| acceso-datos | Campos de contacto permitidos (nombre y un medio) | Pasa | solo nombre y un medio; el formulario no tiene otros campos |
| acceso-datos | Cambio de rol auditado | Pasa | soporte · Luis Mora: agente → coordinador · 2026-11-23T15:00:00.000Z |
| acceso-datos | Inicio de sesión fallido | No cubierto | sin contraseñas no existe el ingreso fallido; solo se audita el ingreso exitoso |
| acceso-datos | Separación de ambientes de capacitación | Pasa | trabajo 0→0; capacitación 25→26 |
| respaldo | Respaldo exitoso (programado) | No cubierto | no hay ejecución programada sin servidor; el respaldo es la exportación manual |
| respaldo | Respaldo fallido (aviso al administrador) | No cubierto | sin respaldo programado no hay fallo que avisar |
| respaldo | Prueba de restauración (conteos y tiempo) | Pasa (parcial) | Respaldo: 25 solicitudes y 34 cambios; actual: 25 y 34; tiempo de lectura 0 ms; la prueba la ejecuta el administrador técnico con un respaldo manual |
| respaldo | No mezclar ambientes al importar | Pasa | El respaldo es del ambiente «trabajo»; no se mezcla con «capacitacion». |
| datos | Importación del directorio de clientes (CSV y JSON) | Pasa | CSV: 1 nuevo, 1 rechazado; JSON: 1 nuevo; total 17 |
| interfaz | Guardar sin asunto muestra el campo faltante | Pasa | Falta el campo obligatorio: asunto. |
| interfaz | Referencia visible tras guardar | Pasa | Solicitud registrada. Referencia para el cliente: SOL-2026-00026 |
| interfaz | Bandeja con filtros y detalle con línea de tiempo | Pasa | 26 filas; detalle de la solicitud recién creada visible |
| acceso-datos | El proveedor no ve datos de clientes (pantalla) | Simulado | pestañas del administrador técnico: Cuentas · Auditoría · Respaldo y datos |
| respaldo | Procedimiento disponible (pasos, responsables, último resultado) | Pasa | sección con pasos, responsables y estado de la última prueba |
| interfaz | Panel del coordinador: ausencia y solicitudes sin responsable activo | Pasa | marca ausente a un agente y lista sus solicitudes |
| interfaz | Reasignación por lote desde la pantalla | Pasa | 5 solicitudes reasignadas, cada una con su propio registro. |
| interfaz | Errores de JavaScript en la consola | Pasa | ninguno |
