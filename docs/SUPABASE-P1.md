# P1 — Fundação no Supabase (passo a passo)

O que você faz uma vez para a plataforma existir. ~15 minutos, tudo gratuito. Depois disso eu ligo o front-end real (login + dados) ao seu banco.

## 1. Criar a conta e o projeto

1. Acesse **https://supabase.com** e entre com sua conta GitHub (`mrmoisesnoah`).
2. Clique em **New project**.
3. Preencha:
   - **Name:** `mares-de-sangue`
   - **Database Password:** crie uma senha forte e **guarde** (você raramente vai usá-la).
   - **Region:** escolha **South America (São Paulo)** se aparecer (mais rápido no Brasil).
4. Clique em **Create new project** e aguarde ~2 min enquanto ele provisiona.

## 2. Rodar o esquema do banco

1. No menu lateral do projeto, abra **SQL Editor**.
2. Clique em **New query**.
3. Abra o arquivo **`plataforma/schema.sql`** (deste repositório), copie **todo** o conteúdo e cole no editor.
4. Clique em **Run** (ou Ctrl/Cmd+Enter). Deve aparecer "Success".
   - Isso cria as tabelas (mundos, mesas, personagens, publicações, mídias…) e as regras de visibilidade (RLS).

## 3. Ativar o login (e-mail)

1. Menu lateral → **Authentication** → **Providers**.
2. Confirme que **Email** está habilitado (vem ligado por padrão).
3. (Opcional, mais fácil para testar) Em **Authentication → Providers → Email**, desligue *Confirm email* por enquanto, para não precisar confirmar e-mail nos primeiros testes. Pode religar depois.

## 4. Criar o seu usuário e virar admin

1. Menu lateral → **Authentication → Users → Add user** → crie um usuário com seu e-mail e uma senha (ou registre-se pela tela de login quando o front-end existir).
2. Copie o **User UID** que aparece na lista de usuários.
3. Volte ao **SQL Editor**, cole e rode (trocando `SEU-USER-ID` pelo UID copiado):

   ```sql
   update profiles set papel_global = 'admin' where id = 'SEU-USER-ID';

   insert into mundos (nome, slug, descricao, dono_id, publico)
     values ('Mares de Sangue','mares-de-sangue','O Mundo de Skard','SEU-USER-ID', true);

   insert into mesas (mundo_id, nome, slug, descricao, mestre_id)
     select id, 'Ecos na Cidade dos Corvos','ecos-na-cidade-dos-corvos','Campanha atual','SEU-USER-ID'
     from mundos where slug = 'mares-de-sangue';

   insert into mesa_membros (mesa_id, user_id, papel)
     select id, 'SEU-USER-ID', 'mestre' from mesas where slug = 'ecos-na-cidade-dos-corvos';
   ```

   Isso te torna admin e cria o mundo **Mares de Sangue** com a mesa **Ecos na Cidade dos Corvos**, já com você como mestre.

## 5. Pegar as chaves para o front-end

1. Menu lateral → **Project Settings → API**.
2. Copie dois valores e me mande (pode colar aqui):
   - **Project URL** (algo como `https://xxxx.supabase.co`)
   - **anon public** key (a chave **anon/public** — ela é feita para ficar no front-end, é segura de compartilhar).

> Não compartilhe a chave **service_role** (essa é secreta). Só preciso da **anon public**.

## Depois disso (o que eu faço)

Com a Project URL + anon key, eu monto o front-end real da plataforma (mesma cara do protótipo) ligado ao seu banco: tela de login, criar/listar publicações, personagens e mapas, com as visibilidades já aplicadas pelo Supabase. Seguimos então P2 → P3 → … do roadmap.
