-- Migração: tema visual por mundo
alter table mundos add column if not exists tema text default 'medieval';
