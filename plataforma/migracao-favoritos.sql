-- Migração: Favoritos (acesso rápido pessoal)
-- Cada usuário marca conteúdos como favoritos. Só o próprio usuário vê/edita seus favoritos.
create table if not exists favoritos (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  mundo_id uuid references mundos(id) on delete cascade,
  tipo text not null,            -- 'publicacao' | 'personagem' | 'jornal' | 'mesa' | 'mundo'
  alvo_id uuid not null,
  titulo text,
  criado_em timestamptz not null default now(),
  unique (user_id, tipo, alvo_id)
);

alter table favoritos enable row level security;

drop policy if exists fav_select on favoritos;
create policy fav_select on favoritos for select using (user_id = auth.uid());

drop policy if exists fav_insert on favoritos;
create policy fav_insert on favoritos for insert with check (user_id = auth.uid());

drop policy if exists fav_delete on favoritos;
create policy fav_delete on favoritos for delete using (user_id = auth.uid());
