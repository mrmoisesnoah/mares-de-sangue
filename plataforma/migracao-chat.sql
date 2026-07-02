-- ============================================================
-- Mares de Sangue — Chat (conversas de mesa + mensagens diretas)
-- Idempotente. Rodar DEPOIS de migracao-amigos.sql.
-- Chat de mesa reaproveita mesa_membros; DM só entre amigos.
-- Entrega faseada: DM/grupo assíncrono + polling no front (sem Realtime por ora).
-- ============================================================

create table if not exists conversas (
  id        uuid primary key default gen_random_uuid(),
  tipo      text not null default 'dm' check (tipo in ('dm','grupo')),
  mesa_id   uuid references mesas(id) on delete cascade,
  criado_em timestamptz default now()
);
-- uma única conversa de grupo por mesa
create unique index if not exists idx_conversa_mesa on conversas(mesa_id) where mesa_id is not null;

create table if not exists conversa_membros (
  conversa_id    uuid references conversas(id) on delete cascade,
  user_id        uuid references profiles(id) on delete cascade,
  ultima_leitura timestamptz default now(),
  primary key (conversa_id, user_id)
);

create table if not exists mensagens (
  id          uuid primary key default gen_random_uuid(),
  conversa_id uuid not null references conversas(id) on delete cascade,
  autor_id    uuid not null references profiles(id) on delete cascade,
  corpo       text not null,
  criado_em   timestamptz default now()
);
create index if not exists idx_msg_conversa on mensagens(conversa_id, criado_em);

-- Membro de conversa = tem linha em conversa_membros OU é membro da mesa (chat de grupo)
create or replace function is_membro_conversa(p_conversa uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from conversa_membros cm
                 where cm.conversa_id = p_conversa and cm.user_id = auth.uid())
      or exists (select 1 from conversas c
                 join mesa_membros mm on mm.mesa_id = c.mesa_id
                 where c.id = p_conversa and mm.user_id = auth.uid());
$$;

alter table conversas        enable row level security;
alter table conversa_membros enable row level security;
alter table mensagens        enable row level security;

drop policy if exists conv_select on conversas;
create policy conv_select on conversas for select using (is_membro_conversa(id) or is_admin());

drop policy if exists convm_select on conversa_membros;
create policy convm_select on conversa_membros for select using (is_membro_conversa(conversa_id) or is_admin());
drop policy if exists convm_update on conversa_membros;
create policy convm_update on conversa_membros for update using (user_id = auth.uid());

drop policy if exists msg_select on mensagens;
create policy msg_select on mensagens for select using (is_membro_conversa(conversa_id) or is_admin());
drop policy if exists msg_insert on mensagens;
create policy msg_insert on mensagens for insert with check (autor_id = auth.uid() and is_membro_conversa(conversa_id));
drop policy if exists msg_delete on mensagens;
create policy msg_delete on mensagens for delete using (autor_id = auth.uid() or is_admin());

-- ------------------------------------------------------------
-- RPCs
-- ------------------------------------------------------------

-- Abrir (ou obter) DM entre auth.uid() e p_user — só entre amigos
create or replace function abrir_conversa_dm(p_user uuid) returns uuid
language plpgsql security definer set search_path = public as $$
declare v_me uuid := auth.uid(); v_id uuid;
begin
  if p_user = v_me then raise exception 'Conversa consigo mesmo não é permitida.'; end if;
  if not exists (select 1 from amizades a where a.estado = 'aceita'
      and ((a.solicitante_id = v_me and a.destinatario_id = p_user)
        or (a.solicitante_id = p_user and a.destinatario_id = v_me)))
  then raise exception 'Vocês precisam ser amigos para conversar.'; end if;
  select c.id into v_id from conversas c
    where c.tipo = 'dm'
      and exists (select 1 from conversa_membros m where m.conversa_id = c.id and m.user_id = v_me)
      and exists (select 1 from conversa_membros m where m.conversa_id = c.id and m.user_id = p_user)
    limit 1;
  if v_id is null then
    insert into conversas (tipo) values ('dm') returning id into v_id;
    insert into conversa_membros (conversa_id, user_id) values (v_id, v_me), (v_id, p_user)
      on conflict do nothing;
  end if;
  return v_id;
end $$;

-- Abrir (ou obter) a conversa de grupo da mesa — só membros da mesa
create or replace function abrir_conversa_mesa(p_mesa uuid) returns uuid
language plpgsql security definer set search_path = public as $$
declare v_me uuid := auth.uid(); v_id uuid;
begin
  if not exists (select 1 from mesa_membros mm where mm.mesa_id = p_mesa and mm.user_id = v_me)
  then raise exception 'Você não é membro desta mesa.'; end if;
  select id into v_id from conversas where mesa_id = p_mesa limit 1;
  if v_id is null then
    insert into conversas (tipo, mesa_id) values ('grupo', p_mesa) returning id into v_id;
  end if;
  insert into conversa_membros (conversa_id, user_id) values (v_id, v_me) on conflict do nothing;
  return v_id;
end $$;

-- Marcar conversa como lida (upsert do read-state)
create or replace function marcar_lida(p_conversa uuid) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not is_membro_conversa(p_conversa) then return; end if;
  insert into conversa_membros (conversa_id, user_id, ultima_leitura)
    values (p_conversa, auth.uid(), now())
  on conflict (conversa_id, user_id) do update set ultima_leitura = now();
end $$;

-- Total de mensagens não lidas (para o badge)
create or replace function nao_lidas_total() returns integer
language sql stable security definer set search_path = public as $$
  with convs as (
    select c.id, coalesce(cm.ultima_leitura, c.criado_em) as lida
    from conversas c
    left join conversa_membros cm on cm.conversa_id = c.id and cm.user_id = auth.uid()
    where exists (select 1 from conversa_membros m where m.conversa_id = c.id and m.user_id = auth.uid())
       or exists (select 1 from mesa_membros mm where mm.mesa_id = c.mesa_id and mm.user_id = auth.uid())
  )
  select coalesce(count(msg.id), 0)::int
  from convs
  join mensagens msg on msg.conversa_id = convs.id
   and msg.criado_em > convs.lida and msg.autor_id <> auth.uid()
$$;

-- Lista de conversas do usuário (com último trecho + não lidas)
create or replace function listar_conversas()
returns table(id uuid, tipo text, mesa_id uuid, titulo text, avatar_url text,
              outro_id uuid, ultima_msg text, ultima_em timestamptz, nao_lidas integer)
language sql stable security definer set search_path = public as $$
  with convs as (
    select c.id, c.tipo, c.mesa_id, c.criado_em,
           coalesce(cm.ultima_leitura, c.criado_em) as lida
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
       where mm.conversa_id = convs.id and mm.criado_em > convs.lida and mm.autor_id <> auth.uid())
  from convs
  left join ult on ult.conversa_id = convs.id
  left join outro o on o.conversa_id = convs.id
  left join profiles pr on pr.id = o.user_id
  left join mesas me on me.id = convs.mesa_id
  order by coalesce(ult.criado_em, convs.criado_em) desc
$$;

notify pgrst, 'reload schema';
