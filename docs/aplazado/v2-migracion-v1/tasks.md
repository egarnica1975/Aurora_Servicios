## 1. Decisión previa
- [ ] 1.1 Confirmar con Aurora si el piloto se hará en la V1 o en la V2 (pregunta abierta 1) y registrar la respuesta en `docs/plan-v2.md`.

## 2. Importación (`migracion-v1`)
- [ ] 2.1 Script `api/scripts/migrar_v1.py` con validación de estructura y de ambiente, y carga en una sola transacción.
- [ ] 2.2 Mecanismo para cargar historia existente sin duplicarla (D2), restringido al rol de migración.
- [ ] 2.3 Conservar referencias y fechas y ajustar el consecutivo anual.
- [ ] 2.4 Verificar los escenarios de importación, identidad y consecutivo.

## 3. Verificación
- [ ] 3.1 Informe de conteos origen y destino y rechazo de la carga parcial.
- [ ] 3.2 Idempotencia y rechazo de colisiones con datos de la V2.
- [ ] 3.3 Marca de origen y registro de la migración en la auditoría.
- [ ] 3.4 Cargar colaboradores como pendientes de cuenta.
- [ ] 3.5 Probar la migración con `datos-prueba/capacitacion.json`.
- [ ] 3.6 Verificar los escenarios de verificación, repetición, origen y colaboradores.
