# HANDOFF — Mares de Sangue (Mundo de Skard)

> Documento mestre de transferência. Um novo Claude deve conseguir continuar **sem** o histórico do chat lendo: este arquivo + `CURRENT_STATUS.md` + `OPEN_TASKS.md` + `TECH_DECISIONS.md` + `MIGRACOES.md` + `CLAUDE.md` (raiz) + `PROCESSO-AGENTES.md`. Os demais (`PROJECT_OVERVIEW`, `ARCHITECTURE`, `BUSINESS_RULES`, `USER_FLOWS`) aprofundam seções específicas.

## 0. Acesso rápido (fatos que você vai usar toda hora)
- **App publicado:** https://mrmoisesnoah.github.io/mares-de-sangue  (a PLATAFORMA é publicada **na raiz**)
- **Repo (deploy):** GitHub Pages via `.github/workflows/deploy.yml` → publica a pasta `plataforma/app` na raiz. `git push` na `main` reconstrói.
- **Supabase:** projeto ref `niepiaiwusptmwepgmlq` (URL e **anon key pública** em `plataforma/app/config.js`). Postgres + Auth + Storage(bucket público `midias`) + RLS.
- **Admin/dono:** Moisés Noah — user id `c3ed4547-f032-47f6-8650-360684451acc`, `profiles.papel_global = 'admin'`.
- **App = arquivo único:** `plataforma/app/app.js` (~150KB, JS vanilla, SPA). Sem framework, sem build.
- **REGRA DE EDIÇÃO CRÍTICA:** edite `app.js`/`index.html`/`estilo.css` **só via bash+Python** (as ferramentas Edit/Write **truncam** no mount). Depois SEMPRE rode `node --check app.js` E confirme que o arquivo termina certo (`tail -1` = `init();`) e que `index.html` tem TODOS os `<script>` + `</html>`. O `index.html` já foi truncado 2x (perdeu os scripts do corpo → tela "Carregando…" infinita).

## 1. Visão Geral
**Objetivo:** plataforma própria de worldbuilding/RPG de mesa para o cenário **Mares de Sangue / Mundo de Skard** — mistura de blog + wiki + enciclopédia + diário de campanha. Preserva e expande o universo criado pelo grupo **TOGA — The Older Gods Adventures** (fundado em **17/07/2012**).
**Público:** mestres e jogadores do grupo (e leitores). Autor/admin: Moisés Noah.
**Problema que resolve:** centralizar lore, campanhas, personagens, jornais e cronologia, com visibilidade controlada (segredos do mestre).
**Estado:** EM PRODUÇÃO e em uso. Mundo de Skard já povoado e organizado. Vários mundos de exemplo (1 por tema) criados pelo autor.
**Escopo atual:** mundos, mesas (campanhas), enciclopédia, personagens+fichas, jornais, linha do tempo, sessões+recompensas, favoritos, comentários, notificações, 6 temas visuais, busca, guia, créditos.
**Escopo planejado:** editor de texto profissional (Quill), cards temáticos por entidade, painel de administração + super-admin, revisão de conteúdo do blog antigo, expandir galeria de fotos.

## 2. Princípio inegociável
**SIMPLICIDADE.** Custo zero/baixo, fácil manutenção por iniciantes, sem frameworks/dependências desnecessárias. Não reescrever a lore sem o autor (cânone é dele).

## 3. Arquitetura (resumo — ver ARCHITECTURE.md)
- **Front:** `plataforma/app/` = `index.html` (carrega supabase-js, marked.js, iconify-icon, config.js, app.js via CDN) + `app.js` (toda a lógica/telas) + `estilo.css` (tema) + `config.js` (URL+anon key, cria `sb`).
- **Roteamento:** hash (`#/rota/arg`). Estado global `S` (user, profile, mundo, mundos, mesas, view, modo...). `go(t,arg)`→`rota()`→`render()`→`layout(html)`. `esc()` escapa `& < > "`.
- **Back:** Supabase. Modelo **"tudo é publicação"**: tabela `publicacoes` com `tipo` (texto livre), `visibilidade` (publico|mesa|autor_mestre|privado|mestre), `estado` (publicado|rascunho), e FKs opcionais `mesa_id`/`personagem_id`/`jornal_id`/`sessao_id`. Segurança vive no banco (RLS) — o front só envia, não filtra permissão.
- **Ícones:** Iconify + game-icons.net (CC BY), via web component `<iconify-icon icon="game-icons:NOME">`. Função `icon(g)` + `ICONMAP[tema]` troca o símbolo por tema. `ic(semantic)` mapeia nomes semânticos. Tingidos por `currentColor` (acento do tema).
- **Temas:** `body[data-tema=...]` + variáveis CSS (`--papel,--perg,--perg2,--campo,--tinta,--tinta2,--sangue,--ouro,--borda,--sombra,--font-head,--font-body`). 6 temas: medieval, horror, lovecraft, anos80, scifi, samurai. `aplicarTema()` roda no topo de `render()` lendo `S.mundo.tema`.
- **Deploy:** push `main` → GitHub Actions publica `plataforma/app` na raiz. Site estático antigo APOSENTADO em `arquivo/`.

