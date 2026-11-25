## 1. Base de la API
- [ ] 1.1 Estructura `api/` con capas rutas, dominio y datos, configuración por ambiente y conexión a PostgreSQL.
- [ ] 1.2 Prueba de concepto de ingreso mediado: Supabase Auth, registro del intento y validación del JWT (D3).
- [ ] 1.3 Prueba de concepto de la segunda capa de autorización (D4) y decisión registrada en `docs/plan-v2.md`.

## 2. Reglas y operaciones (`api-solicitudes`)
- [ ] 2.1 Funciones de dominio: validación, referencia, cambio de estado, reasignación, anulación, duplicados.
- [ ] 2.2 Rutas de solicitudes, clientes y consulta de historia.
- [ ] 2.3 Mensajes de error claros en español.
- [ ] 2.4 Control de versión para cambios concurrentes.
- [ ] 2.5 Verificar los escenarios de api-solicitudes.

## 3. Cuentas y roles (`autenticacion`)
- [ ] 3.1 Ingreso, cierre de sesión y expiración.
- [ ] 3.2 Roles aplicados en cada ruta y restricción del administrador técnico.
- [ ] 3.3 Auditoría de ingreso y de fallo.
- [ ] 3.4 Alta, asignación y desactivación de usuarios.
- [ ] 3.5 Verificar los escenarios de autenticación.

## 4. Pruebas de contrato
- [ ] 4.1 Una prueba por escenario de H1 cubierto, contra PostgreSQL local con datos ficticios.
- [ ] 4.2 Integrar las pruebas en la integración continua (ver `v2-despliegue`).
- [ ] 4.3 Verificar los escenarios de pruebas de contrato.
