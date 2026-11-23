## 1. Estados y resolución (`solicitudes`, `resolucion`)
- [ ] 1.1 Ampliar el catálogo de estados (Esperando consulta, Resuelta, Reabierta).
- [ ] 1.2 Respuesta final obligatoria para resolver (texto, fecha de comunicación, canal).
- [ ] 1.3 Calcular el vencimiento de 48 horas corridas desde la fecha de recepción.
- [ ] 1.4 Reapertura con motivo y registro en el historial.
- [ ] 1.5 Verificar los escenarios de `resolucion` y del requisito modificado.

## 2. Seguimiento (`seguimiento`)
- [ ] 2.1 Vista única de pendientes con filtros y orden por vencimiento.
- [ ] 2.2 Indicación de vencida y próxima a vencer según el umbral definido.
- [ ] 2.3 Vista del coordinador con pendientes del equipo y sin responsable activo.
- [ ] 2.4 Verificar los escenarios de `seguimiento`.

## 3. Consultas a áreas (`consulta-areas`)
- [ ] 3.1 Crear, responder y cerrar consultas asociadas a una solicitud.
- [ ] 3.2 Cambio automático de estado a «Esperando consulta» y regreso a «En gestión».
- [ ] 3.3 Verificar los escenarios de `consulta-areas`.

## 4. Validación contra el ERP (`validacion-erp`)
- [ ] 4.1 Acordar con el proveedor el mecanismo de lectura del ERP.
- [ ] 4.2 Validar cliente y pedido al guardar.
- [ ] 4.3 Marca «pendiente de validación» cuando el ERP no responde.
- [ ] 4.4 Verificar los escenarios de `validacion-erp` y que el ERP no recibe escrituras.

## 5. Canales y retiro de la hoja (`canales`)
- [ ] 5.1 Vincular conversaciones de correo y mensajería a la solicitud.
- [ ] 5.2 Importar las solicitudes abiertas de la hoja A02 con informe de filas rechazadas.
- [ ] 5.3 Corregir con el equipo las filas rechazadas y repetir la importación.
- [ ] 5.4 Poner la hoja A02 en solo lectura y comunicar el corte.
- [ ] 5.5 Verificar los escenarios de `canales`.

## 6. Cierre
- [ ] 6.1 Medir K06 sin excluir pendientes vencidas y K10 durante la operación.
- [ ] 6.2 Revisión con el coordinador y archivo del cambio.
