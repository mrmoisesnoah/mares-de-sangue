-- =====================================================================
-- Mares de Sangue — Esquema da plataforma (Supabase / PostgreSQL)
-- Fase 5: plataforma dinâmica (login, mundos, mesas, personagens,
-- publicações com tipo e visibilidade). Cole no SQL Editor do Supabase.
-- Filosofia: simples, extensível, sem complexidade prematura.
-- =====================================================================

-- ---------- PERFIS (estende auth.users) ----------
create table if not exists perfis (
  id          uuid primary key references auth.users on delete cascade,
  nome        text not null,
  bio         text,
  avatar_url  text,
  criado_em   timestamptz not null default now()
);

-- ---------- MUNDOS (cenários) ----------
create table if not exists mundos (
  id          uuid primary key default gen_random_uuid(),
  nome        text not null,
  slug        text unique not null,
  descricao   text,
  capa_url    text,
  dono_id     uuid not null references auth.users,
  publico     boolean not null default true,  -- enciclopédia aberta a não-membros?
  criado_em   timestamptz not null default now()
);

create table if not exists mundo_membros (
  mundo_id    uuid references mundos on delete cascade,
  user_id     uuid references auth.users on delete cascade,
  papel       text not null check (papel in ('admin','mestre','jogador')),
  primary key (mundo_id, user_id)
);

-- ---------- MESAS (campanhas dentro de um mundo) ----------
create table if not exists mesas (
  id          uuid primary key default gen_random_uuid(),
  mundo_id    uuid not null references mundos on delete cascade,
  nome        text not null,
  slug        text not null,
  descricao   text,
  mestre_id   uuid not null references auth.users,
  criado_em   timestamptz not null default now(),
  unique (mundo_id, slug)
);

create table if not exists mesa_membros (
  mesa_id     uuid references mesas on delete cascade,
  user_id     uuid references auth.users on delete cascade,
  papel       text not null check (papel in ('mestre','jogador')),
  primary key (mesa_id, user_id)
);

-- ---------- TIPOS DE PUBLICAÇÃO (extensível, sem mudar o schema) ----------
create table if not exists tipos (
  slug        text primary key,         -- ex.: 'regiao', 'sessao', 'cronica'
  nome        text not null,            -- ex.: 'Região'
  grupo       text,                     -- ex.: 'Mundo', 'Mesa', 'Personagem'
  icone       text
);

