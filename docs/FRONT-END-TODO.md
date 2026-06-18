# Briefing de front-end da plataforma

Objetivo: levar `plataforma/app/` à qualidade visual/UX do **protótipo** (`plataforma/prototipo/index.html`) e do **site estático**, mantendo a simplicidade (HTML/JS + supabase-js, sem framework pesado).

## Referências de estilo
- **Alvo visual:** `plataforma/prototipo/index.html` (cards com imagem, barra lateral organizada, telas de personagem e mapa, formulário de criação com visibilidade).
- **Tema:** pergaminho/sangue/ouro, fontes Cinzel + EB Garamond (já em `plataforma/app/estilo.css`).
- **Dados reais:** o app usa Supabase (ver `plataforma/app/app.js`). O protótipo usa dados fictícios — copiar a *aparência/organização* dele, ligando aos dados reais.

## O que falta (prioridades)

1. **Barra lateral rica** (como no protótipo): Mundo → Enciclopédia (seções por tipo), lista de Mesas, **Área do Mestre** (só mestre), e um menu **+ Criar** (publicação, personagem, mapa, mesa).
2. **Cards em tudo**, com imagem (miniatura) e clicáveis — mesas, personagens, mapas, publicações. Hoje há cards só parcialmente; padronizar (ver `.card.clic`, `.thumb` no CSS).
3. **Criar personagem** — UI + persistência. *Requer ajuste de schema* (ver abaixo).
4. **Editar e excluir** publicações/personagens do próprio autor (e mestre/admin). O RLS já permite (`pub_update`, `pub_delete`); falta a UI (botões + formulário de edição via `update`/`delete` do supabase-js).
5. **Área de Mapas** dedicada (tipo `mapa`), com imagem grande no detalhe — como no protótipo.
6. **Upload de imagens** (Supabase Storage) para capas de personagem, mapas e dentro de publicações — além do link externo já suportado. Criar bucket público `midias` + políticas.
7. **Editor de Markdown** no formulário (pré-visualização ajuda), já que o corpo é Markdown.
8. **Busca** e navegação por tags.

## Ajustes de schema sugeridos (apenas quando necessário)
O modelo atual é minimalista. Para fichas ricas de personagem, escolha UMA:
- (A) Adicionar colunas a `personagens`: `resumo text`, `imagem_url text`, e tratar história/diário como `publicacoes` ligadas via `personagem_id`; **ou**
- (B) Manter `personagens` mínima e representar a ficha como uma `publicacao` tipo `personagem` (com `capa`/mídia).
Para capas simples, considere `capa_url text` em `publicacoes` (evita join com `midias` na listagem). Documente qualquer mudança em `schema.sql` e rode no SQL Editor.

## Regras a respeitar
- Visibilidade é do banco (RLS). O front só envia `visibilidade`/`estado`; não reimplementar permissão no cliente.
- Cânone: Exar Khun; Dranor (reino) ≠ Dranorak (capital); Gaurhoth. Não reescrever lore.
- Manter tudo gratuito e sem servidor próprio.

## Arquivos-chave
`plataforma/app/app.js` (lógica/telas), `plataforma/app/estilo.css` (tema), `plataforma/app/index.html` (carrega supabase-js + marked + config), `plataforma/schema.sql` (banco/RLS), `plataforma/prototipo/index.html` (referência de UI).
