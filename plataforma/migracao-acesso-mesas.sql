-- ============================================================
-- Migração: acesso público às mesas
-- Quem NÃO está logado passa a ver as mesas de mundos públicos
-- e o conteúdo público gerado nelas.
-- O conteúdo continua protegido pela RLS de 'publicacoes':
-- estranhos só enxergam o que é 'publico' + 'publicado'.
-- Idempotente — pode rodar quantas vezes quiser.
-- ============================================================
drop policy if exists mesa_select on mesas;
create policy mesa_select on mesas for select using (
  is_membro(id) or is_admin()
  or exists (select 1 from mundos w where w.id = mesas.mundo_id and w.publico)
);
