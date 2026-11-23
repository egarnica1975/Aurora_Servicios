## Contexto

Parte de H1 archivado. Mantiene la restricción de que el ERP es la referencia y no se modifica (E07) y de que no hay equipo de desarrollo.

## Decisiones

### D1. El vencimiento se calcula, no se escribe
Vencimiento = fecha de recepción + 48 horas corridas (E03). Se calcula desde la fecha de recepción real guardada en H1, nunca desde la fecha de registro, para no premiar el registro tardío.

### D2. «Resuelta» exige respuesta final
La transición a «Resuelta» solo se permite si existe una respuesta final con texto, fecha de comunicación y canal. Esto es la definición del caso (E03) y evita el «listo» sin solución (E09).

### D3. Las pendientes vencidas siempre cuentan
La vista y los datos de H3 incluyen las abiertas vencidas en el denominador (E03, K06, K10).

### D4. ERP en solo lectura (supuesto de mecanismo)
Se lee un listado de clientes y pedidos desde el ERP por el mecanismo que el proveedor ya pueda ofrecer. Si el ERP no está disponible, el registro continúa con la marca «pendiente de validación» para no detener la atención.

### D5. Orden de implementación
`resolucion` antes de `seguimiento` (la vista usa estado y vencimiento); `canales` al final, porque su importación solo se ejecuta cuando lo demás pasa.

## Riesgos

- **Cambio de estados en uso:** al ampliar el catálogo, las solicitudes abiertas de H1 conservan «Abierta» y «En gestión»; no se migran.
- **Datos de la hoja de baja calidad** (texto libre, campos vacíos, E07): la importación rechaza filas incompletas y entrega un informe para corregirlas, en lugar de inventar valores.

## Preguntas abiertas

Ver `proposal.md`.
