## 1. Preparación del repositorio y del entorno local
- [x] 1.1 Crear la estructura `supabase/` (migraciones, demostración) y documentar cómo levantar una base PostgreSQL local (la CLI de Supabase es opcional).
- [ ] 1.2 Crear el proyecto de Supabase del ambiente de trabajo y guardar sus credenciales fuera del repositorio.

## 2. Esquema (`base-de-datos`)
- [x] 2.1 Migración 0001: tablas, claves, restricciones y catálogos según D3.
- [x] 2.2 Migración 0002: carga inicial de canal y estado.
- [x] 2.3 Pruebas SQL de integridad referencial, contacto mínimo, asunto vacío y catálogos.
- [x] 2.4 Verificar los escenarios de esquema, catálogos y contacto.

## 3. Migraciones y reproducibilidad
- [x] 3.1 Script que reconstruye el esquema desde una base vacía y comprueba el resultado.
- [x] 3.2 Prueba de migración pendiente y registro de migraciones aplicadas.
- [x] 3.3 Verificar los escenarios de migraciones.

## 4. Datos de demostración
- [x] 4.1 Archivos CSV ficticios en `supabase/demo/` y script `supabase/cargar_demo.sh` repetible.
- [x] 4.2 Verificar los escenarios de carga de demostración.
- [ ] 4.3 Verificar los escenarios de persistencia entre sesiones.
