-- Adiciona imagem_url à tabela sessoes.
-- Idempotente.
alter table sessoes add column if not exists imagem_url text;
