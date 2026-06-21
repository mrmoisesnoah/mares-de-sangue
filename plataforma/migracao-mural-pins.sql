-- Mural da Mesa: fixar (pinar) qualquer conteúdo no mural de uma mesa.
-- Uma fixação NÃO altera o conteúdo — é só uma referência (mesa + alvo).
create table if not exists mural_pins (
  id uuid primary key default gen_random_uuid(),
  mesa_id uuid not null references mesas(id) on delete cascade,
  tipo text not null default 'publicacao',   -- por enquanto: 'publicacao'
  alvo_id uuid not null,
  fixado_por uuid references auth.users(id),
  criado_em timestamptz not null default now(),
  unique (mesa_id, tipo, alvo_id)
);
alter table mural_pins enable row level security;

drop policy if exists mp_select on mural_pins;
create policy mp_select on mural_pins for select using (true);

-- só o mestre da mesa (ou admin) pode fixar / desfixar
drop policy if exists mp_insert on mural_pins;
create policy mp_insert on mural_pins for insert with check (is_mestre(mesa_id) or is_admin());

drop policy if exists mp_delete on mural_pins;
create policy mp_delete on mural_pins for delete using (is_mestre(mesa_id) or is_admin());
