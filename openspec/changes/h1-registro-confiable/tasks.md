## 1. Preparación
- [ ] 1.1 Confirmar la opción de realización de APP-05 (D1) con el caso de negocio y registrar la decisión en `design.md`.
- [ ] 1.2 Completar con el coordinador los `[por definir]` de la propuesta (formato de referencia, retención).
- [ ] 1.3 Crear el repositorio, `openspec init` y copiar este cambio.
- [ ] 1.4 Crear el ambiente de capacitación con solo registros ficticios.

## 2. Modelo de datos
- [ ] 2.1 Crear Solicitud, Cambio de solicitud, Colaborador, Canal y Estado según D3.
- [ ] 2.2 Cargar las listas de canal (mensajería, correo, teléfono) y de estado (Abierta, En gestión).

## 3. Solicitudes (`solicitudes`)
- [ ] 3.1 Generar la referencia única e inmutable al guardar.
- [ ] 3.2 Registro en una sola acción con campos obligatorios y listas controladas.
- [ ] 3.3 Guardar fecha de recepción y fecha de registro por separado.
- [ ] 3.4 Búsqueda por referencia, cliente, pedido, responsable, estado y fechas.
- [ ] 3.5 Verificar los escenarios de `solicitudes`.

## 4. Asignación (`asignacion`)
- [ ] 4.1 Responsable único obligatorio.
- [ ] 4.2 Reasignación individual y por lote con motivo obligatorio.
- [ ] 4.3 Marcar ausencia de un colaborador y listar sus solicitudes abiertas al coordinador.
- [ ] 4.4 Verificar los escenarios de `asignacion`.

## 5. Historial (`historial`)
- [ ] 5.1 Registrar cada cambio de campo vigilado con usuario, fecha y valores.
- [ ] 5.2 Impedir editar o borrar cambios y solicitudes.
- [ ] 5.3 Línea de tiempo por solicitud.
- [ ] 5.4 Verificar los escenarios de `historial`.

## 6. Acceso y datos (`acceso-datos`)
- [ ] 6.1 Cuentas individuales con alta por el administrador técnico. (V1: simulado con selector de usuario, sin contraseña.)
- [ ] 6.2 Roles y permisos según la matriz de la especificación.
- [ ] 6.3 Limitar los datos de contacto a nombre y un medio.
- [ ] 6.4 Registro de auditoría de inicios de sesión y acciones administrativas. (V1: parcial; sin ingreso fallido.)
- [ ] 6.5 Verificar los escenarios de `acceso-datos`.

## 7. Respaldo (`respaldo`)
- [ ] 7.1 Configurar el respaldo programado con el proveedor y su registro de resultado. (V1: no cubierta; respaldo manual por exportación JSON.)
- [ ] 7.2 Documentar el procedimiento de recuperación.
- [ ] 7.3 Ejecutar y registrar una prueba de recuperación antes de iniciar el piloto. (V1: importar un JSON y comparar conteos.)
- [ ] 7.4 Verificar los escenarios de `respaldo`.

## 8. Piloto
- [ ] 8.1 Sesión corta de capacitación para los 4 agentes y el coordinador.
- [ ] 8.2 Operar el piloto de 6 semanas en paralelo con la hoja A02.
- [ ] 8.3 Medir cobertura (K01) y responsable (K04) en el piloto, sin excluir casos, y verificarlas contra los canales.
- [ ] 8.4 Revisión con el coordinador: ajustar y archivar el cambio.

## 9. Arranque de la V1
- [ ] 9.1 Crear `.gitignore`.
- [ ] 9.2 Crear `README.md` con instrucciones de configuración e inicio: abrir `app/index.html`, cargar los datos de prueba, exportar e importar JSON, probar la recuperación y los límites de la V1.
- [ ] 9.3 Crear los datos de prueba ficticios en JSON y CSV: unos 15 clientes, 6 colaboradores (4 agentes, 1 coordinador, 1 de consulta), 1 administrador técnico y unas 25 solicitudes.
- [ ] 9.4 Implementar `app/index.html` con bandeja, formulario de registro y panel del coordinador; el detalle con línea de tiempo es un panel de la bandeja.
