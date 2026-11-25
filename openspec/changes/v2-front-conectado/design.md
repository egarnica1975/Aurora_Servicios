## Contexto

La V1 es un solo archivo con módulo `Negocio` y capa de pantalla. En la V2 la autoridad de las reglas pasa al servidor; la interfaz solo presenta y recoge datos, y puede validar de forma anticipada para dar mensajes rápidos.

## Objetivos / No objetivos

- **Objetivos:** misma funcionalidad que la V1 sobre la API, sin lógica de autoridad en el cliente.
- **No objetivos:** rediseño visual, aplicación móvil nativa, modo sin conexión.

## Decisiones

### D1. HTML, CSS y JavaScript sin compilación (supuesto)

Se divide el archivo único en `web/index.html`, `web/estilos.css` y módulos de JavaScript, servidos como archivos estáticos. No se usa Node.js para construir. Si más adelante se necesita (por ejemplo para pruebas de interfaz), se registra en `docs/plan-v2.md`.

### D2. Cliente de la API aislado

Un módulo `api.js` concentra las llamadas, el token de sesión y el manejo de errores; el resto de la interfaz no conoce los detalles HTTP.

### D3. Validación anticipada no autoritativa

La interfaz puede avisar de campos faltantes, pero siempre muestra el mensaje que devuelve la API y no da por válida una operación hasta que el servidor responde.

### D4. Token de sesión

El token se guarda en memoria de la pestaña y no en `localStorage`, para reducir el riesgo de robo; cerrar la pestaña cierra la sesión. Se evalúa al integrar con la API.

### D5. Borrador ante error de red

La interfaz conserva lo digitado en el formulario si la petición falla (comportamiento ya presente en la V1).

## Riesgos y compensaciones

- **Dependencia de la conexión:** sin red no se puede registrar; se acepta en la V2 y se informa con un mensaje claro.
- **Datos sensibles en el navegador:** no se guardan en almacenamiento local (D4).

## Preguntas abiertas

Ver `proposal.md`.
