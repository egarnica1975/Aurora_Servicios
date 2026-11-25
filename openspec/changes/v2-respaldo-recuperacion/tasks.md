## 1. Respaldo programado (`respaldo-recuperacion`)
- [ ] 1.1 Confirmar con el proveedor la frecuencia, el punto de recuperación aceptable y la retención, y registrar las respuestas en `docs/plan-v2.md`.
- [ ] 1.2 Confirmar que el plan de Supabase del ambiente de trabajo incluye respaldos automáticos; bloquear el piloto si no.
- [ ] 1.3 Si D2 se aprueba: trabajo programado de `pg_dump` cifrado con almacenamiento fuera de Supabase.
- [ ] 1.4 Verificar los escenarios de respaldo programado.

## 2. Registro y aviso
- [ ] 2.1 Insertar en `respaldo_registro` el resultado de cada respaldo, solo inserción para el rol de la aplicación.
- [ ] 2.2 Aviso al administrador técnico por el canal acordado cuando un respaldo falle.
- [ ] 2.3 Verificar los escenarios de registro y aviso.

## 3. Recuperación
- [ ] 3.1 Documentar el procedimiento de restauración en un proyecto distinto, con pasos y responsables.
- [ ] 3.2 Ejecutar y registrar la prueba de restauración (conteos de solicitudes y cambios, tiempo) antes del piloto.
- [ ] 3.3 Mostrar procedimiento y último resultado a las personas autorizadas.
- [ ] 3.4 Verificar los escenarios de recuperación y de procedimiento.
