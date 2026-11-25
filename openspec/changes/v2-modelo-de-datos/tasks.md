## 1. Preparación del repositorio y del entorno local
- [ ] 1.1 Crear la estructura `supabase/` (migraciones, semillas) y documentar cómo levantar la base local con la CLI de Supabase.
- [ ] 1.2 Crear el proyecto de capacitación en Supabase y guardar sus credenciales fuera del repositorio.
- [ ] 1.3 Decidir D-06 (uno o dos proyectos) con el costo verificado y registrar la decisión en `docs/plan-v2.md`.

## 2. Esquema (`base-de-datos`)
- [ ] 2.1 Migración 0001: tablas, claves, restricciones y catálogos según D3.
- [ ] 2.2 Migración 0002: carga inicial de canal y estado.
- [ ] 2.3 Pruebas SQL de integridad referencial, contacto mínimo, asunto vacío y catálogos.
- [ ] 2.4 Verificar los escenarios de esquema, catálogos y contacto.

## 3. Migraciones y reproducibilidad
- [ ] 3.1 Script que reconstruye el esquema desde una base vacía y comprueba el resultado.
- [ ] 3.2 Prueba de migración pendiente y registro de migraciones aplicadas.
- [ ] 3.3 Verificar los escenarios de migraciones.

## 4. Ambientes y datos de prueba
- [ ] 4.1 Crear el proyecto de trabajo (si D-06 lo confirma) con credenciales distintas.
- [ ] 4.2 Procedimiento de carga de `datos-prueba/` que se niega sobre el ambiente de trabajo.
- [ ] 4.3 Verificar los escenarios de ambientes y carga.
- [ ] 4.4 Verificar los escenarios de persistencia entre sesiones.
