## 1. Historia por trigger (`integridad-datos`)
- [ ] 1.1 Migración con el trigger que registra los cambios de los campos vigilados usando `app.usuario_id` y `app.motivo`.
- [ ] 1.2 Rechazar cambios sin autor y reasignaciones o anulaciones sin motivo.
- [ ] 1.3 Verificar los escenarios de historia generada, reasignación y anulación.

## 2. Inmutabilidad
- [ ] 2.1 Triggers de rechazo de `UPDATE` y `DELETE` sobre `cambio` y `auditoria`.
- [ ] 2.2 Rechazo de `DELETE` sobre `solicitud` y de `UPDATE` sobre `ref`, `fecha_registro`, `registrada_por` y `origen`.
- [ ] 2.3 Crear el rol de la aplicación sin privilegios de modificación sobre `cambio` y `auditoria`.
- [ ] 2.4 Verificar los escenarios de historia inmutable, auditoría y solicitudes sin borrado con ese rol.

## 3. Referencia
- [ ] 3.1 Función `siguiente_referencia` y su uso al insertar solicitudes.
- [ ] 3.2 Prueba de concurrencia con registros simultáneos y de cambio de año.
- [ ] 3.3 Verificar los escenarios de referencia y campos de registro fijos.

## 4. Documentación
- [ ] 4.1 Documentar el alcance de la inmutabilidad (D5) en el README y en el procedimiento de operación.
