-- ============================================================
-- Mares de Sangue — Amigos (contatos do jogo)
-- Idempotente. Rodar no Supabase → SQL Editor.
-- Foco: facilitar a comunicação Mestre⇄Jogador (não é rede social).
-- ============================================================

create table if not exists amizades (
  id              uuid primary key default gen_random_uuid(),
  solicitante_id  uuid not null references profiles(id) on delete cascade,
  destinatario_id uuid not null references profiles(id) on delete cascade,
  estado          text not null default 'pendente'
                  check (estado in ('pendente','aceita','recusada','bloqueada')),
  criado_em       timestamptz default now(),
  atualizado_em   timestamptz default now(),
  check (solicitante_id <> destinatario_id),
  unique (solicitante_id, destinatario_id)
);
create index if not exists idx_amizade_dest on amizades(destinatario_id, estado);
create index if not exists idx_amizade_sol  on amizades(solicitante_id, estado);

alter table amizades enable row level security;
-- cada lado vê as próprias amizades (para pintar botões/lista); escrita via RPC DEFINER
drop policy if exists amiz_select on amizades;
create policy amiz_select on amizades for select
  using (solicitante_id = auth.uid() or destinatario_id = auth.uid() or is_admin());

-- ------------------------------------------------------------
-- RPCs (SECURITY DEFINER, search_path=public)
-- ------------------------------------------------------------

-- Enviar/reativar pedido de amizade
create or replace function pedir_amizade(p_user uuid)
returns void language plpgsql security definer set search_path = public as $$
declare v_me uuid := auth.uid(); v_row amizades%rowtype; v_nome text;
begin
  if v_me is null then raise exception 'Não autenticado.'; end if;
  if p_user = v_me then raise exception 'Você não pode adicionar a si mesmo.'; end if;
  if not exists (select 1 from profiles where id = p_user) then raise exception 'Usuário inexistente.'; end if;
  select * into v_row from amizades
    where (solicitante_id = v_me and destinatario_id = p_user)
       or (solicitante_id = p_user and destinatario_id = v_me)
    limit 1;
  if v_row.id is not null then
    if v_row.estado in ('aceita','pendente') then return; end if;  -- já amigos / já pendente
    -- recusada/bloqueada → reabre como novo pedido meu
    update amizades set solicitante_id = v_me, destinatario_id = p_user,
                        estado = 'pendente', atualizado_em = now()
      where id = v_row.id;
  else
    insert into amizades (solicitante_id, destinatario_id, estado)
      values (v_me, p_user, 'pendente');
  end if;
  select coalesce(nullif(trim(apelido),''), nome, 'Alguém') into v_nome from profiles where id = v_me;
  insert into notificacoes (user_id, tipo, texto, link_tipo, link_id)
    values (p_user, 'amizade', v_nome || ' quer ser seu amigo.', null, null);
end $$;

-- Responder pedido (só o destinatário)
create or replace function responder_amizade(p_id uuid, p_aceitar boolean)
returns void language plpgsql security definer set search_path = public as $$
declare v_me uuid := auth.uid(); v_sol uuid; v_nome text;
begin
  select solicitante_id into v_sol from amizades
    where id = p_id and destinatario_id = v_me and estado = 'pendente';
  if v_sol is null then raise exception 'Pedido inválido ou já respondido.'; end if;
  update amizades set estado = case when p_aceitar then 'aceita' else 'recusada' end,
                      atualizado_em = now()
    where id = p_id;
  if p_aceitar then
    select coalesce(nullif(trim(apelido),''), nome, 'Alguém') into v_nome from profiles where id = v_me;
    insert into notificacoes (user_id, tipo, texto, link_tipo, link_id)
      values (v_sol, 'amigo_aceito', v_nome || ' aceitou seu pedido de amizade.', null, null);
  end if;
end $$;

-- Remover amizade (qualquer sentido)
create or replace function remover_amizade(p_user uuid)
returns void language plpgsql security definer set search_path = public as $$
declare v_me uuid := auth.uid();
begin
  delete from amizades
    where (solicitante_id = v_me and destinatario_id = p_user)
       or (solicitante_id = p_user and destinatario_id = v_me);
end $$;

-- Lista de amigos (amizades aceitas) — resolve o "outro lado"
create or replace function listar_amigos()
returns table(id uuid, nome text, apelido text, epiteto text, avatar_url text)
language sql security definer stable set search_path = public as $$
  select p.id, p.nome, p.apelido, p.epiteto, p.avatar_url
  from amizades a
  join profiles p on p.id = case when a.solicitante_id = auth.uid()
                                 then a.destinatario_id else a.solicitante_id end
  where a.estado = 'aceita'
    and (a.solicitante_id = auth.uid() or a.destinatario_id = auth.uid())
  order by coalesce(nullif(trim(p.apelido),''), p.nome)
$$;

-- Pedidos recebidos pendentes (dados do solicitante)
create or replace function listar_pedidos_amizade()
returns table(id uuid, solicitante_id uuid, nome text, apelido text, epiteto text, avatar_url text, criado_em timestamptz)
language sql security definer stable set search_path = public as $$
  select a.id, a.solicitante_id, p.nome, p.apelido, p.epiteto, p.avatar_url, a.criado_em
  from amizades a
  join profiles p on p.id = a.solicitante_id
  where a.destinatario_id = auth.uid() and a.estado = 'pendente'
  order by a.criado_em desc
$$;

-- Status da amizade com um usuário (para pintar botão)
create or replace function amizade_status(p_user uuid)
returns text language sql security definer stable set search_path = public as $$
  select case
    when p_user = auth.uid() then 'eu'
    when exists (select 1 from amizades a where a.estado='aceita'
        and ((a.solicitante_id=auth.uid() and a.destinatario_id=p_user)
          or (a.solicitante_id=p_user and a.destinatario_id=auth.uid()))) then 'amigos'
    when exists (select 1 from amizades a where a.estado='pendente'
        and a.solicitante_id=auth.uid() and a.destinatario_id=p_user) then 'pendente_enviado'
    when exists (select 1 from amizades a where a.estado='pendente'
        and a.solicitante_id=p_user and a.destinatario_id=auth.uid()) then 'pendente_recebido'
    else 'nenhum' end
$$;

notify pgrst, 'reload schema';