-- ---------- PUBLICAÇÕES (tudo é uma publicação) ----------
create table if not exists publicacoes (
  id            uuid primary key default gen_random_uuid(),
  mundo_id      uuid not null references mundos on delete cascade,
  mesa_id       uuid references mesas on delete set null,        -- opcional
  personagem_id uuid references publicacoes on delete set null, -- opcional (ligação a um personagem)
  autor_id      uuid not null references auth.users,
  tipo          text not null references tipos(slug),
  titulo        text not null,
  slug          text not null,
  corpo         text,                    -- Markdown
  resumo        text,
  categoria     text,
  tags          text[] not null default '{}',
  estado        text not null default 'rascunho' check (estado in ('rascunho','publicado')),
  visibilidade  text not null default 'privado'
                check (visibilidade in ('publico','mesa','mestre_jogador','privado')),
  criado_em     timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
create index if not exists idx_pub_mundo on publicacoes(mundo_id);
create index if not exists idx_pub_mesa  on publicacoes(mesa_id);
create index if not exists idx_pub_tipo  on publicacoes(tipo);
create index if not exists idx_pub_tags  on publicacoes using gin(tags);

-- ---------- RELAÇÕES ENTRE PUBLICAÇÕES (links / "Veja também") ----------
create table if not exists publicacao_relacoes (
  origem_id   uuid references publicacoes on delete cascade,
  destino_id  uuid references publicacoes on delete cascade,
  rotulo      text,
  primary key (origem_id, destino_id)
);

-- ---------- MÍDIAS (imagens/vídeos: link externo ou arquivo no Storage) ----------
create table if not exists midias (
  id            uuid primary key default gen_random_uuid(),
  publicacao_id uuid references publicacoes on delete cascade,
  tipo          text not null check (tipo in ('imagem','video','link','arquivo')),
  url           text,            -- link externo (YouTube, imagem hospedada, etc.)
  storage_path  text,            -- caminho no Supabase Storage (arquivo enviado)
  legenda       text,
  autor_id      uuid references auth.users,
  criado_em     timestamptz not null default now()
);

-- =====================================================================
-- FUNÇÕES AUXILIARES (security definer — evitam recursão de RLS)
-- =====================================================================
create or replace function is_mundo_membro(m uuid) returns boolean
  language sql security definer stable as $$
  select exists(select 1 from mundo_membros where mundo_id = m and user_id = auth.uid());
$$;

create or replace function is_mundo_admin(m uuid) returns boolean
  language sql security definer stable as $$
  select exists(select 1 from mundo_membros where mundo_id = m and user_id = auth.uid() and papel = 'admin');
$$;

create or replace function is_mesa_membro(t uuid) returns boolean
  language sql security definer stable as $$
  select exists(select 1 from mesa_membros where mesa_id = t and user_id = auth.uid());
$$;

create or replace function is_mesa_mestre(t uuid) returns boolean
  language sql security definer stable as $$
  select exists(select 1 from mesa_membros where mesa_id = t and user_id = auth.uid() and papel = 'mestre');
$$;

-- =====================================================================
-- RLS — Segurança por linha
-- =====================================================================
alter table perfis              enable row level security;
alter table mundos              enable row level security;
alter table mundo_membros       enable row level security;
alter table mesas               enable row level security;
alter table mesa_membros        enable row level security;
alter table publicacoes         enable row level security;
alter table publicacao_relacoes enable row level security;
alter table midias              enable row level security;
alter table tipos               enable row level security;

-- Perfis: leitura pública; cada um edita o seu
create policy perfis_ler   on perfis for select using (true);
create policy perfis_meu   on perfis for all using (auth.uid() = id) with check (auth.uid() = id);

-- Tipos: leitura para todos; escrita só admin de algum mundo (simplificação: autenticado)
create policy tipos_ler    on tipos for select using (true);
create policy tipos_editar on tipos for all using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

-- Mundos: visíveis se públicos ou se você é membro; só o dono/admin edita
create policy mundos_ler   on mundos for select using (publico or is_mundo_membro(id));
create policy mundos_criar on mundos for insert with check (auth.uid() = dono_id);
create policy mundos_editar on mundos for update using (is_mundo_admin(id) or auth.uid() = dono_id);

-- Membros do mundo: visíveis a membros; gerenciados pelo admin
create policy mundo_membros_ler on mundo_membros for select using (is_mundo_membro(mundo_id));
create policy mundo_membros_adm on mundo_membros for all using (is_mundo_admin(mundo_id)) with check (is_mundo_admin(mundo_id));

-- Mesas: visíveis a membros do mundo; criadas/editadas pelo mestre
create policy mesas_ler    on mesas for select using (is_mundo_membro(mundo_id) or is_mesa_membro(id));
create policy mesas_criar  on mesas for insert with check (auth.uid() = mestre_id and is_mundo_membro(mundo_id));
create policy mesas_editar on mesas for update using (auth.uid() = mestre_id or is_mundo_admin(mundo_id));

create policy mesa_membros_ler on mesa_membros for select using (is_mesa_membro(mesa_id));
create policy mesa_membros_adm on mesa_membros for all using (is_mesa_mestre(mesa_id)) with check (is_mesa_mestre(mesa_id));

-- PUBLICAÇÕES — o coração da visibilidade
create policy publicacoes_ler on publicacoes for select using (
  auth.uid() = autor_id                                  -- autor vê o próprio (inclui rascunho)
  or ( estado = 'publicado' and (
        visibilidade = 'publico'
     or (visibilidade = 'mesa' and mesa_id is not null and is_mesa_membro(mesa_id))
     or (visibilidade = 'mesa' and mesa_id is null and is_mundo_membro(mundo_id))
     or (visibilidade = 'mestre_jogador' and mesa_id is not null and is_mesa_mestre(mesa_id))
  ))
);
create policy publicacoes_criar on publicacoes for insert
  with check (auth.uid() = autor_id and is_mundo_membro(mundo_id));
create policy publicacoes_editar on publicacoes for update using (
  auth.uid() = autor_id
  or (mesa_id is not null and is_mesa_mestre(mesa_id))
  or is_mundo_admin(mundo_id)
);
create policy publicacoes_apagar on publicacoes for delete using (
  auth.uid() = autor_id or is_mundo_admin(mundo_id)
);

-- Relações e mídias: seguem a publicação de origem (visível => acessível)
create policy relacoes_ler on publicacao_relacoes for select using (
  exists (select 1 from publicacoes p where p.id = origem_id)
);
create policy relacoes_edit on publicacao_relacoes for all using (
  exists (select 1 from publicacoes p where p.id = origem_id and (p.autor_id = auth.uid() or is_mundo_admin(p.mundo_id)))
);
create policy midias_ler on midias for select using (
  publicacao_id is null or exists (select 1 from publicacoes p where p.id = publicacao_id)
);
create policy midias_edit on midias for all using (auth.uid() = autor_id) with check (auth.uid() = autor_id);

-- =====================================================================
-- TIPOS INICIAIS (sementes) — novos tipos podem ser adicionados depois
-- =====================================================================
insert into tipos (slug, nome, grupo) values
  ('historia_mundo','História do mundo','Mundo'),
  ('era','Era','Mundo'),
  ('regiao','Região','Mundo'),
  ('reino','Reino','Mundo'),
  ('cidade','Cidade','Mundo'),
  ('faccao','Facção','Mundo'),
  ('religiao','Religião','Mundo'),
  ('criatura','Criatura','Mundo'),
  ('item','Item','Mundo'),
  ('evento','Evento histórico','Mundo'),
  ('personagem','Personagem','Personagem'),
  ('background','Background','Personagem'),
  ('diario','Diário de personagem','Personagem'),
  ('familia','Família','Mundo'),
  ('cla','Clã','Mundo'),
  ('organizacao','Organização','Mundo'),
  ('local','Local','Mundo'),
  ('planejamento','Planejamento do mestre','Mesa'),
  ('sessao','Sessão','Mesa'),
  ('cronica','Crônica','Mesa'),
  ('resumo','Resumo de sessão','Mesa'),
  ('conto','Conto','Mundo'),
  ('jornal','Jornal','Mundo'),
  ('anotacao','Anotação privada','Pessoal')
on conflict (slug) do nothing;
