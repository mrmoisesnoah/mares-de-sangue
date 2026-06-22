-- Exclusão de MUNDOS e MESAS por admin (ou dono/mestre), com cascata server-side.
-- Funções SECURITY DEFINER: executam como dono do banco (ignoram RLS), mas só após checar permissão.

create or replace function excluir_mundo(p_id uuid) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not (is_admin() or exists (select 1 from mundos where id = p_id and dono_id = auth.uid())) then
    raise exception 'sem permissão para excluir este mundo';
  end if;
  delete from mural_pins   where mesa_id in (select id from mesas where mundo_id = p_id);
  delete from evento_links where evento_id in (select id from eventos where mundo_id = p_id);
  delete from recompensas  where mesa_id in (select id from mesas where mundo_id = p_id);
  delete from sessoes      where mesa_id in (select id from mesas where mundo_id = p_id);
  delete from mesa_membros where mesa_id in (select id from mesas where mundo_id = p_id);
  delete from eventos      where mundo_id = p_id;
  delete from periodos     where mundo_id = p_id;
  delete from comentarios  where mundo_id = p_id;
  delete from favoritos    where mundo_id = p_id;
  delete from publicacoes  where mundo_id = p_id;
  delete from personagens  where mundo_id = p_id;
  delete from jornais      where mundo_id = p_id;
  delete from mesas        where mundo_id = p_id;
  delete from mundos       where id = p_id;
end $$;

create or replace function excluir_mesa(p_id uuid) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not (is_admin() or exists (select 1 from mesas where id = p_id and mestre_id = auth.uid())) then
    raise exception 'sem permissão para excluir esta mesa';
  end if;
  delete from mural_pins   where mesa_id = p_id;
  delete from recompensas  where mesa_id = p_id;
  delete from sessoes      where mesa_id = p_id;
  delete from mesa_membros where mesa_id = p_id;
  delete from eventos      where mesa_id = p_id;
  delete from periodos     where mesa_id = p_id;
  delete from publicacoes  where mesa_id = p_id;
  delete from personagens  where mesa_id = p_id;
  delete from mesas        where id = p_id;
end $$;

grant execute on function excluir_mundo(uuid) to authenticated;
grant execute on function excluir_mesa(uuid)  to authenticated;
