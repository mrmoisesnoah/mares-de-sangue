-- ============================================================
-- Migração: vincular conteúdos aos eventos da linha do tempo
-- Idempotente.
-- ============================================================
create table if not exists evento_links (
  id        uuid primary key default gen_random_uuid(),
  evento_id uuid not null references eventos(id) on delete cascade,
  tipo      text not null check (tipo in ('publicacao','personagem','jornal')),
  alvo_id   uuid not null,
  criado_em timestamptz not null default now(),
  unique (evento_id, tipo, alvo_id)
);
alter table evento_links enable row level security;

create or replace function pode_editar_evento(p_evt uuid) returns boolean
language sql security definer stable set search_path = public as $$
  select exists (select 1 from eventos e where e.id = p_evt and (e.autor_id = auth.uid() or is_dono_mundo(e.mundo_id) or is_admin()));
$$;

drop policy if exists evl_select on evento_links;
create policy evl_select on evento_links for select using (true);
drop policy if exists evl_insert on evento_links;
create policy evl_insert on evento_links for insert with check (pode_editar_evento(evento_id));
drop policy if exists evl_delete on evento_links;
create policy evl_delete on evento_links for delete using (pode_editar_evento(evento_id));
