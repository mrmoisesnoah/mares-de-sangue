-- Migration: coluna `formato` em publicacoes
-- Marca como o corpo da publicacao foi escrito/armazenado:
--   'md'   = Markdown (conteudo antigo + comentarios; renderizado com marked.js)
--   'html' = HTML do editor visual Quill (conteudo novo/editado pelo corpo da publicacao)
-- Conteudo ja existente recebe 'md' por padrao -> continua renderizando como antes.
-- Idempotente.

alter table publicacoes
  add column if not exists formato text not null default 'md';

-- (opcional) restringe aos dois valores esperados
do $$
begin
  if not exists (
    select 1 from pg_constraint where conname = 'publicacoes_formato_chk'
  ) then
    alter table publicacoes
      add constraint publicacoes_formato_chk check (formato in ('md','html'));
  end if;
end $$;

notify pgrst, 'reload schema';
