# DISCOVERY — Área de Usuários / Amigos + Chat

> **Estado:** discovery (desenho). **Nada implementado ainda.** Este doc é autossuficiente para a próxima sessão codar sem re-derivar. Segue o PROCESSO-AGENTES. Pré-requisito de contexto: `CLAUDE.md` + `docs/HANDOFF.md` (tiers de admin + `buscar_usuarios` + `convites` + `notificacoes` já existem).

## 1. Pedido do autor (N1 — voz do usuário)
- Uma **área de usuários** para **adicionar amigos** e ter amigos + perfis de **fácil acesso**.
- Algo mais **familiar a um chat**; um dia, **chat de verdade** (mensagens diretas).
- Saber **quão custoso** é e os **limites** por estar em **GitHub Pages**.

## 1.1 FOCO / PROPÓSITO (essencial — norteia tudo)
**Isto NÃO é rede social genérica.** Amigos e chat existem para **facilitar a comunicação entre Mestres e Jogadores**, a serviço do jogo:
- **Convites para mesas** — mestre acha o jogador e convida com 1 clique; jogador pede acesso e conversa com o mestre. (Já existe `convites` mestre→mesa + `pedir acesso` jogador→mestre; amigos/chat tornam esse contato direto e fácil.)
- **Disponibilização de conteúdo** — mandar para o jogador (ou para a mesa) um link de publicação/personagem/jornal/mapa/sessão; combinar segredos, entregar ficha, avisar de nova edição do jornal.
- **Coordenação da mesa** — marcar sessão, tirar dúvida, recado rápido do mestre para os jogadores.

**Implicações de desenho:**
1. **Contexto de mesa é 1ª classe.** Além de DM 1:1, considerar **chat de mesa (grupo)** — um canal por mesa com mestre + jogadores — porque é onde a comunicação do jogo acontece. Provavelmente **mais valioso que DM avulso**.
2. **"Amigos" = contatos do jogo**, não popularidade. Servem para o mestre reencontrar jogadores e vice-versa, e para abrir DM. Manter simples (sem feed, sem curtidas).
3. **Compartilhar conteúdo dentro do chat** deve ser trivial: colar/mandar um link interno (`#/pub/…`, `#/personagem/…`) que renderiza como cartão clicável, respeitando a **visibilidade/RLS** de quem recebe (não vaza segredo do mestre).
4. **Integração com o que já existe:** o botão "Convidar" (busca de usuários da mesa) e "Pedir acesso" devem conversar com amigos/chat (ex.: ao convidar, poder mandar um recado; ao aceitar, abrir o canal da mesa).

## 2. Realidade de arquitetura (não esbarra no GitHub Pages)
- **GitHub Pages** só serve estático (HTML/CSS/JS/imagens) — **não** roda backend. Banda ~100GB/mês, site até 1GB. Nossos assets = centenas de KB → folga enorme. **Não é o limitante.**
- Quem manda em contas/dados/tempo-real é o **Supabase**. Free: **500MB** Postgres, **1GB** Storage, **5GB** egress/mês, **50.000 MAU**, **Realtime: 200 conexões simultâneas + 2 mi msgs/mês (256KB/msg)**. **Atenção:** projeto free **pausa após ~1 semana de inatividade** (Pro US$25/mês não pausa + backups + limites maiores).
- **Conclusão:** amigos = barato, cabe folgado no free. Chat = viável no free para o grupo (dezenas de pessoas), com o cuidado da **pausa por inatividade** (chat quer o projeto "acordado").

## 3. Reaproveitamento (já existe no projeto)
- **`buscar_usuarios(termo, p_limit, p_offset)`** SECURITY DEFINER — busca por prefixo em apelido/nome/e-mail, retorna `id,nome,apelido,epiteto,avatar_url,email_mascara,total` (e-mail nunca inteiro). Usar para achar pessoas a adicionar.
- **`convites`** (mestre→mesa) e **`notificacoes`** (+ sino com poll de 45s: `carregarNotifs`/`pintarSino`/`iniciarPollNotifs`) — reaproveitar o padrão de notificação e o roteamento do sino (`abrirNotif`).
- **Componente `abas(gid,defs)`** — usar para a tela de amigos e a de chat.
- **`exib(p)`** = apelido||nome||'Aventureiro' (nome de exibição no site).

