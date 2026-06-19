-- ============================================================
-- Migração: Pedidos de acesso (colaboração)
-- Um usuário pede acesso a um mundo/mesa/personagem; o dono aprova
-- e isso o torna colaborador. Idempotente.
-- ============================================================
create table if not exists pedidos_acesso (
  id             uuid primary key default gen_random_uuid(),
  tipo           text not null check (tipo in ('mundo','mesa','personagem')),
  alvo_id        uuid not null,
  solicitante_id uuid not null references profiles(id) on delete cascade,
  mensagem       text,
  estado         text not null default 'pendente' check (estado in ('pendente','aprovado','recusado')),
  criado_em      timestamptz not null default now()
);
create index if not exists idx_pedidos_alvo on pedidos_acesso(tipo, alvo_id, estado);
alter table pedidos_acesso enable row level security;

create or replace function is_dono_alvo(p_tipo text, p_alvo uuid) returns boolean
language sql security definer stable set search_path = public as $$
  select case p_tipo
    when 'mundo' then is_dono_mundo(p_alvo)
    when 'mesa' then is_mestre(p_alvo)
    when 'personagem' then is_dono_pers(p_alvo)
    else false end;
$$;

drop policy if exists ped_select on pedidos_acesso;
create policy ped_select on pedidos_acesso for select using (
  solicitante_id = auth.uid() or is_admin() or is_dono_alvo(tipo, alvo_id)
);
drop policy if exists ped_insert on pedidos_acesso;
create policy ped_insert on pedidos_acesso for insert with check (solicitante_id = auth.uid());
drop policy if exists ped_update on pedidos_acesso;
create policy ped_update on pedidos_acesso for update using (is_dono_alvo(tipo, alvo_id) or is_admin());
drop policy if exists ped_delete on pedidos_acesso;
create policy ped_delete on pedidos_acesso for delete using (solicitante_id = auth.uid() or is_dono_alvo(tipo, alvo_id) or is_admin());
