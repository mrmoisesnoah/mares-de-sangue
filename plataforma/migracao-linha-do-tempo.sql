-- ============================================================
-- Migração: Época/Local da mesa + Linha do tempo do mundo
-- Idempotente.
-- ============================================================

-- Situar a mesa no tempo/espaço do mundo
alter table mesas add column if not exists epoca text;
alter table mesas add column if not exists local text;

-- Linha do tempo: acontecimentos do mundo
create table if not exists eventos (
  id           uuid primary key default gen_random_uuid(),
  mundo_id     uuid not null references mundos(id) on delete cascade,
  autor_id     uuid not null references profiles(id),
  titulo       text not null,
  quando       text,
  ordem        int,
  descricao    text,
  cor          text,
  visibilidade text not null default 'publico',
  estado       text not null default 'publicado',
  criado_em    timestamptz not null default now()
);
alter table eventos enable row level security;

drop policy if exists evt_select on eventos;
create policy evt_select on eventos for select using (
  is_admin() or autor_id = auth.uid() or (visibilidade='publico' and estado='publicado')
  or is_dono_mundo(mundo_id) or is_colab_mundo(mundo_id)
);
drop policy if exists evt_insert on eventos;
create policy evt_insert on eventos for insert with check (
  autor_id = auth.uid() and (is_dono_mundo(mundo_id) or is_colab_mundo(mundo_id) or is_admin())
);
drop policy if exists evt_update on eventos;
create policy evt_update on eventos for update using (autor_id = auth.uid() or is_dono_mundo(mundo_id) or is_admin());
drop policy if exists evt_delete on eventos;
create policy evt_delete on eventos for delete using (autor_id = auth.uid() or is_dono_mundo(mundo_id) or is_admin());
