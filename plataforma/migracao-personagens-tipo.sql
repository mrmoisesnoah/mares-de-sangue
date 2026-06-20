-- ============================================================
-- Migração: tipo do personagem (npc × jogador) + atribuição
-- Idempotente.
-- ============================================================
alter table personagens add column if not exists tipo text not null default 'jogador';

-- backfill heurístico (uma vez): personagens do dono do mundo viram NPC
update personagens set tipo='npc'
  where mundo_id is not null and tipo='jogador'
    and jogador_id = (select dono_id from mundos w where w.id = personagens.mundo_id);

-- pers_insert: mestre da mesa / dono do mundo / admin podem atribuir a outro jogador
drop policy if exists pers_insert on personagens;
create policy pers_insert on personagens for insert with check (
  (jogador_id = auth.uid() and (mesa_id is null or is_membro(mesa_id)))
  or (mesa_id is not null and is_mestre(mesa_id))
  or (mundo_id is not null and is_dono_mundo(mundo_id))
  or is_admin()
);
-- pers_update: dono do mundo também pode editar/reatribuir
drop policy if exists pers_update on personagens;
create policy pers_update on personagens for update using (
  jogador_id = auth.uid() or (mesa_id is not null and is_mestre(mesa_id)) or (mundo_id is not null and is_dono_mundo(mundo_id)) or is_admin()
);