## 4. Estado da implementação (ver CURRENT_STATUS.md p/ detalhe)
**Concluído e no ar:** auth, mundos, mesas, enciclopédia (explorer c/ filtro+categorias+cards/lista), mapas, linha do tempo (períodos retráteis + fundo + vínculo de conteúdo + reordenar ↑/↓), personagens (retrato redondo, ficha texto+anexo PDF, atribuir, NPC×jogador), jornais (capa de jornal + edições estilo recorte), sessões (planejamento/resumos/recompensas XP), favoritos, comentários (com avatar), notificações (sino), 6 temas com fontes/ícones próprios, toggle global cards/lista, busca, guia visual (#/guia), créditos (data TOGA 17/07/2012), mural da campanha + fixar conteúdo (limite 6), foto de personagem ampliável (lightbox), responsividade mobile (cabeçalho compacto, sem scroll lateral).
**QUEBRADO / atenção imediata:** exclusão de mundo/mesa (`excluir_mundo`/`excluir_mesa`) retorna **PGRST202** — a migration `plataforma/migracao-excluir-mundo-mesa.sql` precisa terminar com `notify pgrst, 'reload schema';` e ser re-executada (cache do PostgREST).
**Pendente:** painel de Administração + super-admin; editor Quill; cards temáticos por entidade; revisão do blog antigo; foto do grupo TOGA (arquivo `plataforma/app/toga.jpg` — slot pronto nos créditos, autor precisa subir o arquivo); excluir a mesa vazia "Sombras Vindas do Tempo" (`plataforma/limpeza-mesa-sombras.sql`).

## 5. Regras de negócio (ver BUSINESS_RULES.md)
- **Visibilidade** (campo `visibilidade`): `publico` (todos) · `mesa` (membros da campanha) · `autor_mestre` · `privado` (só autor) · `mestre` (só mestre da mesa). + `estado` `rascunho` (só autor vê) / `publicado`. É como o mestre prepara segredos.
- **Papéis:** `profiles.papel_global = 'admin'` (global). Por mesa: `mesa_membros.papel` = `mestre`|`jogador`. Mestre = `mesas.mestre_id`. Dono do mundo = `mundos.dono_id`. Colaboradores de mundo (tabela própria) podem criar conteúdo.
- **Pedidos de acesso:** usuário pede acesso a mundo/mesa/personagem → dono é notificado → aprova.
- **Mural da Campanha:** conteúdo player-facing da mesa + fixados (`mural_pins`), **limite 6** fixados/mesa; só mestre fixa/desfixa.
- **Ficha de personagem:** é uma `publicacao` `tipo='ficha'` ligada ao personagem (visibilidade própria) + anexo opcional (`arquivo_url`).
- **Cânone (NÃO alterar sem o autor):** **Exar Khun** (não "Kun"); **Dranor** = reino, **Dranorak** = capital; **Gaurhoth** (não "Gauroth"). Em dúvida de grafia, usar a original de Tolkien.

## 6. Fluxos de usuário — ver USER_FLOWS.md.

## 7. Contexto estratégico
- Visão do autor: preservar/expandir o universo TOGA com uma ferramenta bonita, simples e barata, que mestres e jogadores usem de verdade.
- Prioridade declarada agora (ordem): **quick wins** (reordenar eventos ✓, fotos ✓, cards temáticos ▶) → **editor Quill** → **blog antigo**. Mais: painel admin/super-admin.
- O autor **não é dev** — pediu que decisões técnicas sigam o **PROCESSO-AGENTES.md** (N1–N6 + Qualidade) e que o assistente decida quando ele não souber.
- **NÃO alterar sem validação:** o cânone/lore; a estrutura de visibilidade (RLS); o deploy (publica `plataforma/app` na raiz).

## 8/9/10 — ver OPEN_TASKS.md (pendências priorizadas), TECH_DECISIONS.md (decisões + dívida técnica), e a seção "Arquivos" abaixo.

## Conhecimento implícito / lições
- **Truncamento no mount:** Edit/Write truncam arquivos grandes; use bash+Python e VERIFIQUE integridade (não só sintaxe — teste a carga). `node --check` não pega erro de runtime no topo (ex.: `var X=funcQueLeVarAindaIndefinida()`).
- **PostgREST:** após criar função, `notify pgrst, 'reload schema';` senão `rpc()` dá PGRST202.
- **Migrations idempotentes** (`create or replace`, `drop policy if exists` antes de `create policy`, `if not exists`). Rodar na ordem de `MIGRACOES.md`.
- **SECURITY DEFINER** precisa `set search_path = public`.
- **Preferência do autor:** respostas concisas; validação ao vivo no Chrome ao fim de cada bloco (não a cada mudança); ele sobe (git push) e roda migrations e avisa "subiu/rodou".
- **Não excluir, arquivar** (quando ele pede p/ tirar coisas — mover, não apagar; exceto conteúdo de teste que ele autorizou excluir).
