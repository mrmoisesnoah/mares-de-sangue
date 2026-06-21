-- Remover a mesa "Sombras Vindas do Tempo" (já esvaziada — textos movidos para contos/anotações).
-- Rodar no Supabase → SQL Editor.
do $$
declare mid uuid := (select id from mesas where nome = 'Sombras Vindas do Tempo' limit 1);
begin
  if mid is not null then
    delete from recompensas  where mesa_id = mid;
    delete from sessoes      where mesa_id = mid;
    delete from mesa_membros where mesa_id = mid;
    delete from eventos      where mesa_id = mid;
    delete from periodos     where mesa_id = mid;
    delete from publicacoes  where mesa_id = mid;
    delete from personagens  where mesa_id = mid;
    delete from mesas        where id = mid;
  end if;
end $$;
