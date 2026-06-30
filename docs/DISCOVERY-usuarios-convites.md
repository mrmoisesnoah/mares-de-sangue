# Discovery — Área de usuários, apelido e convites

> Documento de **discovery** (ainda não é implementação). Objetivo: definir, com o autor, a forma mais simples de **conectar mestres e jogadores em escala** (centenas/milhares de usuários e mesas), sem chat e sem perder o tom simples do site. Saída deste doc: o autor escolhe a abordagem → vira tarefas de desenvolvimento no próximo handoff.

## 1. O problema (na voz do usuário)

Hoje o fluxo de entrar numa mesa tem três furos quando o site cresce:

1. **O jogador não enxerga as mesas.** Ele entra no mundo, mas mesas privadas não aparecem — e ele não tem como sinalizar “cheguei, me convida”.
2. **O mestre não acha o jogador.** O único jeito de adicionar alguém é um `<select>` com **todos** os usuários registrados. Com 100–1000 contas (e nomes repetidos), localizar a pessoa certa é inviável.
3. **Não há um canal direto** mestre ⇄ jogador. Existe o sino de notificações, mas ele só dispara como efeito colateral de outras ações; não é um lugar para “convidar” ou “solicitar”.

## 2. Princípios (o que NÃO vamos fazer)

Fiel à filosofia do projeto: **simplicidade, custo zero, sem chat**. Reaproveitar o que já existe (notificações + `pedidos_acesso` + Supabase/RLS). Nada de mensageria em tempo real, presença online, ou rede social. O alvo é **um aperto de mão**: o jogador se identifica de forma inequívoca, o mestre convida, e pronto.

## 3. As duas direções de conexão

A solução tem dois fluxos complementares, os dois apoiados em **notificação + uma linha numa tabela**:

**A) Convite — mestre → jogador (fluxo principal, à prova de escala).**
O jogador passa ao mestre um identificador inequívoco (ver §4). O mestre, na aba *Jogadores da mesa*, digita esse identificador numa **caixa de busca** (não mais um `<select>` gigante), acha **a pessoa certa**, clica **Convidar**. O jogador recebe a notificação “Você foi convidado para a mesa X” com **Aceitar / Recusar**. Não exige navegar por mil mesas.

**B) Solicitação — jogador → mestre (fluxo secundário, já meio pronto).**
Quando o jogador **consegue ver** a mesa (pública) ou recebeu um **link/código de convite da mesa**, ele abre e clica **Pedir acesso** (já existe). O mestre aprova na *Área do Mestre / Editar mesa* (corrigido nesta rodada para a notificação levar direto ao lugar certo).

> Os dois fluxos terminam no mesmo lugar: uma linha em `mesa_membros`. A diferença é **quem inicia**.

## 4. Como o jogador se identifica (a decisão central)

Esse é o ponto que precisa da sua escolha. O problema dos **nomes repetidos** exige um identificador que não colida. Três caminhos:

**Opção A — `@handle` único (estilo Discord/Twitter).** Cada usuário escolhe um nome de usuário único (`@moises`). O mestre busca pelo handle exato. _Prós:_ inequívoco e familiar. _Contras:_ exige tela para “reivindicar” o handle, tratar conflitos, e gerar um handle automático para os usuários atuais.

**Opção B — Código de usuário copiável.** Cada conta tem um **código curto** (derivado do `id`, ex.: `U-7F3A9C`). O usuário copia e manda pro mestre; o mestre cola para achar exatamente aquela conta. _Prós:_ zero colisão, **zero tela de reivindicação**, trivial de implementar. _Contras:_ menos memorável (mas é copiar/colar).

**Opção C — Busca por apelido + desambiguação visual.** O usuário põe um **apelido** livre (“como quer ser chamado”). O mestre digita o apelido e vê uma **lista com avatar + código** de cada resultado para escolher a pessoa certa. _Prós:_ o mais simples e amigável. _Contras:_ com nomes iguais, ainda exige o mestre conferir o código/avatar.

