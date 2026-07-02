-- ============================================================
-- Mares de Sangue — Gerenciamento de conversas
-- Idempotente. Rodar DEPOIS de migracao-chat.sql.
-- Estado por-usuário: arquivar, fixar, "excluir" (limpar da minha lista),
-- marcar não lida. Chat de mesa é compartilhado, então tudo é per-user
-- (guardado em conversa_membros).
-- ============================================================

alter table conversa_membros add column if not exists arquivada boolean not null default false;
alter table conversa_membros add column if not exists fixada    boolean not null default false;
-- oculta_em: "excluir/limpar" a conversa para MIM — some da lista e esconde o
-- histórico anterior; se chegar mensagem nova (criado_em > oculta_em) ela reaparece.
alter table conversa_membros add column if not exists oculta_em timestamptz;

-- ------------------------------------------------------------
-- Lista de conversas (com filtro ativas/arquivadas)
-- ------------------------------------------------------------
drop function if exists listar_conversas();
create or replace function listar_conversas(p_arquivadas boolean default false)
returns table(id uuid, tipo text, mesa_id uuid, titulo text, avatar_url text,
              outro_id uuid, ultima_msg text, ultima_em timestamptz, nao_lidas integer,
              arquivada boolean, fixada boolean)
language sql stable security definer set search_path = public as $$
  with convs as (
    select c.id, c.tipo, c.mesa_id, c.criado_em,
           coalesce(cm.ultima_leitura, c.criado_em) as lida,
           coalesce(cm.arquivada, false) as arquivada,
           coalesce(cm.fixada, false) as fixada,
           cm.oculta_em
    from conversas c
    left join conversa_membros cm on cm.conversa_id = c.id and cm.user_id = auth.uid()
    where exists (select 1 from conversa_membros m where m.conversa_id = c.id and m.user_id = auth.uid())
       or exists (select 1 from mesa_membros mm where mm.mesa_id = c.mesa_id and mm.user_id = auth.uid())
  ),
  ult as (
    select distinct on (m.conversa_id) m.conversa_id, m.corpo, m.criado_em
    from mensagens m
    where m.conversa_id in (select id from convs)
    order by m.conversa_id, m.criado_em desc
  ),
  outro as (
    select cm.conversa_id, cm.user_id
    from conversa_membros cm
    where cm.conversa_id in (select id from convs where tipo = 'dm')
      and cm.user_id <> auth.uid()
  )
  select convs.id, convs.tipo, convs.mesa_id,
    case when convs.tipo = 'grupo' then coalesce(me.nome, 'Mesa')
         else coalesce(nullif(trim(pr.apelido),''), pr.nome, 'Conversa') end,
    case when convs.tipo = 'dm' then pr.avatar_url else null end,
    o.user_id,
    ult.corpo, ult.criado_em,
    (select count(*)::int from mensagens mm
       where mm.conversa_id = convs.id
         and mm.criado_em > greatest(convs.lida, convs.oculta_em)
         and mm.autor_id <> auth.uid()),
    convs.arquivada, convs.fixada
  from convs
  left join ult on ult.conversa_id = convs.id
  left join outro o on o.conversa_id = convs.id
  left join profiles pr on pr.id = o.user_id
  left join mesas me on me.id = convs.mesa_id
  where convs.arquivada = coalesce(p_arquivadas, false)
    and (convs.oculta_em is null
         or exists (select 1 from mensagens mm where mm.conversa_id = convs.id and mm.criado_em > convs.oculta_em))
  order by convs.fixada desc, coalesce(ult.criado_em, convs.criado_em) desc
$$;

-- ------------------------------------------------------------
-- Badge: não lidas (exclui arquivadas e histórico oculto)
-- ------------------------------------------------------------
create or replace function nao_lidas_total() returns integer
language sql stable security definer set search_path = public as $$
  with convs as (
    select c.id,
           coalesce(cm.ultima_leitura, c.criado_em) as lida,
           coalesce(cm.arquivada, false) as arquivada,
           cm.oculta_em
    from conversas c
    left join conversa_membros cm on cm.conversa_id = c.id and cm.user_id = auth.uid()
    where exists (select 1 from conversa_membros m where m.conversa_id = c.id and m.user_id = auth.uid())
       or exists (select 1 from mesa_membros mm where mm.mesa_id = c.mesa_id and mm.user_id = auth.uid())
  )
  select coalesce(count(msg.id), 0)::int
  from convs
  join mensagens msg on msg.conversa_id = convs.id
   and msg.criado_em > greatest(convs.lida, convs.oculta_em)
   and msg.autor_id <> auth.uid()
  where convs.arquivada = false
$$;

-- ------------------------------------------------------------
-- Ações de gerenciamento (upsert do estado per-user)
-- ------------------------------------------------------------
create or replace function arquivar_conversa(p_conversa uuid, p_arquivar boolean) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not is_membro_conversa(p_conversa) then raise exception 'Sem acesso a esta conversa.'; end if;
  insert into conversa_membros (conversa_id, user_id, arquivada)
    values (p_conversa, auth.uid(), coalesce(p_arquivar,true))
  on conflict (conversa_id, user_id) do update set arquivada = coalesce(p_arquivar,true);
end $$;

create or replace function fixar_conversa(p_conversa uuid, p_fixar boolean) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not is_membro_conversa(p_conversa) then raise exception 'Sem acesso a esta conversa.'; end if;
  insert into conversa_membros (conversa_id, user_id, fixada)
    values (p_conversa, auth.uid(), coalesce(p_fixar,true))
  on conflict (conversa_id, user_id) do update set fixada = coalesce(p_fixar,true);
end $$;

-- "Excluir" para mim = limpa da lista e esconde histórico até agora
create or replace function excluir_conversa(p_conversa uuid) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not is_membro_conversa(p_conversa) then raise exception 'Sem acesso a esta conversa.'; end if;
  insert into conversa_membros (conversa_id, user_id, oculta_em, arquivada, ultima_leitura)
    values (p_conversa, auth.uid(), now(), false, now())
  on conflict (conversa_id, user_id) do update set oculta_em = now(), arquivada = false, ultima_leitura = now();
end $$;

create or replace function marcar_nao_lida(p_conversa uuid) returns void
language plpgsql security definer set search_path = public as $$
declare v_ts timestamptz;
begin
  if not is_membro_conversa(p_conversa) then raise exception 'Sem acesso a esta conversa.'; end if;
  select max(criado_em) into v_ts from mensagens
    where conversa_id = p_conversa and autor_id <> auth.uid();
  if v_ts is null then return; end if;
  insert into conversa_membros (conversa_id, user_id, ultima_leitura)
    values (p_conversa, auth.uid(), v_ts - interval '1 second')
  on conflict (conversa_id, user_id) do update set ultima_leitura = v_ts - interval '1 second';
end $$;

notify pgrst, 'reload schema';
