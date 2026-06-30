-- ============================================================
-- Migração: Adicionar campo `resumo` à tabela `recompensas`
-- Resumo curto (linha única) que aparece no card da recompensa
-- Detalhes completos ficam em `descricao` (Quill)
-- Idempotente.
-- ============================================================
alter table recompensas add column if not exists resumo text;

-- Comentário para documentar o campo
comment on column recompensas.resumo is 'Resumo breve da recompensa (ex: +100 XP). Aparece no card da sessão. Detalhes vão em descricao.';
