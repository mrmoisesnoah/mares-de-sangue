-- ============================================================
-- Migração: Perfil editável + Mesas funcionais
-- Mares de Sangue / O Mundo de Skard
-- Rodar no Supabase: SQL Editor > New query > colar tudo > Run.
-- 100% idempotente — pode rodar quantas vezes quiser, sem erro.
-- NÃO recria o banco; só acrescenta o que faltava.
-- ============================================================

-- 1) Colunas do perfil (foto, bio e epíteto/título)
alter table profiles add column if not exists avatar_url text;
alter table profiles add column if not exists bio        text;
alter table profiles add column if not exists epiteto    text;

-- 2) Mesa: ao criar uma mesa, o criador vira membro 'mestre' automaticamente.
--    Necessário porque a visibilidade (RLS) depende da tabela mesa_membros.
create or replace function handle_new_mesa()
returns trigger language plpgsql security definer
set search_path = public as $$
begin
  insert into public.mesa_membros (mesa_id, user_id, papel)
  values (new.id, new.mestre_id, 'mestre')
  on conflict (mesa_id, user_id) do update set papel = 'mestre';
  return new;
end $$;

drop trigger if exists on_mesa_created on mesas;
create trigger on_mesa_created after insert on mesas
  for each row execute function handle_new_mesa();

-- 3) Backfill: registra o mestre nas mesas que já existiam.
insert into mesa_membros (mesa_id, user_id, papel)
  select id, mestre_id, 'mestre' from mesas
  on conflict (mesa_id, user_id) do update set papel = 'mestre';
