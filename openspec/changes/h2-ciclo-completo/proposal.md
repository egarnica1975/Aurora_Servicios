## Why

Con el registro confiable de H1, falta cerrar el ciclo: una solicitud solo está resuelta cuando hay una respuesta final comunicada (E03), pero hoy «listo» no demuestra solución (E09), el seguimiento no es confiable (E06) y las consultas a ventas y logística no dejan rastro. Además, la hoja A02 sigue siendo un sistema de registro paralelo y los datos de cliente y pedido no se validan contra el ERP (E07, E08). Este cambio corresponde al **Horizonte 2** y a las oportunidades OP-06, OP-07, OP-08, OP-10 y OP-13.

## What Changes

- Estados «Esperando consulta», «Resuelta» y «Reabierta», con respuesta final comunicada obligatoria para resolver (modifica `solicitudes`).
- Vencimiento de 48 horas corridas, sin excluir pendientes vencidas.
- Reapertura con motivo.
- Vista única de pendientes y vencimientos para agentes y coordinador.
- Consulta estructurada a ventas y logística asociada a la referencia.
- Validación de cliente y pedido contra el ERP, sin modificarlo.
- Vinculación de conversaciones de correo y mensajería a la referencia.
- Importación de las solicitudes abiertas de la hoja A02 y retiro de la hoja como sistema de registro.

## Capabilities

### New Capabilities
- `resolucion`: respuesta final comunicada, vencimiento de 48 horas y reapertura.
- `seguimiento`: vista única de pendientes y vencimientos.
- `consulta-areas`: consultas a ventas y logística.
- `validacion-erp`: validación de cliente y pedido contra el ERP en solo lectura.
- `canales`: conversaciones vinculadas e importación desde la hoja.

### Modified Capabilities
- `solicitudes`: amplía el catálogo de estados.

## Impact

- Depende de H1 archivado (`solicitudes`, `asignacion`, `historial`).
- Datos: añade Respuesta (ENT-07) y relaciones con Cliente y Pedido validados (ENT-01, ENT-03).
- Integración: lectura del ERP sin escribir en él; el mecanismo (archivo exportado o consulta) es `[por definir]` con el proveedor.
- Proceso: la hoja A02 pasa a solo lectura tras la importación.

## Preguntas abiertas

1. Regla de vencimiento tras una reapertura (¿se reinicia el plazo o continúa el original?): `[por definir]` con el coordinador.
2. Plazo máximo para reabrir una solicitud resuelta: `[por definir]`.
3. Umbral de «próxima a vencer»: `[por definir]`.
4. Aviso de vencimientos (¿solo visual o también resumen diario? ¿por qué canal?): `[por definir]`.
5. Mecanismo de lectura del ERP y frecuencia de actualización: `[por definir]` con el proveedor.
6. ¿Se informa un plazo al cliente además de las 48 horas? El caso lo menciona como indicador (K07) sin definirlo.
