# Procedimiento de respaldo y recuperación (V2)

Decisión del 25-nov-2026: **un volcado manual por semana**, hecho por el administrador técnico. Sin respaldo programado ni aviso de fallo (límite L08 abierto). Lo registrado después del último volcado puede perderse.

Estado de las pruebas: los scripts se probaron en un PostgreSQL local 16 (volcado, restauración, conteos, rechazo de base no vacía y de conteos distintos). **Falta probarlos contra Supabase** (ver «Primera vez»).

## Qué necesitas
- Las herramientas de línea de comandos de PostgreSQL (`pg_dump`, `pg_restore`, `psql`) en tu computador, de versión **igual o mayor** que la de tu base en Supabase (Supabase usa PostgreSQL 15 a 17; la versión de tu proyecto está en Project Settings → Infrastructure).
- Un terminal con Bash (Mac, Linux, o Git Bash / WSL en Windows).
- La cadena de conexión de tu proyecto: botón **Connect** → **Session pooler** → reemplaza `[YOUR-PASSWORD]` por la contraseña de la base. **No la guardes en el repositorio ni la compartas.**

## Cada semana: hacer el volcado
```bash
export USUARIO_REGISTRO=soporte           # id del colaborador técnico (opcional)
supabase/respaldo/volcar.sh "<conexión>" volcados
```
Resultado: `volcados/aurora_AAAAMMDD_HHMMSS.dump` (+ un archivo `.conteos`) y una fila en el registro de respaldos (`exitoso` o `fallido`). Guarda el archivo en el lugar acordado `[por definir: lugar y retención]`; **no va al repositorio** (`.gitignore` ya lo excluye).

Ver el historial de respaldos (Editor SQL de Supabase):
```sql
select fecha, tipo, resultado, detalle from respaldo_registro order by id desc;
```

## Antes de la demostración (y la primera vez): prueba de restauración
Necesitas una base **vacía y distinta** a la de trabajo: una base local, o un segundo proyecto gratuito de Supabase (el plan Free permite dos proyectos activos).
```bash
supabase/respaldo/restaurar_prueba.sh volcados/aurora_XXXX.dump "<conexión de la base de prueba>" "<conexión de trabajo>"
```
Debe imprimir **RESTAURACIÓN CORRECTA** con los conteos de solicitudes y cambios iguales a los del origen, y registra el resultado. Si imprime «no coinciden» o «FALLÓ», no se da por comprobada la recuperación.

## Si hay que recuperar de verdad
1. Crear un proyecto nuevo de Supabase (o una base vacía).
2. Restaurar con el mismo script (sin el tercer parámetro si el origen ya no existe).
3. Apuntar la API a la base restaurada cambiando la variable de conexión en Vercel.

## Límites que conviene recordar
- El plan gratuito de Supabase no tiene respaldos automáticos ni descarga de respaldos: este volcado es la única copia.
- Los scripts no detectan que olvidaste hacer el volcado semanal.
- La base restaurada conserva las restricciones de integridad (triggers, historia inmutable y seguridad por filas); la prueba local lo verificó.
