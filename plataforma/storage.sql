-- Storage para upload de imagens (rodar uma vez no SQL Editor do Supabase)
insert into storage.buckets (id, name, public) values ('midias','midias', true)
  on conflict (id) do nothing;

-- leitura pública das imagens
drop policy if exists "midias_leitura" on storage.objects;
create policy "midias_leitura" on storage.objects for select using (bucket_id='midias');

-- upload por usuários logados
drop policy if exists "midias_upload" on storage.objects;
create policy "midias_upload" on storage.objects for insert to authenticated with check (bucket_id='midias');

-- dono pode apagar o que enviou
drop policy if exists "midias_delete" on storage.objects;
create policy "midias_delete" on storage.objects for delete to authenticated using (bucket_id='midias' and owner=auth.uid());
