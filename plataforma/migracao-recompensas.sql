-- ============================================================
-- Migração: recompensas da sessão (XP, itens, prêmios)
-- Idempotente.
-- ============================================================
create table if not exists recompensas (
  id            uuid primary key default gen_random_uuid(),
  sessao_id     uuid not null references sessoes(id) on delete cascade,
  mesa_id       uuid not null references mesas(id) on delete cascade,
  personagem_id uuid references personagens(id) on delete set null,
  tipo          text not null default 'xp' check (tipo in ('xp','item','premio')),
  titulo        text not null,
  quantidade    int,
  descricao     text,
  criado_em     timestamptz not null default now()
);
create index if not exists idx_recompensas_sessao on recompensas(sessao_id);
alter table recompensas enable row level security;

drop policy if exists rec_select on recompensas;
create policy rec_select on recompensas for select using (is_membro(mesa_id) or is_admin());
drop policy if exists rec_insert on recompensas;
create policy rec_insert on recompensas for insert with check (is_mestre(mesa_id) or is_admin());
drop policy if exists rec_update on recompensas;
create policy rec_update on recompensas for update using (is_mestre(mesa_id) or is_admin());
drop policy if exists rec_delete on recompensas;
create policy rec_delete on recompensas for delete using (is_mestre(mesa_id) or is_admin());
