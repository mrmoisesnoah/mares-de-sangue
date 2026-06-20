-- ============================================================
-- Migração: Linha do Tempo v2 — períodos + eventos por mesa
-- Idempotente.
-- ============================================================
create table if not exists periodos (
  id         uuid primary key default gen_random_uuid(),
  mundo_id   uuid not null references mundos(id) on delete cascade,
  mesa_id    uuid references mesas(id) on delete cascade,
  nome       text not null,
  imagem_url text,
  ordem      int,
  criado_em  timestamptz not null default now()
);
alter table eventos add column if not exists mesa_id    uuid references mesas(id) on delete cascade;
alter table eventos add column if not exists periodo_id uuid references periodos(id) on delete set null;
alter table periodos enable row level security;

create or replace function pode_editar_periodo(p_mundo uuid, p_mesa uuid) returns boolean
language sql security definer stable set search_path = public as $$
  select case when p_mesa is not null then (is_mestre(p_mesa) or is_admin())
              else (is_dono_mundo(p_mundo) or is_colab_mundo(p_mundo) or is_admin()) end;
$$;

drop policy if exists per_select on periodos;
create policy per_select on periodos for select using (true);
drop policy if exists per_insert on periodos;
create policy per_insert on periodos for insert with check (pode_editar_periodo(mundo_id, mesa_id));
drop policy if exists per_update on periodos;
create policy per_update on periodos for update using (pode_editar_periodo(mundo_id, mesa_id));
drop policy if exists per_delete on periodos;
create policy per_delete on periodos for delete using (pode_editar_periodo(mundo_id, mesa_id));

-- eventos: incluir membros da mesa na visibilidade e mestre na edição
drop policy if exists evt_select on eventos;
create policy evt_select on eventos for select using (
  is_admin() or autor_id = auth.uid() or (visibilidade='publico' and estado='publicado')
  or is_dono_mundo(mundo_id) or is_colab_mundo(mundo_id)
  or (mesa_id is not null and is_membro(mesa_id))
);
drop policy if exists evt_insert on eventos;
create policy evt_insert on eventos for insert with check (
  autor_id = auth.uid() and (is_dono_mundo(mundo_id) or is_colab_mundo(mundo_id) or (mesa_id is not null and is_mestre(mesa_id)) or is_admin())
);
drop policy if exists evt_update on eventos;
create policy evt_update on eventos for update using (autor_id = auth.uid() or is_dono_mundo(mundo_id) or (mesa_id is not null and is_mestre(mesa_id)) or is_admin());
drop policy if exists evt_delete on eventos;
create policy evt_delete on eventos for delete using (autor_id = auth.uid() or is_dono_mundo(mundo_id) or (mesa_id is not null and is_mestre(mesa_id)) or is_admin());
