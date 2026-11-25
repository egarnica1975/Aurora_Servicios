-- Datos ficticios de demostración (generado desde demo/*.csv). Repetible: no duplica.

insert into cliente(id,nombre) values
('CLI-001','Colegio Los Cedros'),
('CLI-002','Colegio Nuevo Horizonte'),
('CLI-003','Papelería La Esquina'),
('CLI-004','Ferretería El Tornillo Feliz'),
('CLI-005','Clínica Dental Sonrisas'),
('CLI-006','Consultorio Jurídico Pérez y Asociados'),
('CLI-007','Contadores Asociados del Valle'),
('CLI-008','Restaurante El Fogón'),
('CLI-009','Taller Mecánico Rápido'),
('CLI-010','Colegio Rayuela'),
('CLI-011','Inmobiliaria Casa Segura'),
('CLI-012','Agencia de Viajes Brújula'),
('CLI-013','Gimnasio Fuerza Viva'),
('CLI-014','Droguería Salud Total'),
('CLI-015','Constructora Cimiento')
on conflict do nothing;

insert into colaborador(id,nombre,rol,ausente) values
('ana.ruiz','Ana Ruiz','agente',false),
('luis.mora','Luis Mora','agente',false),
('camila.pardo','Camila Pardo','agente',false),
('diego.salas','Diego Salas','agente',false),
('marta.velez','Marta Vélez','coordinador',false),
('julian.ortiz','Julián Ortiz (Ventas)','consulta',false),
('soporte','Soporte Técnico (proveedor)','administrador técnico',false)
on conflict do nothing;

insert into solicitud(ref,cliente_id,contacto_nombre,contacto_medio,pedido_ref,asunto,canal,estado,responsable_id,fecha_recepcion,fecha_registro,registrada_por,anulada,motivo_anulacion,origen) values
('SOL-2026-00001','CLI-001','Contacto Colegio','300 000 0000','PED1001','Entrega incompleta de resmas tamaño carta','teléfono','En gestión','ana.ruiz','2026-11-02T13:15:00.000Z','2026-11-02T13:21:00.000Z','ana.ruiz',false,null,'demo'),
('SOL-2026-00002','CLI-003','Contacto Papelería','compras@ejemplo.test','PED1002','Factura con valor distinto al cotizado','correo','Abierta','luis.mora','2026-11-02T14:40:00.000Z','2026-11-02T14:46:00.000Z','luis.mora',false,null,'demo'),
('SOL-2026-00003','CLI-005','Contacto Clínica','300 000 0000','PED1007','Cambio de producto por referencia errada','mensajería','En gestión','camila.pardo','2026-11-03T15:05:00.000Z','2026-11-03T15:11:00.000Z','camila.pardo',false,null,'demo'),
('SOL-2026-00004','CLI-002','Contacto Colegio','300 000 0000','PED1010','Consulta por fecha de entrega de cuadernos','teléfono','Abierta','diego.salas','2026-11-03T16:30:00.000Z','2026-11-03T16:36:00.000Z','diego.salas',false,null,'demo'),
('SOL-2026-00005','CLI-008','Contacto Restaurante','compras@ejemplo.test',null,'Solicitud de cotización de tóner','correo','Abierta','ana.ruiz','2026-11-04T13:50:00.000Z','2026-11-04T13:56:00.000Z','ana.ruiz',false,null,'demo'),
('SOL-2026-00006','CLI-004','Contacto Ferretería','300 000 0000','PED1015','Caja de bolígrafos llegó dañada','mensajería','Abierta','ana.ruiz','2026-11-04T19:10:00.000Z','2026-11-04T19:16:00.000Z','luis.mora',false,null,'demo'),
('SOL-2026-00007','CLI-006','Contacto Consultorio','compras@ejemplo.test',null,'Aclarar frecuencia del pedido periódico mensual','correo','Abierta','camila.pardo','2026-11-05T14:00:00.000Z','2026-11-05T14:06:00.000Z','camila.pardo',false,null,'demo'),
('SOL-2026-00008','CLI-009','Contacto Taller','300 000 0000','PED1021','Entrega fuera del horario acordado','teléfono','En gestión','diego.salas','2026-11-05T20:20:00.000Z','2026-11-05T20:26:00.000Z','diego.salas',false,null,'demo'),
('SOL-2026-00009','CLI-010','Contacto Colegio','300 000 0000','PED1025','Faltan tres cajas de marcadores','mensajería','Abierta','ana.ruiz','2026-11-06T13:30:00.000Z','2026-11-06T13:36:00.000Z','ana.ruiz',false,null,'demo'),
('SOL-2026-00010','CLI-007','Contacto Contadores','compras@ejemplo.test','PED1026','Corrección de dirección de entrega','correo','Abierta','luis.mora','2026-11-06T15:45:00.000Z','2026-11-06T15:51:00.000Z','luis.mora',false,null,'demo'),
('SOL-2026-00011','CLI-011','Contacto Inmobiliaria','300 000 0000',null,'Consulta por precio de papel carta','teléfono','Abierta','camila.pardo','2026-11-09T14:15:00.000Z','2026-11-09T14:21:00.000Z','camila.pardo',false,null,'demo'),
('SOL-2026-00012','CLI-001','Contacto Colegio','300 000 0000','PED1048','Reclamo por segunda entrega incompleta','mensajería','En gestión','ana.ruiz','2026-11-09T16:00:00.000Z','2026-11-09T16:06:00.000Z','diego.salas',false,null,'demo'),
('SOL-2026-00013','CLI-012','Contacto Agencia','compras@ejemplo.test',null,'Cambio de contacto para facturación','correo','Abierta','ana.ruiz','2026-11-10T13:20:00.000Z','2026-11-10T13:26:00.000Z','ana.ruiz',false,null,'demo'),
('SOL-2026-00014','CLI-013','Contacto Gimnasio','300 000 0000','PED1033','Producto distinto al pedido','teléfono','Abierta','luis.mora','2026-11-10T18:35:00.000Z','2026-11-10T18:41:00.000Z','luis.mora',false,null,'demo'),
('SOL-2026-00015','CLI-014','Contacto Droguería','compras@ejemplo.test','PED1036','Solicitud de nota crédito','correo','Abierta','camila.pardo','2026-11-11T14:50:00.000Z','2026-11-11T14:56:00.000Z','camila.pardo',false,null,'demo'),
('SOL-2026-00016','CLI-015','Contacto Constructora','300 000 0000','PED1040','Consulta por estado del pedido','mensajería','Abierta','diego.salas','2026-11-11T21:05:00.000Z','2026-11-11T21:11:00.000Z','diego.salas',false,null,'demo'),
('SOL-2026-00017','CLI-003','Contacto Papelería','300 000 0000','PED1042','Pedido repetido por error del cliente','teléfono','Abierta','ana.ruiz','2026-11-12T13:40:00.000Z','2026-11-12T13:46:00.000Z','ana.ruiz',true,'Registrada por duplicidad; el cliente repitió la solicitud','demo'),
('SOL-2026-00018','CLI-002','Contacto Colegio','compras@ejemplo.test','PED1044','Retraso en entrega de formatos','correo','Abierta','luis.mora','2026-11-12T15:25:00.000Z','2026-11-12T15:31:00.000Z','luis.mora',false,null,'demo'),
('SOL-2026-00019','CLI-005','Contacto Clínica','300 000 0000',null,'Aclaración sobre garantía de sillas','mensajería','Abierta','camila.pardo','2026-11-13T14:10:00.000Z','2026-11-13T14:16:00.000Z','camila.pardo',false,null,'demo'),
('SOL-2026-00020','CLI-001','Contacto Colegio','300 000 0000','PED1048','Faltante en la entrega del pedido PED1048','teléfono','Abierta','diego.salas','2026-11-13T19:45:00.000Z','2026-11-13T19:51:00.000Z','diego.salas',false,null,'demo'),
('SOL-2026-00021','CLI-008','Contacto Restaurante','compras@ejemplo.test','PED1050','Cambio de presentación de servilletas','correo','En gestión','ana.ruiz','2026-11-16T13:55:00.000Z','2026-11-16T14:01:00.000Z','ana.ruiz',false,null,'demo'),
('SOL-2026-00022','CLI-004','Contacto Ferretería','300 000 0000','PED1052','Entrega en sede equivocada','mensajería','Abierta','luis.mora','2026-11-16T16:15:00.000Z','2026-11-16T16:21:00.000Z','luis.mora',false,null,'demo'),
('SOL-2026-00023','CLI-009','Contacto Taller','300 000 0000',null,'Consulta por descuento por volumen','teléfono','Abierta','camila.pardo','2026-11-17T14:30:00.000Z','2026-11-17T14:36:00.000Z','camila.pardo',false,null,'demo'),
('SOL-2026-00024','CLI-006','Contacto Consultorio','compras@ejemplo.test','PED1055','Factura duplicada','correo','Abierta','diego.salas','2026-11-17T20:00:00.000Z','2026-11-17T20:06:00.000Z','diego.salas',false,null,'demo'),
('SOL-2026-00025','CLI-007','Contacto Contadores','300 000 0000',null,'Solicitud de visita del asesor comercial','mensajería','Abierta','ana.ruiz','2026-11-18T15:10:00.000Z','2026-11-18T15:16:00.000Z','ana.ruiz',false,null,'demo')
on conflict do nothing;

insert into contador_referencia(anio,ultimo)
select substring(ref from 5 for 4)::int, max(substring(ref from 10)::int) from solicitud where origen='demo' group by 1
on conflict (anio) do update set ultimo = greatest(contador_referencia.ultimo, excluded.ultimo);
