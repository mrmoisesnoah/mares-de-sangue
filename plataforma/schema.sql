-- ============================================================
-- Mares de Sangue — Esquema da Plataforma (Supabase / PostgreSQL)
-- Modelo: Mundo > Mesa > Personagem > Publicação  ("tudo é publicação")
-- Visibilidade aplicada por Row Level Security (RLS).
-- Rodar no painel do Supabase: SQL Editor > New query > colar > Run.
-- Versão 1 (fundação). Refinar conforme as telas evoluem.
-- ============================================================

-- ---------- Perfis (1:1 com auth.users) ----------
create table if not exists profiles (
  id          uuid primary key references auth.users(id) on delete cascade,
  nome        text not null default 'Aventureiro',
  papel_global text not null default 'usuario' check (papel_global in ('admin','usuario')),
  criado_em   timestamptz not null default now()
);

-- Cria o perfil automaticamente quando um usuário se registra
create or replace function handle_new_user()
returns trigger language plpgsql security definer
set search_path = public as $$
begin
  insert into public.profiles (id, nome)
  values (new.id, coalesce(new.raw_user_meta_data->>'nome','Aventureiro'))
  on conflict (id) do nothing;
  return new;
end $$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users
  for each row execute function handle_new_user();

-- ---------- Mundos / cenários ----------
create table if not exists mundos (
  id        uuid primary key default gen_random_uuid(),
  nome      text not null,
  slug      text unique not null,
  descricao text,
  dono_id   uuid not null references profiles(id),
  publico   boolean not null default true,
  criado_em timestamptz not null default now()
);

-- Ao criar uma mesa, o criador (mestre_id) vira membro 'mestre' automaticamente.
-- Necessário porque as regras de visibilidade (RLS) dependem de mesa_membros.
-- (definição da função/trigger logo após a tabela mesa_membros)

-- ---------- Mesas / campanhas ----------
create table if not exists mesas (
  id        uuid primary key default gen_random_uuid(),
  mundo_id  uuid not null references mundos(id) on delete cascade,
  nome      text not null,
  slug      text not null,
  descricao text,
  mestre_id uuid not null references profiles(id),
  criado_em timestamptz not null default now(),
  unique (mundo_id, slug)
);

-- ---------- Membros das mesas (papel por mesa) ----------
create table if not exists mesa_membros (
  mesa_id   uuid not null references mesas(id) on delete cascade,
  user_id   uuid not null references profiles(id) on delete cascade,
  papel     text not null default 'jogador' check (papel in ('mestre','jogador')),
  criado_em timestamptz not null default now(),
  primary key (mesa_id, user_id)
);

-- Cria automaticamente o vínculo mestre quando uma mesa é criada,
-- e preenche as mesas que já existiam (idempotente).
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

insert into mesa_membros (mesa_id, user_id, papel)
  select id, mestre_id, 'mestre' from mesas
  on conflict (mesa_id, user_id) do update set papel = 'mestre';

-- ---------- Personagens ----------
create table if not exists personagens (
  id          uuid primary key default gen_random_uuid(),
  mundo_id    uuid not null references mundos(id) on delete cascade,
  mesa_id     uuid references mesas(id) on delete set null,
  jogador_id  uuid not null references profiles(id),
  nome        text not null,
  slug        text not null,
  criado_em   timestamptz not null default now()
);

