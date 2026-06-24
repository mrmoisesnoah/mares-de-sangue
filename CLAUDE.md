# CLAUDE.md — Onboarding do projeto Mares de Sangue

Contexto para qualquer assistente de IA (Claude, Claude Code, etc.) que ajude a manter/evoluir o projeto. **Leia antes de mexer.** Este arquivo é carregado automaticamente no início de toda sessão.

## ⏭️ Retomada rápida (handoff)

Para continuar **exatamente de onde paramos** sem re-escanear o código (economia de recursos), leia nesta ordem — e nada mais costuma ser necessário:

1. **Este `CLAUDE.md`** — fatos estáveis + método de trabalho.
2. **`docs/HANDOFF.md`** — **estado vivo**: o que está pronto, o que falta, decisões técnicas, como retomar.
3. **`docs/PROCESSO-AGENTES.md`** — o método de trabalho obrigatório (ver abaixo).
4. **`docs/MIGRACOES.md`** — ordem de execução das migrations do banco.

**Regra de ouro:** ao terminar qualquer rodada de trabalho, **atualize `docs/HANDOFF.md`** (estado + tarefas abertas + decisões) antes de encerrar. É o que mantém o projeto sempre pronto para handoff.

## 🧭 Método de trabalho OBRIGATÓRIO — PROCESSO-AGENTES

Todo **levantamento técnico, correção de bug, criação de feature e manutenção/suporte** deste projeto segue o pipeline de papéis descrito em **`docs/PROCESSO-AGENTES.md`**:

> N1 Usuário Final → N2 Design → N3 UI/UX → N4 Arquiteto/Techlead → N5 Eng. Full-Stack ⇄ N6 DBA — tudo orquestrado pelo **Agente de Qualidade** (refina a demanda antes, revisa cada nível, faz a revisão holística no fim).

Não é opcional: é o **modo intrínseco de operar aqui**. O assistente **incorpora os papéis em sequência** (economiza recursos) e só delega a subagentes etapas pesadas e isoladas. Os **critérios de aceite transversais** (funciona nos 6 temas, sem regressão de performance, acessível, estados vazio/carregando/erro tratados, integridade do `app.js`/`index.html` verificada de fato) valem para **toda** entrega.

## Princípio inegociável: SIMPLICIDADE

Prioridade máxima: simplicidade, custo zero/baixo, fácil manutenção por iniciantes. Prefira sempre a solução mais simples que resolve. Não introduza frameworks/dependências sem necessidade real. Não reescreva a lore sem pedido do autor — cânone é decisão dele.

## O que é

Plataforma própria de worldbuilding/RPG de mesa do cenário **Mares de Sangue / Mundo de Skard** (blog + wiki + enciclopédia + diário de campanha), do grupo **TOGA — The Older Gods Adventures** (fundado em 17/07/2012).

- **Produto atual:** a **plataforma dinâmica** (`plataforma/app/`, sobre Supabase) — publicada **na raiz** e **EM USO**.
- **Site estático antigo** (gerador `gerar_site.py` + `conteudo/` + CMS `admin/`): **APOSENTADO**, movido para `arquivo/` (só referência; nada de lá é publicado).

App publicado: **https://mrmoisesnoah.github.io/mares-de-sangue**

## Mapa do repositório

```
plataforma/
  app/               APP REAL (O PRODUTO): index.html, config.js, estilo.css, app.js  <- tudo vive aqui
  schema.sql         banco Supabase (tabelas centrais + RLS de visibilidade)
  storage.sql        bucket publico "midias" + politicas
  migracao-*.sql     evolucoes do banco - rodar na ordem de docs/MIGRACOES.md
  prototipo/         prototipo de UI (referencia visual)
docs/                HANDOFF, PROCESSO-AGENTES, MIGRACOES, PLATAFORMA, ARQUITETURA, ROADMAP, FRONT-* ...
arquivo/             site estatico antigo APOSENTADO (gerar_site.py, conteudo/, admin/) - so referencia
.github/workflows/deploy.yml   publica plataforma/app na raiz a cada push na main
```

