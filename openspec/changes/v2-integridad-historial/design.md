## Contexto

La V1 cumple estos requisitos dentro de la aplicación (tabla D6 de `h1-registro-confiable`). La V2 los traslada a la base de datos para que valgan aunque se escriba directamente en ella. El caso exige que la gerencia no acepte mejoras aparentes (E03), por eso la historia no puede ser editable.

## Objetivos / No objetivos

- **Objetivos:** que el motor genere la historia, rechace su modificación y garantice referencias únicas bajo concurrencia.
- **No objetivos:** proteger los datos de un superusuario del proveedor de nube; resolver la autenticación (`v2-api-backend`).

## Decisiones

### D1. La historia la genera un trigger (supuesto de diseño)

Un trigger `AFTER UPDATE` sobre `solicitud` inserta una fila en `cambio` por cada campo vigilado que cambió (cliente, pedido, asunto, canal, estado, responsable, anulación). Quien escribe identifica al usuario con `set_config('app.usuario_id', ..., true)` y, si corresponde, el motivo con `app.motivo`, dentro de la misma transacción. Si falta `app.usuario_id` el trigger aborta: ningún cambio queda sin autor. Se prefiere el trigger a generar la historia en la API porque funciona igual si alguien usa SQL directo.

### D2. Inmutabilidad con trigger y permisos

`cambio` y `auditoria` llevan triggers `BEFORE UPDATE OR DELETE` que lanzan una excepción, y el rol de la aplicación no recibe privilegios de `UPDATE` ni `DELETE` sobre ellas. `solicitud` rechaza `DELETE` y rechaza `UPDATE` sobre `ref`, `fecha_registro`, `registrada_por` y `origen`. La anulación es un `UPDATE` de `anulada` y `motivo_anulacion` que genera su propio cambio.

### D3. Referencia por secuencia anual transaccional

```sql
create function siguiente_referencia(p_anio int) returns text language plpgsql as $$
declare n int;
begin
  insert into contador_referencia(anio, ultimo) values (p_anio, 1)
  on conflict (anio) do update set ultimo = contador_referencia.ultimo + 1
  returning ultimo into n;
  return 'SOL-' || p_anio || '-' || lpad(n::text, 5, '0');
end $$;
```

La fila del contador se bloquea durante la transacción, de modo que dos registros simultáneos reciben referencias distintas. Si la transacción falla, el contador también se revierte y no quedan huecos. A 600 solicitudes al mes (E01) el bloqueo no es una limitación.

### D4. Responsable y motivo

`responsable_id` es obligatorio y clave foránea (ya en `v2-modelo-de-datos`). Un trigger exige `app.motivo` no vacío cuando cambia `responsable_id` o `anulada`.

### D5. Alcance de la inmutabilidad (declaración honesta)

Las garantías valen frente al rol de la aplicación y a cualquier rol sin privilegios de superusuario. Quien administre la base con credenciales de propietario puede deshabilitar triggers. Para cerrar esa brecha existe el hash encadenado (pregunta abierta 1).

## Riesgos y compensaciones

- **Contexto de usuario por transacción:** si la API olvida fijar `app.usuario_id`, el cambio aborta. Es una falla visible y deseada.
- **Rendimiento:** un trigger por campo vigilado añade filas; con el volumen del caso no es un problema.
- **Pruebas:** deben ejecutarse con un rol sin privilegios, no como propietario, o fallarían por la razón equivocada.

## Preguntas abiertas

Ver `proposal.md`.
