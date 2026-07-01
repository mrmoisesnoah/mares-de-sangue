-- ============================================================
-- Migração — Área de usuários: apelido, busca e convites
-- (Fase 1 identidade + Fase 2 busca do mestre + Fase 3 convites)
-- Idempotente. Rodar no Supabase > SQL Editor.
-- ============================================================

-- ---------- Fase 1: apelido (nome de exibição) ----------
alter table profiles add column if not exists apelido text;
create index if not exists idx_profiles_apelido on profiles (lower(apelido));

-- ---------- Fase 2: busca de usuários pelo mestre ----------
-- Regras de privacidade:
--   * e-mail: só MATCH EXATO (você precisa já conhecê-lo) e NUNCA é retornado.
--   * apelido/nome: busca por prefixo (como um @usuário).
-- Retorna no máximo 20 e só para usuários autenticados.
create or replace function buscar_usuarios(termo text)
returns table(id uuid, nome text, apelido text, avatar_url text)
language sql security definer stable set search_path = public as $$
  select p.id, p.nome, p.apelido, p.avatar_url
  from profiles p
  join auth.users u on u.id = p.id
  where auth.uid() is not null
    and (
      case when position('@' in termo) > 0
        then lower(u.email) = lower(trim(termo))                          -- e-mail exato
        else ( p.apelido ilike trim(termo) || '%'
               or p.nome  ilike trim(termo) || '%' )                      -- prefixo
      end
    )
  order by p.apelido nulls last, p.nome
  limit 20
$$;
revoke all on function buscar_usuarios(text) from anon;
grant execute on function buscar_usuarios(text) to authenticated;

-- ---------- Fase 3: convites (mestre -> jogador) ----------
create table if not exists convites (
  id            uuid primary key default gen_random_uuid(),
  mesa_id       uuid not null references mesas(id) on delete cascade,
  convidado_id  uuid not null references profiles(id) on delete cascade,
  criado_por    uuid not null references profiles(id),
  estado        text not null default 'pendente' check (estado in ('pendente','aceito','recusado')),
  criado_em     timestamptz not null default now(),
  unique (mesa_id, convidado_id)
);
create index if not exists idx_convites_convidado on convites(convidado_id);
create index if not exists idx_convites_mesa on convites(mesa_id);

alter table convites enable row level security;

-- Vê: o próprio convidado, o mestre da mesa, o admin.
drop policy if exists conv_select on convites;
create policy conv_select on convites for select using (
  convidado_id = auth.uid() or is_mestre(mesa_id) or is_admin()
);
-- Cria: só o mestre da mesa (ou admin), sempre como autor.
drop policy if exists conv_insert on convites;
create policy conv_insert on convites for insert with check (
  criado_por = auth.uid() and (is_mestre(mesa_id) or is_admin())
);
-- Atualiza: o convidado (aceitar/recusar o próprio) ou o mestre/admin.
drop policy if exists conv_update on convites;
create policy conv_update on convites for update using (
  convidado_id = auth.uid() or is_mestre(mesa_id) or is_admin()
);
-- Apaga (cancelar): só o mestre da mesa ou admin.
drop policy if exists conv_delete on convites;
create policy conv_delete on convites for delete using (
  is_mestre(mesa_id) or is_admin()
);

-- Aceitar convite: insere em mesa_membros (o jogador não tem permissão direta
-- de inserir lá — só o mestre — por isso via SECURITY DEFINER).
create or replace function aceitar_convite(p_convite uuid)
returns void language plpgsql security definer set search_path = public as $$
declare v_mesa uuid; v_user uuid;
begin
  select mesa_id, convidado_id into v_mesa, v_user
  from convites where id = p_convite and estado = 'pendente';
  if v_mesa is null then
    raise exception 'Convite inválido ou já respondido.';
  end if;
  if v_user <> auth.uid() then
    raise exception 'Este convite não é seu.';
  end if;
  insert into mesa_membros (mesa_id, user_id, papel)
    values (v_mesa, v_user, 'jogador')
    on conflict (mesa_id, user_id) do nothing;
  update convites set estado = 'aceito' where id = p_convite;
end $$;
revoke all on function aceitar_convite(uuid) from anon;
grant execute on function aceitar_convite(uuid) to authenticated;

-- Lista os convites pendentes do usuário logado, JÁ com nome da mesa/mundo e
-- de quem convidou (o convidado ainda não é membro, então não enxerga a mesa
-- pela RLS — por isso a função SECURITY DEFINER resolve os nomes).
create or replace function meus_convites()
returns table(id uuid, mesa_id uuid, mesa_nome text, mundo_nome text,
              criado_por uuid, convidado_por text, criado_em timestamptz)
language sql security definer stable set search_path = public as $$
  select c.id, c.mesa_id, me.nome, mu.nome,
         c.criado_por, coalesce(nullif(trim(pr.apelido),''), pr.nome),
         c.criado_em
  from convites c
  join mesas me   on me.id = c.mesa_id
  join mundos mu  on mu.id = me.mundo_id
  join profiles pr on pr.id = c.criado_por
  where c.convidado_id = auth.uid() and c.estado = 'pendente'
  order by c.criado_em desc
$$;
revoke all on function meus_convites() from anon;
grant execute on function meus_convites() to authenticated;

-- PostgREST: recarregar o cache de esquema (senão rpc() dá PGRST202).
notify pgrst, 'reload schema';