---

## 4. FASE A — Amigos (BAIXO custo — começar por aqui)

### 4.1 Banco (`migracao-amigos.sql`, idempotente)
```sql
create table if not exists amizades (
  id            uuid primary key default gen_random_uuid(),
  solicitante_id uuid not null references profiles(id) on delete cascade,
  destinatario_id uuid not null references profiles(id) on delete cascade,
  estado        text not null default 'pendente'
                check (estado in ('pendente','aceita','recusada','bloqueada')),
  criado_em     timestamptz default now(),
  atualizado_em timestamptz default now(),
  check (solicitante_id <> destinatario_id),
  unique (solicitante_id, destinatario_id)
);
create index if not exists idx_amizade_dest on amizades(destinatario_id, estado);
create index if not exists idx_amizade_sol  on amizades(solicitante_id, estado);

alter table amizades enable row level security;
-- cada lado vê as próprias amizades
drop policy if exists amiz_select on amizades;
create policy amiz_select on amizades for select
  using (solicitante_id = auth.uid() or destinatario_id = auth.uid() or is_admin());
-- (insert/update/delete via RPC DEFINER abaixo — mais controlado; pode-se abrir depois)
```

### 4.2 RPCs (SECURITY DEFINER, `set search_path=public`)
- `pedir_amizade(p_user uuid)` — cria `pendente` (ou reativa recusada). Bloqueia auto-amizade e duplicata invertida (checar par nos dois sentidos). Notifica o destinatário (`notificacoes` tipo `'amizade'`, link para `#/amigos`).
- `responder_amizade(p_id uuid, p_aceitar bool)` — só o **destinatário**; vira `aceita`/`recusada`; se aceita, notifica o solicitante (tipo `'amigo_aceito'`).
- `remover_amizade(p_user uuid)` — apaga a amizade entre auth.uid() e p_user (qualquer sentido).
- `listar_amigos()` — retorna os perfis (id, apelido/nome, epíteto, avatar) das amizades **aceitas** do usuário (resolve o "outro lado" nos dois sentidos), com contorno da RLS de `profiles` (já é select público, então simples).
- `listar_pedidos_amizade()` — pendentes **recebidos** (destinatario=auth.uid()) com dados do solicitante.
- `amizade_status(p_user)` — `nenhum|pendente_enviado|pendente_recebido|amigos` para pintar o botão no perfil.
- Terminar a migration com `notify pgrst,'reload schema';`.

### 4.3 Front (`app.js`)
- Nova rota **`amigos`/`telaAmigos`** usando `abas()`: **Amigos** (lista com avatar → clique vai ao perfil `#/autor/<id>`; botão remover), **Pedidos** (aceitar/recusar), **Buscar** (reusa `buscar_usuarios` como a caixa de convites da mesa; botão "Adicionar amigo" → `pedir_amizade`).
- **Botão no perfil** (`telaAutor`): "Adicionar amigo / Pedido enviado / Amigos ✓ / Aceitar pedido" conforme `amizade_status`.
- **Atalhos:** link no menu do usuário (`👥 Amigos`) e/ou card no **TUDO MEU!**.
- **Notificações:** `abrirNotif` roteia tipos `amizade`/`amigo_aceito` para `#/amigos`.
- **Estados** vazio/carregando/erro; 6 temas (CSS por variáveis). Dados irrisórios → cabe no free.

---

## 5. FASE B — Chat / DM (MÉDIO, viável no free)

