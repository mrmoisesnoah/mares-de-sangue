# Plataforma Mares de Sangue — Arquitetura (Fase 5+)

Evolução de **site estático** → **plataforma colaborativa**: login, postagem, mesas, personagens e visibilidade controlada. Mantém a filosofia do projeto: simplicidade, custo zero/baixo, crescer aos poucos.

## Por que muda a tecnologia

O site estático (Markdown → HTML) é ótimo para o cânone público, mas não suporta contas de usuário, postagem pela web nem visibilidade dinâmica (privado / mestre+jogador). Isso exige um **banco de dados + autenticação**. A escolha mais simples, gratuita e popular para isso é o **Supabase**.

## Stack recomendada (gratuita)

| Camada | Ferramenta | Por quê |
|---|---|---|
| Banco de dados | **Supabase (PostgreSQL)** | Relacional (combina com Mundo→Mesa→Personagem→Publicação); plano gratuito generoso. |
| Login | **Supabase Auth** | E-mail/senha e provedores sociais, pronto. |
| Mídia (imagens/vídeos/arquivos) | **Supabase Storage** | Upload de arquivos + URLs; também aceita links externos. |
| Visibilidade/segurança | **Row Level Security (RLS)** | Regras no próprio banco decidem quem vê o quê — o coração do seu fluxo. |
| Front-end | **HTML/JS + cliente Supabase** (estático) | Continua hospedado de graça (GitHub Pages/Cloudflare). Sem servidor para manter. |

O cânone atual (os `.md`) pode ser **migrado** para o banco aos poucos, ou conviver: a wiki estática segue como vitrine pública enquanto a plataforma cresce.

## Modelo de dados (níveis)

Segue exatamente os níveis que você descreveu:

```
Mundo (cenário)
  └── Mesa (campanha)         ── membros: mestre(s) e jogadores
        └── Personagem        ── criado por um jogador
              └── Publicação   ── "tudo é publicação"
```

**Princípio "tudo é publicação":** em vez de uma tabela para cada tipo (cidade, facção, conto…), há **uma tabela `publicacoes`** com um campo `tipo`. Isso é o mais simples e permite **criar novos tipos sem mudar o banco** — como você pediu.

Uma publicação tem: `tipo`, `autor`, `mundo`, `mesa` (opcional), `personagem` (opcional), `categoria`, `tags`, `estado` (rascunho/publicado) e `visibilidade`.

Tipos previstos (lista aberta): história do mundo, era, religião, região, reino, cidade, facção, personagem, criatura, item, evento histórico, planejamento do mestre, sessão, crônica, resumo de sessão, background, diário de personagem, conto, família, clã, organização, local, **mapa** (região/cidade/masmorra), anotação privada, jornal… e outros que surgirem.

## Visibilidade (o controle central)

Cada publicação tem um nível, aplicado automaticamente pelo banco (RLS):

| Nível | Quem vê |
|---|---|
| `publico` | Qualquer pessoa (lore do cenário; aparece até sem login). |
| `mesa` | Todos os membros daquela mesa. |
| `autor_mestre` | Apenas o autor e o mestre da mesa (segredos, tramas pessoais). |
| `privado` | Apenas o autor. |
| `mestre` | Apenas o(s) mestre(s) da mesa (área privada do mestre: planejamento, roteiros, NPCs ocultos). |

Combinado com `estado` (rascunho/publicado), cobre todo o seu fluxo: o mestre guarda planejamento indefinidamente em rascunho; o jogador publica um background como `mesa` ou esconde um objetivo oculto como `autor_mestre`.

## Papéis

- **Admin** (global): você — administra mundos e usuários.
- **Mestre** (por mesa): cria a mesa, tem a área privada, registra sessões, gere o conteúdo da mesa.
- **Jogador** (por mesa): cria personagens e publicações, contribui com o mundo, controla a visibilidade do que cria.

O papel é **por mesa** (tabela `mesa_membros`): a mesma pessoa pode ser mestre numa mesa e jogador em outra.

## Referências entre textos e mídia

- **Referências:** continua valendo o `[[Título]]` (link entre publicações); além disso há uma tabela `publicacao_relacoes` para ligações explícitas ("aparece em", "filho de" etc.).
- **Mídia:** tabela `midias` aceita **imagem, vídeo, link ou arquivo** — tanto URL externa (YouTube, imagem de outro site) quanto upload real no Supabase Storage.

## Mapas (região, cidade, masmorra)

Mapas são publicações do tipo `mapa` com uma **imagem** (a `categoria` distingue região/cidade/masmorra). Por serem publicações, herdam tudo: visibilidade (um mapa de masmorra pode ficar `mestre` até ser revelado, depois virar `mesa`), tags, referências e a área dedicada de **Mapas** no mundo e na mesa. Cards de personagens, locais e mapas exibem imagem e são clicáveis.

## Roadmap de construção (incremental)

Cada etapa entrega algo usável:

1. **P1 — Fundação:** criar projeto Supabase, aplicar o `plataforma/schema.sql` (tabelas + RLS), ativar login. Seed do mundo "Mares de Sangue".
2. **P2 — Mundos e mesas:** telas de login, criar mundo, criar mesa, convidar/entrar como jogador.
3. **P3 — Publicações:** criar/editar/listar publicações com tipo, tags, estado e visibilidade (o núcleo). Área privada do mestre.
4. **P4 — Personagens:** página de personagem (história, aparência, diário, relações).
5. **P5 — Registros de sessão:** crônica e resumo (acontecimentos, XP, recompensas, próximos objetivos).
6. **P6 — Mídia e referências:** upload de imagens/vídeos, links, `[[referências]]` e busca.
7. **P7 — Migração do cânone:** trazer os `.md` atuais para o banco como publicações `publico`.

A wiki estática atual continua no ar durante toda a transição.

## O que depende de você

Criar uma conta gratuita no **Supabase** (e, na hora certa, rodar o `plataforma/schema.sql` no painel SQL). O resto eu monto. Detalhes de execução virão a cada etapa.