**Recomendação (Qualidade + Arquiteto): C + B juntos.** Adicionar o campo **apelido** (amigável, vira o nome exibido no site todo) **e** um **código de usuário** copiável (preciso). A busca do mestre mostra resultados por apelido **com avatar + código** ao lado; e há um campo “colar código” para acerto exato. Resolve colisão **sem** a burocracia de handle único. Se mais tarde quisermos `@handle`, ele entra por cima sem retrabalho.

## 5. Modelo de dados proposto (mínimo)

Reaproveitando o máximo:

- **`profiles`**: adicionar `apelido text` (exibição) e, opcionalmente, índice para busca. O **código** não precisa de coluna — é o `id` formatado (`'U-'||upper(substr(id::text,1,6))`), buscável por uma função.
- **Convites (mestre → jogador)**: tabela enxuta `convites(id, mesa_id, convidado_id, criado_por, estado['pendente'|'aceito'|'recusado'], criado_em)`. (Alternativa: reusar `pedidos_acesso` com uma coluna `direcao`; a tabela própria é mais legível.)
- **Busca**: função `buscar_usuarios(termo)` **SECURITY DEFINER**, retorna `id, apelido, nome, avatar_url` e o código — **nunca e-mail** —, com `limit 20` e match por prefixo de apelido/nome ou código exato. (Privacidade: e-mail não é pesquisável por terceiros.)
- **Aceitar convite**: função `aceitar_convite(convite_id)` **SECURITY DEFINER** que confere que o convite é do próprio usuário e está pendente, então insere em `mesa_membros` (necessário porque o jogador não é mestre e a RLS de `mesa_membros` só deixa o mestre inserir). Lembrar do `notify pgrst, 'reload schema';`.

## 6. Onde isso aparece na interface

- **Perfil**: novo campo **“Como quer ser chamado (apelido)”** + bloco **“Seu código”** com botão *Copiar* e a frase “passe seu apelido ou código ao mestre para ser convidado”.
- **Editar mesa / Área do Mestre → Jogadores**: o `<select>` de todos vira uma **caixa de busca** (apelido ou código) com lista de resultados (avatar + apelido + código + botão **Convidar**). Convites pendentes aparecem listados com “aguardando resposta”.
- **Notificações / “Meus convites”**: o sino ganha convites com **Aceitar / Recusar** direto no item (atende o seu pedido “ou já permito na mensagem, ou vou pro lugar certo”). Uma página simples **#/convites** lista os pendentes.

## 7. Faseamento sugerido (incremental)

1. **Fase 1 — Identidade:** campo `apelido` no perfil + código copiável + apelido como nome exibido. (Migração curta + ajustes de front.)
2. **Fase 2 — Busca do mestre:** trocar o `<select>` por busca por apelido/código (função `buscar_usuarios`). Já melhora muito a escala.
3. **Fase 3 — Convites:** tabela `convites` + `aceitar_convite` + itens de Aceitar/Recusar no sino + página #/convites.
4. **Fase 4 (opcional):** código/link de convite **da mesa** (o mestre compartilha; o jogador resgata) — cobre o caso B sem o jogador depender de ver a mesa.

Cada fase é entregável sozinha e não quebra o que existe.

## 8. Decisões que dependem de você

1. **Identificação:** confirma a recomendação **apelido + código** (Opção C+B)? Ou prefere `@handle` único (A)?
2. **Apelido vira o nome exibido** no site (com fallback para o nome atual)? 
3. **Privacidade do e-mail:** concorda em **não** permitir busca por e-mail (só apelido/código)?
4. **Profundidade agora:** quer começar só pela **Fase 1+2** (identidade + busca) e deixar convites para depois, ou já emendar a **Fase 3**?

> Mockup visual acompanha este doc (`prototipo-usuarios-convites.html`) ilustrando perfil, busca do mestre e convites no sino.
