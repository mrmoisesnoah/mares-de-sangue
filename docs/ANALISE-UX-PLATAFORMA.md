# Análise de UX/UI/Técnica — Plataforma Mares de Sangue

Data: 2026-06-18. Base: código real (`plataforma/app/app.js`, `index.html`, `estilo.css`, `schema.sql`) + inspeção dos endereços no ar. Três óticas (usuário final, UI/UX, dev full stack) consolidadas, sempre priorizando a alternativa mais simples.

> Filosofia adotada (decisão do autor): **não remover funcionalidades**. As ferramentas (personagens, mesas, as 5 visibilidades) ficam — o objetivo é torná-las funcionais, organizadas, intuitivas e **hiperconectadas**, com navegação fluida para o usuário conhecer o mundo.

---

## Resumo executivo

A base é enxuta e coerente com a simplicidade do projeto (SPA em JS puro + Supabase, sem framework). Três problemas graves comprometiam o uso real e **já foram corrigidos** nesta passagem:

1. **"Criar Personagem" abria um formulário "Nova publicação".** Agora o formulário mostra "Novo personagem / Novo mapa / Novo conteúdo" conforme o tipo.
2. **A navegação sumia no celular** (barra lateral com `display:none`, sem substituto). Agora há um menu hambúrguer (gaveta) no topo.
3. **O modelo de "Mesa" não funcionava** para quem não fosse admin: criar uma mesa nunca registrava o criador em `mesa_membros`, e as regras de visibilidade (RLS) dependem disso. Agora um gatilho no banco registra o mestre automaticamente (e preenche as mesas antigas).

Também foi encontrado um problema de conteúdo visível ao jogador: a **Sessão 1 aparece 6 vezes** na wiki pública (ver seção própria).

---

## Perspectiva do Usuário

| Problema | Impacto | Prioridade | Status |
|---|---|---|---|
| "Criar Personagem" leva a tela "Nova publicação" | Quebra a confiança; não se sabe se criou a coisa certa | Crítico | Corrigido |
| No celular não há menu de navegação | Mestre/jogador no telefone fica perdido | Crítico | Corrigido |
| Não há como adicionar jogadores a uma mesa | O objetivo central (mestres + jogadores juntos) não se realiza | Crítico | Pendente (tela de membros) |
| Palavra "publicação" em todo lugar (jargão) | Usuário não associa a artigo/personagem/mapa | Alto | Corrigido nos botões de criar |
| Formulário único com 18 tipos + 5 visibilidades + estado + tags | Muitas decisões para uma tarefa simples | Alto | Pendente ("Opções avançadas") |
| Sem confirmação visível após salvar | Falta de feedback | Médio | Pendente |
| Rótulos de visibilidade crípticos ("autor + mestre", "só mestre") | Difícil saber quem vê o conteúdo | Médio | Pendente (renomear, sem remover) |

## Perspectiva UI/UX

| Problema | Motivo | Prioridade | Status |
|---|---|---|---|
| Título do formulário fixo em "Nova publicação" | `formPub` reusado sem trocar rótulo por tipo | Crítico | Corrigido |
| Barra lateral some no mobile sem alternativa | `display:none` sem gaveta | Crítico | Corrigido |
| Tela "Personagens" usa explorador diferente das outras (sem cards de categoria) | Dois caminhos de código para o explorador | Médio | Pendente (unificar) |
| Cliques em `<a onclick>` / `<div onclick>` sem foco/teclado | Não acessível por teclado/leitor de tela | Médio | Pendente |
| Contraste baixo em textos pequenos (ouro/`vis-leg`) | Cores claras sobre pergaminho | Médio | Pendente |
| Imagens de conteúdo sem `alt` | Acessibilidade/SEO | Baixo | Pendente |
| Flicker "Carregando…" a cada tela | Re-render completo via innerHTML duas vezes | Baixo | Pendente |

## Perspectiva Técnica

| Problema | Causa provável | Prioridade | Status |
|---|---|---|---|
| Criar mesa não populava `mesa_membros`; RLS depende dela | `salvarMesa` só inseria em `mesas` | Crítico | Corrigido (trigger no banco) |
| Personagem é `publicacao tipo='personagem'`; tabela `personagens` existe mas não é usada | Modelo inacabado | Alto | A consolidar (manter "tudo é publicação"; usar `personagem_id`) |
| Sem UI para gerenciar membros/convidar jogador | Nunca implementado | Alto | Pendente |
| `persDoMundo()` baixa todas as publicações e filtra no cliente | Falta filtro por `tipo` na query | Médio | Pendente |
| `render()` chama funções `async` sem `await` | Possíveis corridas em navegação rápida | Médio | Pendente |
| Duplicação do "card de mundo" em duas telas | Falta helper `cardMundo()` | Baixo | Pendente |

---

## Achado ao vivo: Sessão 1 duplicada na wiki pública

A pasta `conteudo/03 - Mestragem - Ecos na Cidade dos Corvos/Sessoes/Sessao 1 - 14-06-2026/` tem 6 arquivos: Planejamento (Introdução), Resumo (WhatsApp), Resumo v1 Narrativo, Resumo v2 Crônica de Mesa, Resumo v3 Registro Objetivo e _LEIA-ME.

Causa do efeito "5 links idênticos": quando o site foi gerado pela última vez, esses arquivos tinham o **mesmo `titulo`**, então o gerador criou slugs `-2..-5`. Localmente os títulos **já estão distintos** (corrigido na fonte) — então **basta regenerar e publicar** que os links deixam de ser idênticos.

