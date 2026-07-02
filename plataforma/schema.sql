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

alter table profiles add column if not exists avatar_url text;
alter table profiles add column if not exists bio text;
alter table profiles add column if not exists epiteto text;
alter table profiles add column if not exists apelido text;  -- nome de exibição (vira o nome no site)
create index if not exists idx_profiles_apelido on profiles (lower(apelido));

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
drop policy if exists prof_select on profiles;
create policy prof_select on profiles for select using (true);
drop policy if exists prof_update on profiles;
create policy prof_update on profiles for update using (id = auth.uid());

-- Mundos: públicos visíveis a todos; donos/admin gerenciam
drop policy if exists mundo_select on mundos;
create policy mundo_select on mundos for select using (publico or dono_id = auth.uid() or is_admin());
drop policy if exists mundo_insert on mundos;
create policy mundo_insert on mundos for insert with check (dono_id = auth.uid());
drop policy if exists mundo_update on mundos;
create policy mundo_update on mundos for update using (dono_id = auth.uid() or is_admin());

-- Mesas: visíveis a membros (e dono do mundo/admin)
drop policy if exists mesa_select on mesas;
create policy mesa_select on mesas for select using (
  is_membro(id) or is_dono_mundo(mundo_id) or is_admin()
);
drop policy if exists mesa_insert on mesas;
create policy mesa_insert on mesas for insert with check (mestre_id = auth.uid());
drop policy if exists mesa_update on mesas;
create policy mesa_update on mesas for update using (is_mestre(id) or is_admin());

-- Membros: visíveis aos membros da mesa; mestre gerencia
drop policy if exists memb_select on mesa_membros;
create policy memb_select on mesa_membros for select using (is_membro(mesa_id) or is_admin());
drop policy if exists memb_insert on mesa_membros;
create policy memb_insert on mesa_membros for insert with check (is_mestre(mesa_id) or is_admin());
drop policy if exists memb_delete on mesa_membros;
create policy memb_delete on mesa_membros for delete using (is_mestre(mesa_id) or is_admin());

-- Personagens: autor sempre; membros da mesa veem; demais conforme publicações
drop policy if exists pers_select on personagens;
create policy pers_select on personagens for select using (
  jogador_id = auth.uid() or (mesa_id is not null and is_membro(mesa_id)) or is_admin()
);
drop policy if exists pers_insert on personagens;
create policy pers_insert on personagens for insert with check (
  jogador_id = auth.uid() and (
    mesa_id is null            -- personagem livre no mundo
    or is_membro(mesa_id)      -- ligado a uma mesa: precisa ser membro
    or is_dono_mundo(mundo_id) -- dono do mundo
    or is_admin()
  )
);
drop policy if exists pers_update on personagens;
create policy pers_update on personagens for update using (jogador_id = auth.uid() or (mesa_id is not null and is_mestre(mesa_id)) or is_admin());

-- PUBLICAÇÕES — o coração da visibilidade
drop policy if exists pub_select on publicacoes;
create policy pub_select on publicacoes for select using (
  is_admin()
  or autor_id = auth.uid()
  or (visibilidade = 'publico' and estado = 'publicado')
  or (visibilidade = 'mesa'         and mesa_id is not null and is_membro(mesa_id))
  or (visibilidade in ('autor_mestre','mestre') and mesa_id is not null and is_mestre(mesa_id))
);
drop policy if exists pub_insert on publicacoes;
create policy pub_insert on publicacoes for insert with check (
  autor_id = auth.uid() and (
    (mesa_id is not null and is_membro(mesa_id))
    or is_dono_mundo(mundo_id)
    or is_admin()
  )
);
drop policy if exists pub_update on publicacoes;
create policy pub_update on publicacoes for update using (
  autor_id = auth.uid() or (mesa_id is not null and is_mestre(mesa_id)) or is_admin()
);
drop policy if exists pub_delete on publicacoes;
create policy pub_delete on publicacoes for delete using (
  autor_id = auth.uid() or (mesa_id is not null and is_mestre(mesa_id)) or is_admin()
);

-- Mídias: seguem a publicação dona (visível se a publicação for visível)
drop policy if exists midia_select on midias;
create policy midia_select on midias for select using (
  publicacao_id is null
  or exists (select 1 from publicacoes p where p.id = midias.publicacao_id)  -- RLS de publicacoes filtra o resto
);
drop policy if exists midia_insert on midias;
create policy midia_insert on midias for insert with check (autor_id = auth.uid());
drop policy if exists midia_delete on midias;
create policy midia_delete on midias for delete using (autor_id = auth.uid() or is_admin());

-- Relações: leitura livre entre publicações visíveis; autor cria
drop policy if exists rel_select on publicacao_relacoes;
create policy rel_select on publicacao_relacoes for select using (true);
drop policy if exists rel_insert on publicacao_relacoes;
create policy rel_insert on publicacao_relacoes for insert with check (
  exists (select 1 from publicacoes p where p.id = origem_id and (p.autor_id = auth.uid() or is_admin()))
);

