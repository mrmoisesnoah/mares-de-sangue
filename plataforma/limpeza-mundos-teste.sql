-- Limpeza: remover os 4 mundos de TESTE (e tudo que pertence a eles).
-- Rodar no Supabase → SQL Editor (executa como admin, ignora RLS).
-- Mundos: 2x "Novo mundo - teste" + 2x "HORROR TESTE".
do $$
declare wids uuid[] := array[
  '928012fa-e889-4666-b566-938ab23c27cc',
  '5b710832-b808-480d-b855-fc7d61c2cbfb',
  '9759215c-57cb-4ff5-93c3-a63fa321dd9f',
  '25578b86-c97b-4ee7-a34b-aacbc210d51c'
]::uuid[];
begin
  delete from evento_links where evento_id in (select id from eventos where mundo_id = any(wids));
  delete from eventos    where mundo_id = any(wids);
  delete from periodos   where mundo_id = any(wids);
  delete from comentarios where mundo_id = any(wids);
  delete from favoritos  where mundo_id = any(wids);
  delete from recompensas where mesa_id in (select id from mesas where mundo_id = any(wids));
  delete from sessoes     where mesa_id in (select id from mesas where mundo_id = any(wids));
  delete from mesa_membros where mesa_id in (select id from mesas where mundo_id = any(wids));
  delete from publicacoes where mundo_id = any(wids);
  delete from personagens where mundo_id = any(wids);
  delete from jornais     where mundo_id = any(wids);
  delete from mesas       where mundo_id = any(wids);
  delete from mundos      where id = any(wids);
end $$;
