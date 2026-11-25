## Why

La interfaz de la V1 guarda y valida en el navegador. Para la V2 debe hablar con la API, de modo que los datos persistan solos, varias personas trabajen a la vez y la autoridad de las reglas esté en el servidor. H1 exige una interfaz sencilla, con mensajes claros y capacitación posible (E04, E08).

Este cambio conecta la interfaz existente a la API manteniendo la funcionalidad y la simplicidad de la V1. Corresponde a OP-01, OP-05 y OP-11 del Horizonte 1.

## What Changes

- Interfaz web que usa la API en lugar de datos en memoria (nuevo).
- Ingreso con cuenta y sesión (reemplaza el selector de usuario) (nuevo).
- Persistencia visible: la persona ve que sus datos quedaron guardados (nuevo).
- Conservación del borrador ante errores de red (nuevo).
- Importación de clientes desde la interfaz hacia la API (nuevo).

## Capabilities

### New Capabilities
- `interfaz-web`: interfaz conectada a la API con la funcionalidad de la V1.

### Modified Capabilities
Ninguna.

## Impact

- Depende de `v2-api-backend`.
- La V1 (`app/index.html`) se conserva como referencia y como ambiente de capacitación: la capacitación no continúa en la V2 (decisión del 25-nov-2026).
- El código del front se separa en archivos (`web/`) para poder probarse y desplegarse.

## Preguntas abiertas

1. Navegadores y dispositivos que deben funcionar: `[por definir]`.
2. Rol de Node.js: ninguno en la interfaz mientras sea HTML, CSS y JavaScript sin compilación; si se añade herramienta de construcción, se decide aquí (D1).
3. Idioma y accesibilidad mínima: se mantiene español; nivel de accesibilidad `[por definir]`.