-- ============================================================
-- Convites (mestre -> jogador) + busca de usuários
-- (ver migracao-usuarios-convites.sql — replicado aqui para o schema de referência)
-- ============================================================
create table if not exists convites (
  id            uuid primary key default gen_random_uuid(),
  mesa_id       uuid not null refe
-- =========================================================
-- Administração: tiers de papel (super-admin) + site_config + RPCs
-- (ver migracao-admin.sql). Idempotente.
-- =========================================================
alter table profiles drop constraint if exists profiles_papel_global_check;
alter table profiles add constraint profiles_papel_global_check
  check (papel_global in ('superadmin','admin','usuario'));

create or replace function is_superadmin() returns boolean
language sql stable security definer set search_path=public as $$
  select exists(select 1 from profiles p where p.id=auth.uid() and p.papel_global='superadmin');
$$;

create or replace function is_admin() returns boolean
language sql stable security definer set search_path=public as $$
  select exists(select 1 from profiles p where p.id=auth.uid() and p.papel_global in ('admin','superadmin'));
$$;

create table if not exists site_config (
  id            int primary key default 1,
  titulo        text,
  descricao     text,
  imagem_url    text,
  mensagem      text,
  atualizado_em timestamptz default now(),
  constraint site_config_singleton check (id=1)
);
insert into site_config (id, titulo, descricao)
  values (1, 'Mares de Sangue', 'Plataforma para Criação de Mundos — uma produção TOGA, The Older Gods Adventures')
  on conflict (id) do nothing;
alter table site_config enable row level security;
drop policy if exists sc_select on site_config;
create policy sc_select on site_config for select using (true);
drop policy if exists sc_update on site_config;
create policy sc_update on site_config for update using (is_admin());
t p.id, p.nome, p.apelido, p.epiteto, p.avatar_url, u.email
    from profiles p join auth.users u on u.id = p.id
    where auth.uid() is not null and p.id <> auth.uid() and (
      coalesce(p.apelido,'') ilike trim(coalesce(termo,''))||'%'
      or coalesce(p.nome,'') ilike trim(coalesce(termo,''))||'%'
      or u.email             ilike trim(coalesce(termo,''))||'%')
  )
  select id, nome, apelido, epiteto, avatar_url,
         case when position('@' in email)>0
           then left(email,2)||'•••'||substr(email, position('@' in email)) else null end,
         count(*) over()
  from base order by apelido nulls last, nome
  limit greatest(coalesce(p_limit,10),1) offset greatest(coalesce(p_offset,0),0)
$$;

create or replace function aceitar_convite(p_convite uuid)
returns void language plpgsql security definer set search_path = public as $$
declare v_mesa uuid; v_user uuid;
begin
  select mesa_id, convidado_id into v_mesa, v_user
    from convites where id = p_convite and estado = 'pendente';
  if v_mesa is null then raise exception 'Convite inválido ou já respondido.'; end if;
  if v_user <> auth.uid() then raise exception 'Este convite não é seu.'; end if;
  insert into mesa_membros (mesa_id, user_id, papel) values (v_mesa, v_user, 'jogador')
    on conflict (mesa_id, user_id) do nothing;
  update convites set estado = 'aceito' where id = p_convite;
end $$;

create or replace function meus_convites()
returns table(id uuid, mesa_id uuid, mesa_nome text, mundo_nome text,
              criado_por uuid, convidado_por text, criado_em timestamptz)
language sql security definer stable set search_path = public as $$
  select c.id, c.mesa_id, me.nome, mu.nome, c.criado_por,
         coalesce(nullif(trim(pr.apelido),''), pr.nome), c.criado_em
  from convites c
  join mesas me on me.id = c.mesa_id
  join mundos mu on mu.id = me.mundo_id
  join profiles pr on pr.id = c.criado_por
  where c.convidado_id = auth.uid() and c.estado = 'pendente'
  order by c.criado_em desc
$$;

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

-- =========================================================
-- Amigos + Chat (ver migracao-amigos.sql e migracao-chat.sql).
-- Idempotente. RPCs completas estão nos arquivos de migração.
-- =========================================================
create table if not exists amizades (
  id uuid primary key default gen_random_uuid(),
  solicitante_id uuid not null references profiles(id) on delete cascade,
  destinatario_id uuid not null references profiles(id) on delete cascade,
  estado text not null default 'pendente' check (estado in ('pendente','aceita','recusada','bloqueada')),
  criado_em timestamptz default now(), atualizado_em timestamptz default now(),
  check (solicitante_id <> destinatario_id), unique (solicitante_id, destinatario_id)
);
alter table amizades enable row level security;
drop policy if exists amiz_select on amizades;
create policy amiz_select on amizades for select
  using (solicitante_id = auth.uid() or destinatario_id = auth.uid() or is_admin());

create table if not exists conversas (
  id uuid primary key default gen_random_uuid(),
  tipo text not null default 'dm' check (tipo in ('dm','grupo')),
  mesa_id uuid references mesas(id) on delete cascade,
  criado_em timestamptz default now()
);
create unique index if not exists idx_conversa_mesa on conversas(mesa_id) where mesa_id is not null;
create table if not exists conversa_membros (
  conversa_id uuid references conversas(id) on delete cascade,
  user_id uuid references profiles(id) on delete cascade,
  ultima_leitura timestamptz default now(),
  primary key (conversa_id, user_id)
);
create table if not exists mensagens (
  id uuid primary key default gen_random_uuid(),
  conversa_id uuid not null references conversas(id) on delete cascade,
  autor_id uuid not null references profiles(id) on delete cascade,
  corpo text not null, criado_em timestamptz default now()
);
create index if not exists idx_msg_conversa on mensagens(conversa_id, criado_em);

-- Gerenciamento de conversas (ver migracao-chat-gerenciar.sql). Idempotente.
alter table conversa_membros add column if not exists arquivada boolean not null default false;
alter table conversa_membros add column if not exists fixada    boolean not null default false;
alter table conversa_membros add column if not exists oculta_em timestamptz;
