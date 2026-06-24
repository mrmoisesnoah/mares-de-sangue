-- Subtítulo do mundo: linha curta exibida sob o card do mundo.
-- A descrição completa (coluna `descricao`) continua aparecendo no hero da home do mundo.
-- Idempotente. Não mexe em RLS (a coluna faz parte da linha de `mundos`, já coberta pelas políticas existentes).

alter table mundos add column if not exists subtitulo text;