## Plataforma — stack e modelo

- **Stack:** Supabase (Postgres + Auth + Storage + RLS) + front HTML/JS vanilla com `@supabase/supabase-js` via CDN. Hospedagem estática grátis, **sem servidor, sem build, sem framework**.
- **App = arquivo único:** `plataforma/app/app.js` (~150 KB, SPA por hash `#/rota/arg`, estado global `S`). `index.html` carrega supabase-js, marked.js, iconify-icon, `config.js`, `app.js`. `estilo.css` = tema.
- **Projeto Supabase:** `niepiaiwusptmwepgmlq` (URL e anon key pública em `plataforma/app/config.js`).
- **Modelo "tudo é publicação":** Mundo > Mesa > Personagem > Publicação. Tabela `publicacoes` com `tipo` (texto livre).
- **Visibilidade (RLS):** `publico | mesa | autor_mestre | privado | mestre` + `estado` (rascunho/publicado). As regras vivem no **banco** (políticas RLS) — o front só envia, não filtra permissão.
- **Papéis:** admin global (`profiles.papel_global`); por mesa mestre/jogador (`mesa_membros`). Dono do mundo = `mundos.dono_id`.
- **Temas:** 6 (`medieval, horror, lovecraft, anos80, scifi, samurai`) via `body[data-tema]` + variáveis CSS. Ícones game-icons via Iconify, remapeados por tema (`ICONMAP`).

## ⚠️ Regra de edição CRÍTICA (app.js / index.html / estilo.css)

Edite esses arquivos **só via bash+Python** — as ferramentas de arquivo (Edit/Write) **truncam** no mount (vale também para arquivos `.md` grandes). Depois SEMPRE:

1. `node --check app.js` (sintaxe) **e** confirme `tail -1 app.js` = `init();`;
2. confira que `index.html` tem TODOS os `<script>` + `</html>` (já foi truncado 2x -> tela "Carregando..." infinita);
3. para CSS, confira o balanço de chaves (`{` == `}`).

`node --check` não pega erro de runtime no topo — teste a carga de verdade quando possível.

## Cânone — grafias confirmadas (NÃO alterar sem o autor)

**Exar Khun** (não "Kun"). **Dranor** = reino; **Dranorak** = capital (em Dranor). **Gaurhoth** (não "Gauroth"). Em dúvida de grafia, usar a original de Tolkien (origem dos nomes).

## Gotchas

- **PostgREST:** após criar/alterar função no banco, terminar a migration com `notify pgrst, 'reload schema';` — senão `rpc()` dá **PGRST202** (função não encontrada no cache).
- **SECURITY DEFINER** no Postgres precisa de `set search_path = public` (senão "relation does not exist").
- **Migrations idempotentes** (`create or replace`, `drop policy if exists` antes de `create policy`, `if not exists`). Rodar na ordem de `docs/MIGRACOES.md`.
- Caminhos de pastas têm espaços/acentos — cite entre aspas.
- `esc()` no app escapa `& < > "` (anti-XSS) — usar em títulos, atributos e URLs.

## Como publicar

Editar `plataforma/app/` -> conferir local -> **sempre fornecer ao autor os comandos git** (`git add -A && git commit -m "..." && git push` na `main`). O GitHub Actions republica. Migrations: rodar no **Supabase -> SQL Editor** na ordem de `docs/MIGRACOES.md`.

## Preferências do autor

- Não é dev — decisões técnicas seguem o PROCESSO-AGENTES; o assistente decide quando ele não souber.
- Respostas **concisas**. **Sempre entregar os comandos git** ao fim de mudanças no repo.
- Validação **ao vivo** ao fim de cada bloco (não a cada micro-mudança). Ele sobe (push) e roda migrations e avisa.
- **Não excluir, arquivar** (mover, não apagar) — exceto conteúdo de teste que ele autorizou excluir.