Resta uma decisão de curadoria (sua, é cânone): quatro versões de resumo (WhatsApp, Narrativo, Crônica, Objetivo) estão todas como `status: publico / audiencia: jogadores`, e o `_LEIA-ME` (um índice interno) também está público. Mostrar ao jogador 4 versões da mesma sessão + um leia-me é redundante.

Recomendação simples (sem apagar nada): escolher **uma** versão canônica pública para os jogadores (ex.: "Crônica de Mesa") e marcar as outras como `status: privado` ou `audiencia: mestre` — elas continuam no acervo, só não poluem a wiki pública. O `_LEIA-ME` não deveria ser um artigo publicado.

---

## Referências de plataformas (o que copiar, simplificando)

O projeto se inspira em World Anvil, wikis e ferramentas de worldbuilding. Padrões que valem a pena adaptar — sempre na versão mais simples:

- **World Anvil / Kanka:** "tudo é artigo" + **menções/links automáticos entre artigos** e bloco "relações". O `schema.sql` já tem a tabela `publicacao_relacoes` (hoje sem uso) e o site estático já resolve `[[Título]]` — falta trazer isso para a plataforma.
- **Wikis / Obsidian Publish:** **links `[[ ]]`** no corpo, **backlinks** ("aparece em…") e navegação por hierarquia. Alta conexão com baixo custo.
- **Notion / Fandom:** galerias de **cards com imagem**, **infobox** lateral em personagens/lugares, categorias. A plataforma já tem cards e categorias; falta o infobox e padronizar a imagem em tudo.

Tradução disso para "fluidez e hiperconexão" (navegar e conhecer o mundo), em ordem de simplicidade:

1. **`[[Links]]` no Markdown da plataforma:** pré-processar o corpo antes do `marked.js` para transformar `[[Título]]` em link para a publicação correspondente. Reaproveita o conceito que o site estático já usa. *Baixa complexidade, alto impacto de conexão.*
2. **"Veja também" / relações:** usar `publicacao_relacoes` para mostrar conteúdos ligados no rodapé de cada página. *Baixa/média.*
3. **Breadcrumb hierárquico real:** Mundo › Mesa › Personagem › conteúdo, clicável em cada nível. *Baixa.*
4. **Busca global do mundo** (não só dentro de uma tela). *Média.*
5. **Infobox de personagem/lugar** (imagem + campos curtos) reaproveitando `capa_url` e tags. *Média.*

---

## Plano de implementação

### Feito nesta passagem (alto impacto, baixa complexidade)
- Rótulo dinâmico do formulário (personagem/mapa/conteúdo) em `app.js`.
- Menu hambúrguer no mobile em `estilo.css` + `app.js` (`#btn-menu`, `toggleMenu`).
- Gatilho `handle_new_mesa` em `schema.sql` (mestre vira membro; backfill das mesas antigas).
- Terminologia: botões "+ Publicação"/"Nova publicação" → "+ Conteúdo"/"Novo conteúdo".
- Seed do schema atualizado para o nome "O Mundo de Skard".

### Fazer a seguir (médio impacto)
- **Tela de membros da mesa** (convidar/remover jogador) — destrava a visibilidade "mesa" para jogadores reais.
- **`[[Links]]` + "Veja também"** — começa a hiperconexão.
- **"Opções avançadas"** recolhendo Estado/Visibilidade; renomear (não remover) os rótulos de visibilidade para frases claras.
- **Unificar o explorador** na tela de Personagens.
- **Acessibilidade:** cliques viram `<button>`/`role+tabindex`; `alt` nas imagens; revisar contraste.

### Opcional (baixo impacto)
- Helper `cardMundo()` (remover duplicação).
- Filtrar personagens por `tipo` na query.
- Reduzir o flicker "Carregando…".
- Busca global e infobox.

---

## Ações que dependem de você

1. **Rodar `plataforma/schema.sql`** no SQL Editor do Supabase (é idempotente) para ativar o gatilho da mesa e o backfill.
2. **Renomear o mundo** para "O Mundo de Skard": pela tela "✎ Editar mundo" no app, ou no SQL Editor:
   `update mundos set nome = 'O Mundo de Skard' where nome = 'Mares de Sangue';`
3. **Regenerar e publicar** o site estático (`python gerar_site.py` → commit → push) para resolver os links duplicados da Sessão 1.
4. **Decidir a versão canônica** da Sessão 1 (posso aplicar a mudança de visibilidade nas outras).
5. **Conectar a extensão Claude in Chrome** se quiser que eu navegue o app logado e valide os ajustes na prática.

---

## Onde eu questiono decisões (sem remover nada)

- **Cinco visibilidades** continuam disponíveis, mas recomendo que o formulário mostre por padrão só as 2–3 mais comuns e esconda o resto em "Opções avançadas". Mantém o poder, reduz a chance de publicar no nível errado e vazar surpresa ao jogador.
- **`personagens` (tabela) × "personagem é publicação".** Hoje as duas coisas coexistem. Em vez de apagar a tabela, sugiro **conectá-la**: a ficha continua sendo uma `publicacao tipo='personagem'` (ganha capa/markdown/visibilidade de graça) e a tabela `personagens`/`personagem_id` passa a ser o elo que **liga** a ficha à mesa e aos textos do jogador — exatamente a "hiperconexão" desejada, sem duplicar conceito.
