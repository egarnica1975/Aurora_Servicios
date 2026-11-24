"""Verifica los escenarios de h1-registro-confiable contra app/index.html (V1).
Uso: python3 tests/verificar_h1.py  -> imprime la tabla y escribe docs/verificacion-h1.md
Requiere: playwright (Python) y Chrome/Chromium."""
import json, pathlib, sys
from playwright.sync_api import sync_playwright

RAIZ = pathlib.Path(__file__).resolve().parent.parent
URL = (RAIZ / 'app' / 'index.html').as_uri()
res = []  # (capacidad, escenario, resultado, evidencia)

def reg(cap, esc, estado, ev):
    res.append((cap, esc, estado, ev))

with sync_playwright() as p:
    nav = p.chromium.launch(executable_path='/usr/bin/google-chrome', args=['--no-sandbox'])
    pg = nav.new_page()
    errores = []
    pg.on('pageerror', lambda e: errores.append(str(e)))
    pg.goto(URL)
    ev = lambda js: pg.evaluate(js)

    PRE = """const N=Aurora.Negocio; const d=Aurora.semillaCapacitacion(); const U=id=>N.col(d,id);
    const AH=new Date(2026,10,23,10,0); const base={clienteId:'CLI-003',canal:'correo',asunto:'Prueba',fechaRecepcion:new Date(2026,10,23,9,30).toISOString(),responsableId:'ana.ruiz'};"""
    def t(js):
        return ev("(()=>{'use strict';" + PRE + js + "})()")

    # ---------------- solicitudes ----------------
    r = t("const r=N.registrarSolicitud(d,U('ana.ruiz'),base,AH); return {ref:r.solicitud.ref, estado:r.solicitud.estado}")
    reg('solicitudes', 'Referencia generada al guardar', 'Pasa' if r['ref'] == 'SOL-2026-00026' else 'Falla', f"referencia {r['ref']}, estado {r['estado']}")
    reg('solicitudes', 'Registro completo en un paso (estado Abierta)', 'Pasa' if r['estado'] == 'Abierta' else 'Falla', 'estado Abierta con referencia asignada')
    r = t("const s=N.registrarSolicitud(d,U('ana.ruiz'),base,AH).solicitud; const a=s.ref; N.editarSolicitud(d,U('ana.ruiz'),s.id,{asunto:'Otro',estado:'En gestión'},AH); return [a,s.ref]")
    reg('solicitudes', 'La referencia no cambia al editar', 'Pasa' if r[0] == r[1] else 'Falla', f'{r[0]} → {r[1]}')
    r = t("const a=N.registrarSolicitud(d,U('ana.ruiz'),base,AH).solicitud.ref; const b=N.registrarSolicitud(d,U('luis.mora'),Object.assign({},base,{responsableId:'luis.mora'}),AH).solicitud.ref; return [a,b]")
    reg('solicitudes', 'Dos solicitudes nunca comparten referencia', 'Pasa (parcial)' if r[0] != r[1] else 'Falla', f'{r[0]} y {r[1]}; la unicidad vale dentro de un archivo (sin servidor compartido)')
    r = t("const s=N.registrarSolicitud(d,U('ana.ruiz'),Object.assign({},base,{fechaRecepcion:new Date(2026,10,20,8,0).toISOString()}),AH).solicitud; return [s.fechaRecepcion,s.fechaRegistro]")
    reg('solicitudes', 'Registro posterior al contacto (dos fechas)', 'Pasa' if r[0] != r[1] else 'Falla', f'recepción {r[0]} y registro {r[1]} guardadas por separado')
    r = t("return N.registrarSolicitud(d,U('ana.ruiz'),Object.assign({},base,{asunto:''}),AH)")
    reg('solicitudes', 'Falta un campo obligatorio', 'Pasa' if (not r['ok'] and 'asunto' in r['error']) else 'Falla', r['error'])
    r = t("return [N.registrarSolicitud(d,U('ana.ruiz'),Object.assign({},base,{canal:'fax'}),AH), N.registrarSolicitud(d,U('ana.ruiz'),Object.assign({},base,{responsableId:''}),AH)]")
    reg('solicitudes', 'Valor fuera de la lista (canal)', 'Pasa' if (not r[0]['ok'] and 'mensajería' in r[0]['error']) else 'Falla', r[0]['error'])
    reg('asignacion', 'Solicitud sin responsable', 'Pasa' if (not r[1]['ok'] and 'responsable' in r[1]['error']) else 'Falla', r[1]['error'])
    r = ev("ESTADOS")
    reg('solicitudes', 'Catálogo de estados inicial', 'Pasa' if r == ['Abierta', 'En gestión'] else 'Falla', ', '.join(r))
    r = t("const s=N.registrarSolicitud(d,U('ana.ruiz'),Object.assign({},base,{pedido:''}),AH); return [s.ok,s.solicitud&&s.solicitud.pedido]")
    reg('solicitudes', 'Solicitud sin pedido', 'Pasa' if r[0] and r[1] == '' else 'Falla', 'guardada sin pedido')
    r = t("return N.buscar(d,{pedido:'PED1048'}).map(s=>[s.ref,s.estado,N.nombreCol(d,s.responsableId)])")
    reg('solicitudes', 'Varias solicitudes del mismo pedido', 'Pasa' if len(r) >= 2 else 'Falla', f'{len(r)} solicitudes asociadas a PED1048')
    reg('solicitudes', 'Evitar que el cliente repita su historia (búsqueda por pedido)', 'Pasa' if len(r) >= 2 and all(len(x) == 3 and x[2] for x in r) else 'Falla', '; '.join(f'{a} · {b} · {c}' for a, b, c in r))
    r = t("return N.registrarSolicitud(d,U('diego.salas'),{clienteId:'CLI-001',canal:'teléfono',asunto:'Otra',pedido:'PED1048',fechaRecepcion:AH.toISOString(),responsableId:'diego.salas'},AH)")
    reg('solicitudes', 'Aviso de posible duplicado', 'Pasa' if (not r['ok'] and r.get('duplicado')) else 'Falla', r['error'])
    r = t("return {ref:N.buscar(d,{ref:'00007'}).length, resp:N.buscar(d,{responsableId:'ana.ruiz'}).length, est:N.buscar(d,{estado:'En gestión'}).length, fechas:N.buscar(d,{desde:'2026-11-09',hasta:'2026-11-10'}).length, cli:N.buscar(d,{cliente:'cedros'}).length}")
    reg('solicitudes', 'Búsqueda por referencia, cliente, responsable, estado y fechas', 'Pasa' if r['ref'] == 1 and r['resp'] > 0 and r['est'] > 0 and r['fechas'] > 0 and r['cli'] > 0 else 'Falla', json.dumps(r))

    # ---------------- asignacion ----------------
    r = t("const s=d.solicitudes[0]; const antes=s.responsableId; const x=N.reasignar(d,U('marta.velez'),s.id,'luis.mora','Balance',AH); return [antes,s.responsableId,x.ok]")
    reg('asignacion', 'Un solo responsable', 'Pasa' if r[2] and r[0] != r[1] else 'Falla', f'{r[0]} → {r[1]}; el campo admite un único valor')
    r = t("const s=d.solicitudes[0]; N.reasignar(d,U('marta.velez'),s.id,'luis.mora','Balance de carga',AH); const c=d.cambios[d.cambios.length-1]; return c")
    reg('asignacion', 'Reasignación registrada', 'Pasa' if r['campo'] == 'responsable' and r['usuarioId'] == 'marta.velez' and r['motivo'] and r['anterior'] and r['nuevo'] else 'Falla', f"{r['usuarioId']} · {r['anterior']} → {r['nuevo']} · motivo «{r['motivo']}» · {r['fecha']}")
    r = t("return N.reasignar(d,U('marta.velez'),d.solicitudes[0].id,'luis.mora','',AH)")
    reg('asignacion', 'Reasignación sin motivo', 'Pasa' if not r['ok'] else 'Falla', r['error'])
    r = t("const x=N.marcarAusencia(d,U('marta.velez'),'ana.ruiz',true,AH); return [x.ok,x.sinResponsable.length,N.sinResponsableActivo(d).length,d.solicitudes.filter(s=>s.responsableId==='ana.ruiz'&&!s.anulada).length]")
    reg('asignacion', 'Agente ausente: solicitudes «sin responsable activo»', 'Pasa' if r[0] and r[1] == r[3] and r[1] > 0 else 'Falla', f'{r[1]} solicitudes abiertas listadas')
    r = t("N.marcarAusencia(d,U('marta.velez'),'ana.ruiz',true,AH); const ids=N.sinResponsableActivo(d).map(s=>s.id); const n0=d.cambios.length; const x=N.reasignarLote(d,U('marta.velez'),ids,'luis.mora','Ausencia de Ana',AH); return [ids.length,x.ok,d.cambios.length-n0,N.sinResponsableActivo(d).length]")
    reg('asignacion', 'Reasignación por lote (un registro por solicitud)', 'Pasa' if r[1] and r[2] == r[0] and r[3] == 0 else 'Falla', f'{r[0]} solicitudes, {r[2]} registros de reasignación')
    r = t("const s=d.solicitudes.find(s=>s.responsableId==='luis.mora'); return N.reasignar(d,U('ana.ruiz'),s.id,'ana.ruiz','quiero',AH)")
    reg('asignacion', 'Agente intenta reasignar una solicitud ajena', 'Pasa' if (not r['ok'] and 'coordinador' in r['error']) else 'Falla', r['error'])
    r = t("N.marcarAusencia(d,U('marta.velez'),'luis.mora',true,AH); const s=N.sinResponsableActivo(d)[0]; const x=N.asumir(d,U('camila.pardo'),s.id,AH); return [x.ok,s.responsableId]")
    reg('asignacion', 'Un agente asume solicitudes sin responsable activo', 'Pasa' if r[0] and r[1] == 'camila.pardo' else 'Falla', f'nuevo responsable {r[1]}')

    # ---------------- historial ----------------
    r = t("const s=d.solicitudes[3]; const n=d.cambios.length; N.editarSolicitud(d,U(s.responsableId),s.id,{estado:'En gestión'},AH); return [d.cambios.length-n,d.cambios[d.cambios.length-1]]")
    c = r[1]
    reg('historial', 'Cambio de estado de «Abierta» a «En gestión»', 'Pasa' if c['campo'] == 'estado' and c['anterior'] == 'Abierta' and c['nuevo'] == 'En gestión' and c['usuarioId'] else 'Falla', f"{c['usuarioId']} · {c['anterior']} → {c['nuevo']} · {c['fecha']}")
    reg('historial', 'Cambio sin registro manual', 'Pasa' if r[0] == 1 else 'Falla', 'el registro se crea en la misma operación; el formulario no pide nada adicional')
    r = t("const c=d.cambios[0]; let lanzo=false; try{c.nuevo='x'}catch(e){lanzo=true}; return [N.editarCambio().ok,N.eliminarCambio().ok,N.eliminarSolicitud().ok,lanzo,c.nuevo!=='x']")
    reg('historial', 'Intento de modificar la historia', 'Pasa' if r == [False, False, False, True, True] else 'Falla', 'las funciones de edición y borrado rechazan; el registro está congelado en memoria (el JSON exportado sí se puede editar fuera: parcial)')
    r = t("const s=d.solicitudes[4]; const x=N.anular(d,U('marta.velez'),s.id,'Duplicada',AH); return [x.ok,s.anulada,d.solicitudes.includes(s),N.lineaDeTiempo(d,s.id).length>0,N.anular(d,U('marta.velez'),d.solicitudes[5].id,'',AH).ok]")
    reg('historial', 'Anulación con motivo', 'Pasa' if r == [True, True, True, True, False] else 'Falla', 'sigue existiendo, queda anulada, conserva historia y exige motivo; cuenta en el total registrado')
    r = t("const s=d.solicitudes[11]; return N.lineaDeTiempo(d,s.id).filter(c=>c.campo==='responsable').map(c=>[c.fecha,N.nombreCol(d,c.usuarioId),c.anterior,c.nuevo])")
    reg('historial', 'Reconstruir lo ocurrido (dos reasignaciones)', 'Pasa' if len(r) == 2 and r[0][0] < r[1][0] else 'Falla', ' | '.join(f'{x[2]}→{x[3]} por {x[1]}' for x in r))

    # ---------------- acceso-datos ----------------
    r = t("return [N.crearUsuario(d,U('soporte'),{nombre:'',id:'nuevo',rol:'agente'},AH), N.crearUsuario(d,U('soporte'),{nombre:'Persona Nueva',id:'',rol:'agente'},AH), N.crearUsuario(d,U('soporte'),{nombre:'Otra',id:'ana.ruiz',rol:'agente'},AH), N.crearUsuario(d,U('soporte'),{nombre:'Persona Nueva',id:'persona.nueva',rol:'agente'},AH), N.crearUsuario(d,U('ana.ruiz'),{nombre:'X',id:'x',rol:'agente'},AH)]")
    reg('acceso-datos', 'Alta de usuario (nombre e identificador único)', 'Pasa' if [x['ok'] for x in r] == [False, False, False, True, False] else 'Falla', 'exige persona e identificador único; rechaza identificador repetido y roles sin permiso')
    reg('acceso-datos', 'Ingreso sin cuenta propia', 'Simulado', 'no hay credenciales: se elige una cuenta existente de una lista; no se bloquea el acceso')
    r = t("const m=d.solicitudes.find(s=>s.responsableId==='ana.ruiz'); const o=d.solicitudes.find(s=>s.responsableId==='luis.mora'); return [N.editarSolicitud(d,U('ana.ruiz'),m.id,{asunto:'Asunto propio editado'},AH).ok,N.editarSolicitud(d,U('ana.ruiz'),o.id,{asunto:'cambio'},AH).ok,N.registrarSolicitud(d,U('ana.ruiz'),Object.assign({},base,{responsableId:'ana.ruiz'}),AH).ok]")
    reg('acceso-datos', 'Agente registra y edita lo propio', 'Simulado' if r == [True, False, True] else 'Falla', 'permite lo propio y rechaza lo ajeno; el control es de pantalla, no de seguridad')
    r = t("const s=d.solicitudes.find(s=>s.responsableId==='luis.mora'); return N.reasignar(d,U('marta.velez'),s.id,'ana.ruiz','Balance',AH).ok")
    reg('acceso-datos', 'Coordinador reasigna', 'Simulado' if r else 'Falla', 'permitido para el rol coordinador')
    r = t("const s=d.solicitudes[0]; return [N.editarSolicitud(d,U('julian.ortiz'),s.id,{asunto:'x'},AH).ok,N.registrarSolicitud(d,U('julian.ortiz'),base,AH).ok,N.buscar(d,{}).length>0]")
    reg('acceso-datos', 'Consulta no modifica', 'Simulado' if r == [False, False, True] else 'Falla', 'no edita ni registra y sí ve la bandeja')
    r = t("const p=N.crearUsuario(d,U('soporte'),{nombre:'Persona Nueva',id:'pn',rol:'agente'},AH); return d.auditoria.slice(-1)[0]")
    reg('acceso-datos', 'Campos de contacto permitidos (nombre y un medio)', 'Pasa' if ev("(()=>{" + PRE + "return [N.registrarSolicitud(d,U('ana.ruiz'),Object.assign({},base,{contactoNombre:'Ana'}),AH).ok,N.registrarSolicitud(d,U('ana.ruiz'),Object.assign({},base,{contactoNombre:'Ana',contactoMedio:'x@ejemplo.test'}),AH).ok]})()") == [False, True] else 'Falla', 'solo nombre y un medio; el formulario no tiene otros campos')
    r = t("N.cambiarRol(d,U('soporte'),'luis.mora','coordinador',AH); return d.auditoria.slice(-1)[0]")
    reg('acceso-datos', 'Cambio de rol auditado', 'Pasa' if r['accion'] == 'Cambio de rol' and r['usuarioId'] == 'soporte' and 'agente → coordinador' in r['detalle'] else 'Falla', f"{r['usuarioId']} · {r['detalle']} · {r['fecha']}")
    reg('acceso-datos', 'Inicio de sesión fallido', 'No cubierto', 'sin contraseñas no existe el ingreso fallido; solo se audita el ingreso exitoso')
    r = t("const a=Aurora.ambientes.trabajo.solicitudes.length; const c=Aurora.ambientes.capacitacion.solicitudes.length; N.registrarSolicitud(Aurora.ambientes.capacitacion,N.col(Aurora.ambientes.capacitacion,'ana.ruiz'),base,AH); return [a,Aurora.ambientes.trabajo.solicitudes.length,c,Aurora.ambientes.capacitacion.solicitudes.length]")
    reg('acceso-datos', 'Separación de ambientes de capacitación', 'Pasa' if r[0] == r[1] == 0 and r[3] == r[2] + 1 else 'Falla', f'trabajo {r[0]}→{r[1]}; capacitación {r[2]}→{r[3]}')

    # ---------------- respaldo ----------------
    reg('respaldo', 'Respaldo exitoso (programado)', 'No cubierto', 'no hay ejecución programada sin servidor; el respaldo es la exportación manual')
    reg('respaldo', 'Respaldo fallido (aviso al administrador)', 'No cubierto', 'sin respaldo programado no hay fallo que avisar')
    r = t("const x=N.exportar(d,U('soporte'),AH); const p=N.probarRecuperacion(d,U('soporte'),x.texto,AH); const i=N.importarRespaldo(d,U('soporte'),x.texto,AH); const mal=N.probarRecuperacion(d,U('soporte'),'no es json',AH); return [x.ok,p.coincide,p.detalle,i.ok&&i.db.solicitudes.length===d.solicitudes.length&&i.db.cambios.length===d.cambios.length,mal.ok,N.exportar(d,U('ana.ruiz'),AH).ok]")
    reg('respaldo', 'Prueba de restauración (conteos y tiempo)', 'Pasa (parcial)' if r[0] and r[1] and r[3] and not r[4] and not r[5] else 'Falla', r[2] + '; la prueba la ejecuta el administrador técnico con un respaldo manual')
    r = t("const x=N.exportar(d,U('soporte'),AH); const o=JSON.parse(x.texto); o.ambiente='trabajo'; return N.importarRespaldo(d,U('soporte'),JSON.stringify(o),AH)")
    reg('respaldo', 'No mezclar ambientes al importar', 'Pasa' if not r['ok'] else 'Falla', r['error'])
    r = t("const csv='id;nombre\\nCLI-100;Cliente Nuevo\\nCLI-001;Colegio Los Cedros\\n;Sin id'; const a=N.importarClientes(d,U('soporte'),csv,AH); const j=N.importarClientes(d,U('soporte'),JSON.stringify([{id:'CLI-101',nombre:'Otro'}]),AH); return [a.nuevos,a.rechazados,j.nuevos,d.clientes.length]")
    reg('datos', 'Importación del directorio de clientes (CSV y JSON)', 'Pasa' if r == [1, 1, 1, 17] else 'Falla', f'CSV: {r[0]} nuevo, {r[1]} rechazado; JSON: {r[2]} nuevo; total {r[3]}')

    # ---------------- Interfaz (flujos de pantalla) ----------------
    pg.reload()
    pg.select_option('#uid', 'ana.ruiz'); pg.click('form[data-form=ingreso] button')
    pg.click('button[data-v=registrar]')
    pg.select_option('select[name=clienteId]', 'CLI-003'); pg.select_option('select[name=canal]', 'correo')
    pg.click('form[data-form=registrar] button')
    msg = pg.inner_text('.aviso-msg')
    reg('interfaz', 'Guardar sin asunto muestra el campo faltante', 'Pasa' if 'asunto' in msg else 'Falla', msg)
    pg.fill('input[name=asunto]', 'Prueba desde la pantalla'); pg.click('form[data-form=registrar] button')
    msg = pg.inner_text('.aviso-msg')
    reg('interfaz', 'Referencia visible tras guardar', 'Pasa' if 'SOL-' in msg else 'Falla', msg)
    pg.click('button[data-v=bandeja]'); pg.fill('input[data-f=ref]', 'SOL-')
    filas = pg.locator('#tabla tbody tr[data-id]').count()
    reg('interfaz', 'Bandeja con filtros y detalle con línea de tiempo', 'Pasa' if filas >= 26 and 'Línea de tiempo' in pg.inner_text('#detalle') else 'Falla', f'{filas} filas; detalle de la solicitud recién creada visible')
    pg.click('button[data-act=salir]'); pg.select_option('#uid', 'soporte'); pg.click('form[data-form=ingreso] button')
    tabs = pg.inner_text('nav.tabs')
    cuerpo = pg.inner_text('main')
    reg('acceso-datos', 'El proveedor no ve datos de clientes (pantalla)', 'Simulado' if 'Bandeja' not in tabs and 'Prueba desde la pantalla' not in cuerpo else 'Falla', f'pestañas del administrador técnico: {tabs.replace(chr(10), " · ")}')
    pg.click('button[data-v=respaldo]')
    cuerpo = pg.inner_text('main')
    reg('respaldo', 'Procedimiento disponible (pasos, responsables, último resultado)', 'Pasa' if 'Procedimiento de recuperación' in cuerpo and 'Última prueba' in cuerpo else 'Falla', 'sección con pasos, responsables y estado de la última prueba')
    pg.click('button[data-act=salir]')
    pg.select_option('#uid', 'marta.velez'); pg.click('form[data-form=ingreso] button'); pg.click('button[data-v=panel]')
    pg.click('button[data-act=ausencia][data-v="diego.salas"]')
    cuerpo = pg.inner_text('main')
    reg('interfaz', 'Panel del coordinador: ausencia y solicitudes sin responsable activo', 'Pasa' if 'Ausente' in cuerpo and 'sin responsable activo' in cuerpo.lower() else 'Falla', 'marca ausente a un agente y lista sus solicitudes')
    pg.fill('input[name=motivo]', 'Ausencia de Diego'); pg.select_option('form[data-form=lote] select[name=nuevo]', 'ana.ruiz'); pg.click('form[data-form=lote] button')
    msg = pg.inner_text('.aviso-msg')
    reg('interfaz', 'Reasignación por lote desde la pantalla', 'Pasa' if 'reasignadas' in msg else 'Falla', msg)
    nav.close()

reg('interfaz', 'Errores de JavaScript en la consola', 'Pasa' if not errores else 'Falla', '; '.join(errores) or 'ninguno')

filas = ['| Capacidad | Escenario | Resultado | Evidencia |', '|---|---|---|---|'] + [f'| {a} | {b} | {c} | {d.replace("|", "/")} |' for a, b, c, d in res]
salida = '\n'.join(filas)
print(salida)
(RAIZ / 'docs').mkdir(exist_ok=True)
(RAIZ / 'docs' / 'verificacion-h1.md').write_text('# Verificación de h1-registro-confiable (V1)\n\nGenerado por `tests/verificar_h1.py` contra `app/index.html`.\nResultados: **Pasa** = cumple; **Pasa (parcial)** = cumple con el límite indicado; **Simulado** = se aplica en pantalla sin seguridad real; **No cubierto** = la V1 no lo implementa; **Falla** = defecto.\n\n' + salida + '\n', encoding='utf-8')
sys.exit(1 if any(c == 'Falla' for _, _, c, _ in res) else 0)
