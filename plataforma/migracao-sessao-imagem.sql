-- Imagem opcional para sessões (capa do card de sessão).
alter table sessoes add column if not exists imagem_url text;