-- ---------- Publicações (núcleo: tudo é publicação) ----------
create table if not exists publicacoes (
  id            uuid primary key default gen_random_uuid(),
  mundo_id      uuid not null references mundos(id) on delete cascade,
  mesa_id       uuid references mesas(id) on delete set null,
  personagem_id uuid references personagens(id) on delete set null,
  autor_id      uuid not null references profiles(id),
  tipo          text not null default 'artigo',
  titulo        text not null,
  slug          text not null,
  corpo         text,                      -- markdown
  categoria     text,
  tags          text[] not null default '{}',
  estado        text not null default 'rascunho' check (estado in ('rascunho','publicado')),
  visibilidade  text not null default 'mesa'
                check (visibilidade in ('publico','mesa','autor_mestre','privado','mestre')),
  criado_em     timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
create index if not exists idx_pub_mundo on publicacoes(mundo_id);
create index if not exists idx_pub_mesa  on publicacoes(mesa_id);
create index if not exists idx_pub_tipo  on publicacoes(tipo);
alter table publicacoes add column if not exists capa_url text;
-- capas e fundos (UI)
alter table mundos add column if not exists capa_url text;
alter table mundos add column if not exists fundo_url text;
alter table mesas  add column if not exists capa_url text;
alter table mesas  add column if not exists fundo_url text;
  -- imagem de capa (link ou Storage)

-- ---------- Mídias (imagem / vídeo / link / arquivo) ----------
create table if not exists midias (
  id            uuid primary key default gen_random_uuid(),
  publicacao_id uuid references publicacoes(id) on delete cascade,
  mundo_id      uuid references mundos(id) on delete cascade,
  autor_id      uuid not null references profiles(id),
  tipo          text not null check (tipo in ('imagem','video','link','arquivo')),
  url           text,         -- link externo ou URL pública do Storage
  storage_path  text,         -- caminho no Supabase Storage (quando upload)
  legenda       text,
  criado_em     timestamptz not null default now()
);

-- ---------- Referências entre publicações ----------
create table if not exists publicacao_relacoes (
  origem_id  uuid not null references publicacoes(id) on delete cascade,
  destino_id uuid not null references publicacoes(id) on delete cascade,
  rotulo     text,
  primary key (origem_id, destino_id)
);

-- ============================================================
-- Funções auxiliares para as regras de visibilidade
-- ============================================================
create or replace function is_admin() returns boolean
language sql security definer stable set search_path = public as $$
  select exists (select 1 from profiles p where p.id = auth.uid() and p.papel_global = 'admin')
$$;

create or replace function is_membro(p_mesa uuid) returns boolean
language sql security definer stable set search_path = public as $$
  select exists (select 1 from mesa_membros m where m.mesa_id = p_mesa and m.user_id = auth.uid())
$$;

create or replace function is_mestre(p_mesa uuid) returns boolean
language sql security definer stable set search_path = public as $$
  select exists (select 1 from mesa_membros m
                 where m.mesa_id = p_mesa and m.user_id = auth.uid() and m.papel = 'mestre')
$$;

create or replace function is_dono_mundo(p_mundo uuid) returns boolean
language sql security definer stable set search_path = public as $$
  select exists (select 1 from mundos w where w.id = p_mundo and w.dono_id = auth.uid())
$$;

-- ============================================================
-- Row Level Security
-- ============================================================
alter table profiles            enable row level security;
alter table mundos              enable row level security;
alter table mesas               enable row level security;
alter table mesa_membros        enable row level security;
alter table personagens         enable row level security;
alter table publicacoes         enable row level security;
alter table midias              enable row level security;
alter table publicacao_relacoes enable row level security;

-- Perfis: cada um lê todos os nomes; edita só o próprio
create policy prof_select on profiles for select using (true);
create policy prof_update on profiles for update using (id = auth.uid());

-- Mundos: públicos visíveis a todos; donos/admin gerenciam
create policy mundo_select on mundos for select using (publico or dono_id = auth.uid() or is_admin());
create policy mundo_insert on mundos for insert with check (dono_id = auth.uid());
create policy mundo_update on mundos for update using (dono_id = auth.uid() or is_admin());

-- Mesas: visíveis a membros (e dono do mundo/admin)
create policy mesa_select on mesas for select using (
  is_membro(id) or is_dono_mundo(mundo_id) or is_admin()
);
create policy mesa_insert on mesas for insert with check (mestre_id = auth.uid());
create policy mesa_update on mesas for update using (is_mestre(id) or is_admin());

-- Membros: visíveis aos membros da mesa; mestre gerencia
create policy memb_select on mesa_membros for select using (is_membro(mesa_id) or is_admin());
create policy memb_insert on mesa_membros for insert with check (is_mestre(mesa_id) or is_admin());
create policy memb_delete on mesa_membros for delete using (is_mestre(mesa_id) or is_admin());

-- Personagens: autor sempre; membros da mesa veem; demais conforme publicações
create policy pers_select on personagens for select using (
  jogador_id = auth.uid() or (mesa_id is not null and is_membro(mesa_id)) or is_admin()
);
create policy pers_insert on personagens for insert with check (jogador_id = auth.uid());
create policy pers_update on personagens for update using (jogador_id = auth.uid() or (mesa_id is not null and is_mestre(mesa_id)) or is_admin());

-- PUBLICAÇÕES — o coração da visibilidade
create policy pub_select on publicacoes for select using (
  is_admin()
  or autor_id = auth.uid()
  or (visibilidade = 'publico' and estado = 'publicado')
  or (visibilidade = 'mesa'         and mesa_id is not null and is_membro(mesa_id))
  or (visibilidade in ('autor_mestre','mestre') and mesa_id is not null and is_mestre(mesa_id))
);
create policy pub_insert on publicacoes for insert with check (
  autor_id = auth.uid() and (
    (mesa_id is not null and is_membro(mesa_id))
    or is_dono_mundo(mundo_id)
    or is_admin()
  )
);
create policy pub_update on publicacoes for update using (
  autor_id = auth.uid() or (mesa_id is not null and is_mestre(mesa_id)) or is_admin()
);
create policy pub_delete on publicacoes for delete using (
  autor_id = auth.uid() or (mesa_id is not null and is_mestre(mesa_id)) or is_admin()
);

-- Mídias: seguem a publicação dona (visível se a publicação for visível)
create policy midia_select on midias for select using (
  publicacao_id is null
  or exists (select 1 from publicacoes p where p.id = midias.publicacao_id)  -- RLS de publicacoes filtra o resto
);
create policy midia_insert on midias for insert with check (autor_id = auth.uid());
create policy midia_delete on midias for delete using (autor_id = auth.uid() or is_admin());

-- Relações: leitura livre entre publicações visíveis; autor cria
create policy rel_select on publicacao_relacoes for select using (true);
create policy rel_insert on publicacao_relacoes for insert with check (
  exists (select 1 from publicacoes p where p.id = origem_id and (p.autor_id = auth.uid() or is_admin()))
);

-- ============================================================
-- SEED — rodar DEPOIS de criar sua conta (1º login) e descobrir seu user id
-- (Authentication > Users no painel, ou: select auth.uid())
-- Substitua 'SEU-USER-ID' pelo seu id.
-- ============================================================
-- update profiles set papel_global = 'admin' where id = 'SEU-USER-ID';
-- insert into mundos (nome, slug, descricao, dono_id, publico)
--   values ('O Mundo de Skard','mares-de-sangue','Cenário de Mares de Sangue — o continente de Dagorcain','SEU-USER-ID', true);
-- insert into mesas (mundo_id, nome, slug, descricao, mestre_id)
--   select id, 'Ecos na Cidade dos Corvos','ecos-na-cidade-dos-corvos','Campanha atual', 'SEU-USER-ID'
--   from mundos where slug = 'mares-de-sangue';
