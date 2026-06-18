# CLAUDE.md — Onboarding do projeto Mares de Sangue

Contexto para qualquer assistente de IA (Claude Code, etc.) que ajude a manter/evoluir o projeto. Leia antes de mexer.

## O que é

Plataforma do cenário de RPG **Mares de Sangue / Mundo de Skard**. Dois componentes que convivem:

1. **Site estático** (wiki pública) — gerado de arquivos Markdown. Já no ar.
2. **Plataforma dinâmica** (login, mesas, personagens, publicações) — sobre Supabase. Em construção.

## Princípio inegociável: SIMPLICIDADE

Prioridade máxima: simplicidade, custo zero/baixo, fácil manutenção por iniciantes. Prefira sempre a solução mais simples que resolve. Não introduza frameworks/dependências sem necessidade real. Não reescreva a lore sem pedido do autor — cânone é decisão dele.

## Mapa do repositório

```
gerar_site.py        gerador do site estático (lê conteudo/ -> site/)
conteudo/            os .md do cenário (fonte única do conteúdo)
site/ (gerado)       wiki pública    | site-mestre/ (gerado) edição do mestre
admin/               Sveltia CMS (edição git do site estático) — opcional
plataforma/
  schema.sql         banco Supabase (tabelas + RLS de visibilidade)
  migracao.sql       insere os .md como publicações no banco
  prototipo/index.html   PROTÓTIPO de UI (alvo visual da plataforma)
  app/               APP REAL da plataforma (index.html, config.js, estilo.css, app.js)
docs/                ARQUITETURA, PLATAFORMA, ROADMAP, FRONT-END-TODO, FASE4-HOSPEDAGEM, SUPABASE-P1
.github/workflows/deploy.yml   build + deploy no GitHub Pages a cada push
```
Saída publicada: site estático em `/`, plataforma em `/plataforma/` (o gerador copia `plataforma/app` para `site/plataforma`).

## Site estático

`pip install -r requirements.txt` então `python gerar_site.py` (público) e `--mestre`. Tema (CSS) embutido no gerador. Detalhes em `docs/ARQUITETURA.md` e `docs/FRONT-MATTER.md`.

## Plataforma (Supabase + front estático)

- **Stack:** Supabase (Postgres + Auth + Storage + RLS) + front HTML/JS com `@supabase/supabase-js` via CDN. Hospedagem estática grátis. Sem servidor.
- **Projeto Supabase:** `niepiaiwusptmwepgmlq` (URL em `plataforma/app/config.js`; chave anon é pública).
- **Modelo "tudo é publicação":** Mundo > Mesa > Personagem > Publicação. Uma tabela `publicacoes` com campo `tipo` (texto livre). Ver `docs/PLATAFORMA.md` e `plataforma/schema.sql`.
- **Visibilidade (RLS):** `publico | mesa | autor_mestre | privado | mestre` + `estado` (rascunho/publicado). As regras vivem no banco (políticas RLS) — o front não precisa filtrar.
- **Papéis:** admin global; por mesa: mestre/jogador (tabela `mesa_membros`).

### Estado atual da plataforma
Funciona: login/signup, criar mundo, criar mesa, criar/listar publicações (agrupadas por tipo em blocos), detalhe com Markdown (marked.js), imagem por link.
**FALTA (prioridade de front-end):** aproximar a UI do `plataforma/prototipo/index.html` e do site estático — cards com imagem em tudo, barra lateral rica, **criar personagem**, **editar** e **excluir**, área do mestre, upload de imagens/mapas (Storage). Briefing detalhado em **`docs/FRONT-END-TODO.md`**.

## Cânone — grafias confirmadas (não alterar sem o autor)
- **Exar Khun** (não "Exar Kun"). **Dranor** = reino; **Dranorak** = capital (em Dranor). **Gaurhoth** (não "Gauroth"). Em dúvida de grafia, usar a original de Tolkien (origem dos nomes).

## Gotchas
- Funções SECURITY DEFINER no Postgres precisam de `set search_path = public` (senão "relation does not exist"). Já aplicado no schema.
- Caminhos de pastas têm espaços/acentos — cite entre aspas.
- A saída (`site/`, `site-mestre/`) é gerada; não versionar (está no `.gitignore`).
- Deploy: `git push` na branch `main` reconstrói e publica via GitHub Actions.

## Como rodar/publicar
Editar conteúdo → `python gerar_site.py` (conferir local) → `git add -A && git commit && git push`. A plataforma (`plataforma/app`) também é publicada nesse push.
