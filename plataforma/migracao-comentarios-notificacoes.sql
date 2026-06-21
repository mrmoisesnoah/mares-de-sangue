-- Migração: Comentários + Notificações

-- Comentários em publicações, personagens e jornais
create table if not exists comentarios (
  id uuid primary key default gen_random_uuid(),
  mundo_id uuid references mundos(id) on delete cascade,
  alvo_tipo text not null,            -- 'publicacao' | 'personagem' | 'jornal'
  alvo_id uuid not null,
  autor_id uuid not null references auth.users(id) on delete cascade,
  corpo text not null,
  criado_em timestamptz not null default now()
);
create index if not exists comentarios_alvo_idx on comentarios(alvo_tipo, alvo_id);
alter table comentarios enable row level security;
drop policy if exists com_select on comentarios;
create policy com_select on comentarios for select using (true);
drop policy if exists com_insert on comentarios;
create policy com_insert on comentarios for insert with check (autor_id = auth.uid());
drop policy if exists com_delete on comentarios;
create policy com_delete on comentarios for delete using (autor_id = auth.uid() or is_admin());

-- Notificações (pedidos de acesso, comentários)
create table if not exists notificacoes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,   -- destinatário
  tipo text not null,                 -- 'comentario' | 'pedido'
  texto text not null,
  link_tipo text,
  link_id uuid,
  lida boolean not null default false,
  criado_em timestamptz not null default now()
);
create index if not exists notificacoes_user_idx on notificacoes(user_id, lida);
alter table notificacoes enable row level security;
drop policy if exists not_select on notificacoes;
create policy not_select on notificacoes for select using (user_id = auth.uid());
drop policy if exists not_insert on notificacoes;
create policy not_insert on notificacoes for insert with check (auth.uid() is not null);
drop policy if exists not_update on notificacoes;
create policy not_update on notificacoes for update using (user_id = auth.uid());
drop policy if exists not_delete on notificacoes;
create policy not_delete on notificacoes for delete using (user_id = auth.uid());
