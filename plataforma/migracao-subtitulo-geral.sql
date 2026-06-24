-- Subtítulo curto (linha exibida no card) para mesas, publicações e sessões.
-- O texto/descrição completo continua nas telas de detalhe e no hero. Idempotente; não mexe em RLS.

alter table mesas       add column if not exists subtitulo text;
alter table publicacoes add column if not exists subtitulo text;
alter table sessoes     add column if not exists subtitulo text;