### 5.1 Banco (`migracao-chat.sql`) — começar 1:1, deixar porta p/ grupo
```sql
create table if not exists conversas (
  id uuid primary key default gen_random_uuid(),
  tipo text not null default 'dm' check (tipo in ('dm','grupo')),
  criado_em timestamptz default now()
);
create table if not exists conversa_membros (
  conversa_id uuid references conversas(id) on delete cascade,
  user_id     uuid references profiles(id) on delete cascade,
  ultima_leitura timestamptz default now(),
  primary key (conversa_id, user_id)
);
create table if not exists mensagens (
  id uuid primary key default gen_random_uuid(),
  conversa_id uuid not null references conversas(id) on delete cascade,
  autor_id uuid not null references profiles(id) on delete cascade,
  corpo text not null,
  criado_em timestamptz default now()
);
create index if not exists idx_msg_conversa on mensagens(conversa_id, criado_em);
-- RLS: só membros veem a conversa/mensagens; insert de msg só se membro.
-- helper is_membro_conversa(cid) SECURITY DEFINER; políticas usando-o.
```
- RPC `abrir_conversa_dm(p_user)` — retorna o `conversa_id` de DM entre auth.uid() e p_user (cria se não existir). **Só entre amigos** (checar amizade aceita). SECURITY DEFINER.
- `enviar_mensagem(p_conversa, p_corpo)` (ou insert direto com RLS) + `marcar_lida(p_conversa)` (atualiza `ultima_leitura`).
- `listar_conversas()` — conversas do usuário com último trecho + contagem de não-lidas (via `ultima_leitura`).

### 5.2 Faseamento da entrega (custo crescente)
1. **DM assíncrono (B1)** — enviar/listar mensagens, badge de não-lidas via **poll** (reusar/estender o poll de 45s das notificações). Sem realtime. **Barato.**
2. **Polling curto na conversa aberta (B2)** — quando a tela do chat está aberta, poll de ~5–8s. Ainda barato, sem realtime.
3. **Supabase Realtime (B3)** — Postgres Changes na tabela `mensagens` filtrado por conversa; só quando o uso justificar.

### 5.3 Riscos/cuidados
- **Pausa por inatividade** (free): chat diário quer o projeto acordado → keep-alive (cron simples pingando o Supabase) ou migrar p/ **Pro US$25** se virar uso diário.
- **Imagens no chat** → Storage (1GB free); texto é irrisório no egress. Reusar `uploadArquivo`.
- **Moderação/retenção** de mensagens (admin já tem `is_admin()`; dá p/ política de limpeza).
- **256KB/msg** no Realtime — mensagens são texto, sem problema.

---

## 6. Recomendação (Qualidade) — orientada ao foco mestre⇄jogador
Ordem sugerida:
1. **Fase A — Contatos/Amigos** ligados ao fluxo de mesa (achar/convidar/pedir acesso já ficam mais fáceis).
2. **Chat de MESA (grupo)** — canal por mesa (mestre + jogadores) para recados, coordenação e **compartilhar conteúdo** (cartão de link interno respeitando RLS). *Priorizado sobre DM avulso por ser onde o jogo acontece.*
3. **DM 1:1** (mestre⇄jogador / entre amigos) — assíncrono primeiro.
4. **Polling** na conversa aberta → **Realtime** só quando o uso justificar.

Avaliar **Pro (US$25)** só quando quiser chat 24/7 + backups. Tudo cabe no plano grátis para o grupo, respeitando o cuidado da pausa por inatividade. Nada disso esbarra no GitHub Pages. **Chat de mesa reaproveita `mesa_membros`** (já define quem participa) — RLS e "quem vê o canal" saem quase de graça.

## 7. Decisões pendentes do autor (antes de codar)
1. **Amigos primeiro** e chat depois (recomendado), ou já emendar o DM assíncrono?
2. **Privacidade:** quem pode te mandar pedido de amizade — qualquer um, ou só quem te acha por apelido/e-mail? (Padrão sugerido: qualquer autenticado pode pedir; você aceita/recusa.)
3. **Prioridade:** começar pelo **chat de MESA (grupo)** — recomendado, pois é o foco mestre⇄jogador — ou pelo **DM 1:1**? (Sugestão: chat de mesa primeiro; membros da mesa conversam sem precisar de amizade, via `mesa_membros`.)
4. **Bloquear usuário** já na Fase A, ou depois?
5. **Pro vs free**: aceitar o risco de pausa no free por enquanto (sim, recomendado — só reavaliar quando virar uso diário)?
