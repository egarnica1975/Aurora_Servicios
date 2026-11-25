## 1. Respaldo manual (`respaldo-recuperacion`)
- [ ] 1.1 Definir con Aurora la periodicidad, el responsable y el lugar de guardado del volcado, y registrarlos en `docs/plan-v2.md`.
- [ ] 1.2 Documentar el procedimiento de volcado de esquema y datos, con la nota sobre `--data-only` si se usa la CLI de Supabase.
- [ ] 1.3 Asegurar que los archivos de volcado quedan fuera del repositorio (`.gitignore`).
- [ ] 1.4 Verificar los escenarios de respaldo manual.

## 2. Registro
- [ ] 2.1 Operación para registrar el resultado de respaldos y pruebas, de solo inserción para el rol de la aplicación.
- [ ] 2.2 Verificar los escenarios de registro.

## 3. Recuperación
- [ ] 3.1 Documentar la restauración en una base local o en un proyecto gratuito temporal.
- [ ] 3.2 Ejecutar y registrar la prueba de restauración (conteos de solicitudes y cambios).
- [ ] 3.3 Mostrar procedimiento y último resultado a las personas autorizadas.
- [ ] 3.4 Verificar los escenarios de recuperación y de procedimiento.
