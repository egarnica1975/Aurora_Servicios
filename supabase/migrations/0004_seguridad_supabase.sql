-- 0004 · Seguridad en Supabase: la API de datos de Supabase (PostgREST) no debe poder leer ni escribir.
-- La única vía de acceso es el servidor FastAPI con el rol aurora_app.
do $$
declare t text;
begin
  -- 1. Sin acceso para los roles públicos de Supabase (si existen)
  if exists (select 1 from pg_roles where rolname = 'anon') then
    revoke all on all tables in schema public from anon;
    revoke all on all sequences in schema public from anon;
    revoke all on all functions in schema public from anon;
    alter default privileges in schema public revoke all on tables from anon;
    alter default privileges in schema public revoke all on sequences from anon;
    alter default privileges in schema public revoke all on functions from anon;
  end if;
  if exists (select 1 from pg_roles where rolname = 'authenticated') then
    revoke all on all tables in schema public from authenticated;
    revoke all on all sequences in schema public from authenticated;
    revoke all on all functions in schema public from authenticated;
    alter default privileges in schema public revoke all on tables from authenticated;
    alter default privileges in schema public revoke all on sequences from authenticated;
    alter default privileges in schema public revoke all on functions from authenticated;
  end if;
  -- 2. Seguridad por filas activada en todas las tablas; solo aurora_app tiene política
  for t in select tablename from pg_tables where schemaname = 'public' loop
    execute format('alter table public.%I enable row level security', t);
    execute format('create policy aurora_app_todo on public.%I for all to aurora_app using (true) with check (true)', t);
  end loop;
end $$;
-- Las funciones sensibles no son ejecutables por el público
revoke execute on function siguiente_referencia(int) from public;
