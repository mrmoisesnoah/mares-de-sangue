-- =========================================================
-- Migração: Painel de Administração + tiers de admin (super-admin)
-- + configuração global do site (site_config)
-- Idempotente. Rodar no Supabase → SQL Editor.
-- =========================================================

-- 1) Tiers de papel global: superadmin > admin > usuario
alter table profiles drop constraint if exists profiles_papel_global_check;
alter table profiles add constraint profiles_papel_global_check
  check (papel_global in ('superadmin','admin','usuario'));

-- Dono/fundador (Moisés) vira super-admin
update profiles set papel_global='superadmin'
  where id='c3ed4547-f032-47f6-8650-360684451acc';

-- 2) Funções de permissão
create or replace function is_superadmin() returns boolean
language sql stable security definer set search_path=public as $$
  select exists(select 1 from profiles p where p.id=auth.uid() and p.papel_global='superadmin');
$$;

-- is_admin agora abrange admin E superadmin (edição/moderação = ambos os tiers)
create or replace function is_admin() returns boolean
language sql stable security definer set search_path=public as $$
  select exists(select 1 from profiles p where p.id=auth.uid() and p.papel_global in ('admin','superadmin'));
$$;

-- 3) Configuração global do site (linha única id=1)
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
-- sem insert/delete via API: a linha única já foi semeada acima.

-- 4) RPCs de administração (SECURITY DEFINER, gated)

-- 4a) Estatísticas do painel (admin)
create or replace function admin_estatisticas()
returns json language plpgsql stable security definer set search_path=public as $$
declare j json;
begin
  if not is_admin() then raise exception 'Acesso negado'; end if;
  select json_build_object(
    'usuarios',    (select count(*) from profiles),
    'admins',      (select count(*) from profiles where papel_global in ('admin','superadmin')),
    'mundos',      (select count(*) from mundos),
    'mundos_pub',  (select count(*) from mundos where publico),
    'mesas',       (select count(*) from mesas),
    'publicacoes', (select count(*) from publicacoes),
    'personagens', (select count(*) from personagens)
  ) into j;
  return j;
end $$;

-- 4b) Listar/buscar usuários (admin vê; e-mail sempre MASCARADO)
drop function if exists admin_listar_usuarios(text, int, int);
create or replace function admin_listar_usuarios(termo text default '', p_limit int default 20, p_offset int default 0)
returns table(id uuid, nome text, apelido text, epiteto text, avatar_url text,
              papel_global text, email_mascara text, criado timestamptz, total bigint)
language plpgsql stable security definer set search_path=public as $$
begin
  if not is_admin() then raise exception 'Acesso negado'; end if;
  return query
  select p.id, p.nome, p.apelido, p.epiteto, p.avatar_url, p.papel_global,
    (case when u.email is null then null
      else left(u.email,2)||'•••@'||split_part(u.email,'@',2) end) as email_mascara,
    u.created_at,
    count(*) over() as total
  from profiles p
  left join auth.users u on u.id = p.id
  where termo = ''
     or p.apelido ilike termo||'%'
     or p.nome    ilike termo||'%'
     or u.email   ilike termo||'%'
  order by u.created_at desc nulls last
  limit greatest(1, least(p_limit, 50))
  offset greatest(0, p_offset);
end $$;

-- 4c) Definir papel (promover/rebaixar) — SUPER-ADMIN apenas
create or replace function admin_definir_papel(p_user uuid, p_papel text)
returns void language plpgsql security definer set search_path=public as $$
begin
  if not is_superadmin() then raise exception 'Apenas super-admin pode alterar papéis'; end if;
  if p_papel not in ('admin','usuario') then raise exception 'Papel inválido'; end if;
  if p_user = auth.uid() then raise exception 'Não é possível alterar o próprio papel'; end if;
  if exists(select 1 from profiles where id=p_user and papel_global='superadmin') then
    raise exception 'Não é possível alterar um super-admin';
  end if;
  update profiles set papel_global=p_papel where id=p_user;
end $$;

notify pgrst, 'reload schema';
