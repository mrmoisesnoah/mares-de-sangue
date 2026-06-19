-- ============================================================
-- Migração: Jornais do mundo
-- Jornal vinculado ao mundo; notícias são publicações com jornal_id;
-- o dono autoriza "escritores" a publicar pelo jornal. Idempotente.
-- ============================================================
create table if not exists jornais (
  id           uuid primary key default gen_random_uuid(),
  mundo_id     uuid not null references mundos(id) on delete cascade,
  dono_id      uuid not null references profiles(id),
  nome         text not null,
  slug         text not null,
  descricao    text,
  imagem_url   text,
  visibilidade text not null default 'publico',
  estado       text not null default 'publicado',
  criado_em    timestamptz not null default now()
);
alter table publicacoes add column if not exists jornal_id uuid references jornais(id) on delete set null;
create index if not exists idx_pub_jornal on publicacoes(jornal_id);

create table if not exists jornal_escritores (
  jornal_id uuid not null references jornais(id) on delete cascade,
  user_id   uuid not null references profiles(id) on delete cascade,
  criado_em timestamptz not null default now(),
  primary key (jornal_id, user_id)
);

alter table jornais            enable row level security;
alter table jornal_escritores  enable row level security;

create or replace function is_dono_jornal(p_j uuid) returns boolean
language sql security definer stable set search_path = public as $$
  select exists (select 1 from jornais j where j.id = p_j and j.dono_id = auth.uid());
$$;
create or replace function is_escritor_jornal(p_j uuid) returns boolean
language sql security definer stable set search_path = public as $$
  select exists (select 1 from jornal_escritores e where e.jornal_id = p_j and e.user_id = auth.uid());
$$;

drop policy if exists jor_select on jornais;
create policy jor_select on jornais for select using (
  is_admin() or dono_id = auth.uid() or (visibilidade='publico' and estado='publicado') or is_escritor_jornal(id)
);
drop policy if exists jor_insert on jornais;
create policy jor_insert on jornais for insert with check (dono_id = auth.uid());
drop policy if exists jor_update on jornais;
create policy jor_update on jornais for update using (dono_id = auth.uid() or is_admin());
drop policy if exists jor_delete on jornais;
create policy jor_delete on jornais for delete using (dono_id = auth.uid() or is_admin());

drop policy if exists jes_select on jornal_escritores;
create policy jes_select on jornal_escritores for select using (is_dono_jornal(jornal_id) or user_id = auth.uid() or is_admin());
drop policy if exists jes_insert on jornal_escritores;
create policy jes_insert on jornal_escritores for insert with check (is_dono_jornal(jornal_id) or is_admin());
drop policy if exists jes_delete on jornal_escritores;
create policy jes_delete on jornal_escritores for delete using (is_dono_jornal(jornal_id) or is_admin());

-- pub_insert: honra dono/escritor do jornal (mantém as demais autorizações)
drop policy if exists pub_insert on publicacoes;
create policy pub_insert on publicacoes for insert with check (
  autor_id = auth.uid() and (
    is_admin()
    or is_dono_mundo(mundo_id)
    or is_colab_mundo(mundo_id)
    or (mesa_id is not null and is_membro(mesa_id))
    or (personagem_id is not null and (is_dono_pers(personagem_id) or is_contrib_pers(personagem_id)))
    or (jornal_id is not null and (is_dono_jornal(jornal_id) or is_escritor_jornal(jornal_id)))
  )
);
