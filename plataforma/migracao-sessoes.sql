-- ============================================================
-- Migração: Sessões da mesa (Área do Mestre)
-- Sessão = marcador estruturado dentro de uma mesa.
-- Conteúdo pode ser ligado a uma sessão (sessao_id).
-- A visibilidade de cada conteúdo continua decidindo quem vê.
-- Idempotente.
-- ============================================================
create table if not exists sessoes (
  id        uuid primary key default gen_random_uuid(),
  mesa_id   uuid not null references mesas(id) on delete cascade,
  titulo    text not null,
  ordem     int,
  data      date,
  criado_em timestamptz not null default now()
);
alter table publicacoes add column if not exists sessao_id uuid references sessoes(id) on delete set null;
create index if not exists idx_pub_sessao on publicacoes(sessao_id);
alter table sessoes enable row level security;

-- sessões (rótulos) visíveis a quem vê a mesa; o conteúdo tem visibilidade própria
drop policy if exists ses_select on sessoes;
create policy ses_select on sessoes for select using (
  is_membro(mesa_id) or is_admin()
  or exists (select 1 from mesas me join mundos w on w.id=me.mundo_id where me.id = sessoes.mesa_id and w.publico)
);
drop policy if exists ses_insert on sessoes;
create policy ses_insert on sessoes for insert with check (is_mestre(mesa_id) or is_admin());
drop policy if exists ses_update on sessoes;
create policy ses_update on sessoes for update using (is_mestre(mesa_id) or is_admin());
drop policy if exists ses_delete on sessoes;
create policy ses_delete on sessoes for delete using (is_mestre(mesa_id) or is_admin());
