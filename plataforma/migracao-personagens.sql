-- ============================================================
-- Migração: Personagem como entidade (hub)
-- mundo_id e mesa_id OPCIONAIS (personagem pode existir só no mundo,
-- numa mesa, ou totalmente avulso). Idempotente.
-- ============================================================
alter table personagens alter column mundo_id drop not null;
alter table personagens add column if not exists resumo       text;
alter table personagens add column if not exists corpo        text;
alter table personagens add column if not exists imagem_url   text;
alter table personagens add column if not exists epiteto      text;
alter table personagens add column if not exists visibilidade text not null default 'publico';
alter table personagens add column if not exists estado       text not null default 'publicado';

drop policy if exists pers_select on personagens;
create policy pers_select on personagens for select using (
  is_admin()
  or jogador_id = auth.uid()
  or (visibilidade = 'publico' and estado = 'publicado')
  or (mesa_id is not null and is_membro(mesa_id))
  or (visibilidade in ('autor_mestre','mestre') and mesa_id is not null and is_mestre(mesa_id))
);
drop policy if exists pers_insert on personagens;
create policy pers_insert on personagens for insert with check (jogador_id = auth.uid());
drop policy if exists pers_update on personagens;
create policy pers_update on personagens for update using (jogador_id = auth.uid() or (mesa_id is not null and is_mestre(mesa_id)) or is_admin());
drop policy if exists pers_delete on personagens;
create policy pers_delete on personagens for delete using (jogador_id = auth.uid() or (mesa_id is not null and is_mestre(mesa_id)) or is_admin());
