## Contexto

Stack decidido por el usuario: Python y FastAPI sobre PostgreSQL en Supabase. Las reglas de H1 están descritas en las especificaciones `registro-solicitudes`, `historial-reasignacion`, `acceso-datos` y `respaldo` del cambio `h1-registro-confiable`, y su implementación de referencia es el módulo `Negocio` de `app/index.html`.

## Objetivos / No objetivos

- **Objetivos:** reglas y permisos en el servidor, errores claros, concurrencia segura, pruebas de contrato.
- **No objetivos:** funcionalidades de H2 y H3, notificaciones al cliente, integración con sistemas externos.

## Decisiones

### D1. Estructura del código (supuesto)

`api/` con tres capas: `rutas` (FastAPI), `dominio` (reglas puras, sin acceso a la pantalla ni a HTTP) y `datos` (consultas). Cumple la regla 5 del proyecto: las reglas van separadas de la presentación.

### D2. Acceso a datos (supuesto)

Conexión directa a PostgreSQL con psycopg y consultas parametrizadas; la API fija `app.usuario_id` y `app.motivo` al inicio de cada transacción para que los triggers generen la historia. El uso de un ORM queda como alternativa.

### D3. Autenticación (supuesto)

Supabase Auth gestiona cuentas y contraseñas. La interfaz inicia sesión llamando a la API, que a su vez llama a Supabase Auth, registra el intento (éxito o fallo) en `auditoria` y devuelve el token. La API valida el JWT en cada petición y busca al colaborador por `auth_user_id`. Así el fallo queda registrado sin depender de lo que Supabase exponga.

### D4. Autorización en dos capas (supuesto)

1) La API revisa el rol en cada ruta. 2) La base de datos restringe con un rol de conexión por tipo de usuario o con RLS; el administrador técnico no puede leer el contenido de las solicitudes. El detalle exacto se decide en la prueba de concepto.

### D5. Concurrencia

Operaciones de cambio con control de versión (`version` en `solicitud`, comparación al actualizar) para evitar que una edición simultánea pise a otra; la referencia se asigna con `siguiente_referencia` dentro de la misma transacción.

### D6. Errores

Respuestas con código HTTP y mensaje en español que dice qué falló y cómo corregirlo (E04). Sin trazas internas.

### D7. Pruebas

pytest contra PostgreSQL local (Supabase CLI) con una prueba por escenario de H1 y de los cambios V2, sin datos reales.

## Riesgos y compensaciones

- **Autorización solo en la API:** si la base de datos acepta cualquier conexión de la API, un error de código expone datos; por eso la segunda capa (D4).
- **Intermediar el ingreso:** añade un punto de falla; si la API cae, nadie ingresa. Se acepta por el valor de la auditoría.
- **Latencia del servidor sin estado:** a verificar en `v2-despliegue`.

## Preguntas abiertas

Ver `proposal.md`.
