-- ============================================================
-- migracao-personagem-membro.sql
-- Endurece a criação de personagens.
--
-- ANTES: a política pers_insert exigia apenas (jogador_id = auth.uid()),
-- ou seja, QUALQUER usuário autenticado podia criar um personagem ligado
-- a QUALQUER mesa, mesmo sem ser membro dela.
--
-- AGORA: personagem ligado a uma MESA exige ser membro da mesa
-- (is_membro). Personagem "livre" no mundo (mesa_id IS NULL) mantém o
-- comportamento atual. Dono do mundo e admin seguem podendo.
--
-- Idempotente. Rodar no Supabase > SQL Editor.
-- (Publicações já eram gated por is_membro — ver pub_insert no schema.sql.)
-- ============================================================

drop policy if exists pers_insert on personagens;
create policy pers_insert on personagens for insert with check (
  jogador_id = auth.uid() and (
    mesa_id is null            -- personagem livre no mundo (comportamento atual)
    or is_membro(mesa_id)      -- ligado a uma mesa: precisa ser membro
    or is_dono_mundo(mundo_id) -- dono do mundo pode criar em qualquer mesa do mundo
    or is_admin()
  )
);
