-- Migração: anexo de arquivo nas publicações (ideal para a FICHA do personagem em PDF/Word)
-- Permite subir o documento da ficha pronta e disponibilizá-lo conforme a visibilidade da publicação.
alter table publicacoes add column if not exists arquivo_url  text;
alter table publicacoes add column if not exists arquivo_nome text;
