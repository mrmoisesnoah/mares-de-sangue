-- ============================================================
-- Migração: Permissionamento (mundo + personagem)
-- - Colaboradores do mundo podem criar conteúdo no mundo.
-- - Contribuidores do personagem podem escrever na página dele.
-- - Criar personagem dentro de uma mesa exige ser membro da mesa.
-- Idempotente — pode rodar várias vezes.
-- ============================================================

-- ---- Colaboradores do mundo ----
create table if not exists mundo_membros (
  mundo_id  uuid not null references mundos(id) on delete cascade,
  user_id   uuid not null references profiles(id) on delete cascade,
  papel     text not null default 'colaborador',
  criado_em timestamptz not null default now(),
  primary key (mundo_id, user_id)
);
alter table mundo_membros enable row level security;

create or replace function is_colab_mundo(p_mundo uuid) returns boolean
language sql security definer stable set search_path = public as $$
  select exists (select 1 from mundo_membros m where m.mundo_id = p_mundo and m.user_id = auth.uid());
$$;

drop policy if exists mwm_select on mundo_membros;
create policy mwm_select on mundo_membros for select using (is_dono_mundo(mundo_id) or user_id = auth.uid() or is_admin());
drop policy if exists mwm_insert on mundo_membros;
create policy mwm_insert on mundo_membros for insert with check (is_dono_mundo(mundo_id) or is_admin());
drop policy if exists mwm_delete on mundo_membros;
create policy mwm_delete on mundo_membros for delete using (is_dono_mundo(mundo_id) or is_admin());

-- ---- Contribuidores do personagem ----
create table if not exists personagem_contribuidores (
  personagem_id uuid not null references personagens(id) on delete cascade,
  user_id       uuid not null references profiles(id) on delete cascade,
  criado_em     timestamptz not null default now(),
  primary key (personagem_id, user_id)
);
alter table personagem_contribuidores enable row level security;

create or replace function is_dono_pers(p_pers uuid) returns boolean
language sql security definer stable set search_path = public as $$
  select exists (select 1 from personagens p where p.id = p_pers and p.jogador_id = auth.uid());
$$;
create or replace function is_contrib_pers(p_pers uuid) returns boolean
language sql security definer stable set search_path = public as $$
  select exists (select 1 from personagem_contribuidores c where c.personagem_id = p_pers and c.user_id = auth.uid());
$$;

drop policy if exists pcb_select on personagem_contribuidores;
create policy pcb_select on personagem_contribuidores for select using (is_dono_pers(personagem_id) or user_id = auth.uid() or is_admin());
drop policy if exists pcb_insert on personagem_contribuidores;
create policy pcb_insert on personagem_contribuidores for insert with check (is_dono_pers(personagem_id) or is_admin());
drop policy if exists pcb_delete on personagem_contribuidores;
create policy pcb_delete on personagem_contribuidores for delete using (is_dono_pers(personagem_id) or is_admin());

-- ---- pub_insert: honra colaborador do mundo e dono/contribuidor do personagem ----
drop policy if exists pub_insert on publicacoes;
create policy pub_insert on publicacoes for insert with check (
  autor_id = auth.uid() and (
    is_admin()
    or is_dono_mundo(mundo_id)
    or is_colab_mundo(mundo_id)
    or (mesa_id is not null and is_membro(mesa_id))
    or (personagem_id is not null and (is_dono_pers(personagem_id) or is_contrib_pers(personagem_id)))
  )
);

-- ---- pers_insert: criar personagem em mesa exige ser membro ----
drop policy if exists pers_insert on personagens;
create policy pers_insert on personagens for insert with check (
  jogador_id = auth.uid() and (mesa_id is null or is_membro(mesa_id) or is_admin())
);
