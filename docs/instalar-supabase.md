# Instalar la base de datos en Supabase (sin instalar programas)

Tiempo: unos 10 minutos. Solo necesitas el navegador y los dos archivos SQL de `supabase/`.

## Antes de empezar
- Tu proyecto de Supabase debe estar creado y activo (plan Free).
- **No compartas la contraseña de la base de datos ni las claves (API keys) en el chat ni en el repositorio.**
- Haz esto **una sola vez**. Si el paso 2 se ejecuta dos veces, la segunda falla porque las tablas ya existen (no daña nada).

## Paso 1. Abrir el Editor SQL
1. Entra a supabase.com y abre tu proyecto.
2. Menú izquierdo: **SQL Editor**.
3. Botón **New query**.

## Paso 2. Instalar el esquema
1. Abre `supabase/instalar_supabase.sql` con el Bloc de notas (o cualquier editor).
2. Selecciona todo (Ctrl+A), copia (Ctrl+C).
3. En el Editor SQL pega (Ctrl+V) y pulsa **Run** (o Ctrl+Enter).
4. Si Supabase muestra un aviso de "operación potencialmente destructiva" (por los `revoke`), confirma con **Run this query**.
5. Debe terminar con **Success. No rows returned**.

## Paso 3. Verificar la instalación
Abre otra **New query**, pega y ejecuta:

```sql
select (select count(*) from canal) as canales,
       (select count(*) from estado) as estados,
       (select count(*) from supabase_migrations.schema_migrations) as migraciones;
```
Resultado esperado: `canales 3`, `estados 2`, `migraciones 4`.

Verificación de seguridad (todas las filas deben decir `true`, y la segunda consulta `false`):

```sql
select tablename, rowsecurity from pg_tables where schemaname = 'public' order by 1;
select has_table_privilege('anon', 'public.solicitud', 'select') as anon_puede_leer;
```

## Paso 4. Cargar los datos de demostración (cuando vayas a presentar)
1. **New query**, pega el contenido de `supabase/demo/demo_supabase.sql`, **Run**.
2. Verifica:
```sql
select (select count(*) from solicitud) as solicitudes,
       (select count(*) from cliente) as clientes,
       (select count(*) from colaborador) as colaboradores,
       (select count(*) from cambio) as cambios;
```
Esperado: `25 / 15 / 7 / 25`.
3. Puedes ejecutarlo más de una vez: no duplica.

## Si algo falla
- Copia el texto completo del mensaje de error (sin contraseñas) y compártelo conmigo.
- Si el proyecto aparece **Paused**, pulsa **Restore project** y espera unos minutos.

## Qué sigue
La conexión de la API (cadena de conexión con el rol `aurora_app`) se configurará como variable secreta en Vercel; no se pega en ningún archivo.
