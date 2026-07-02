# DISCOVERY / BACKLOG — Mundos privados + convite de acesso ao mundo

> **Estado:** backlog (desenho). **Nada implementado.** Autossuficiente para a próxima sessão codar. Segue o PROCESSO-AGENTES. Relaciona-se com `DISCOVERY-amigos-chat.md` (foco: comunicação Mestre⇄Jogador) e com o painel admin (visibilidade de mundos).

## 1. Pedido (N1)
Alguns **mundos poderão ser privados**. Para esses, haverá **mecânica de convite** para dar acesso a usuários — no mesmo espírito dos convites de mesa (buscar por apelido/e-mail → convidar → aceitar pelo sino).

## 2. Estado atual (o que já existe)
- `mundos.publico` (boolean, default **true**) + `mundos.dono_id`. RLS `mundo_select = publico OR dono_id=auth.uid() OR is_admin()`.
- **Consequência hoje:** mundo privado é visível **só para o dono e admin**. Não há tabela de membros/colaboradores de mundo (a menção a "colaboradores de mundo" no HANDOFF §5 ainda **não existe** no schema).
- **Convites** existem só para **mesa** (`convites.mesa_id` NOT NULL; `aceitar_convite`/`meus_convites`; RLS por `is_mestre`). **`buscar_usuarios`** (apelido/nome/e-mail mascarado) e **`notificacoes`/sino** já servem de base.
- `pedir_acesso('mundo',id)` já existe (lado do **pedido** jogador→dono, com aprovação). Falta o lado do **convite** dono→usuário e, sobretudo, **a tabela que concede acesso** a um mundo privado.

## 3. Proposta (N4 — arquitetura)
### 3.1 Conceder acesso: `mundo_membros`
```sql
create table if not exists mundo_membros (
  mundo_id uuid references mundos(id) on delete cascade,
  user_id  uuid references profiles(id) on delete cascade,
  papel    text not null default 'leitor' check (papel in ('leitor','colaborador')),
  criado_em timestamptz default now(),
  primary key (mundo_id, user_id)
);
create index if not exists idx_mundo_membros_user on mundo_membros(user_id);
```
- `leitor` = enxerga o mundo privado e seu conteúdo **público**; `colaborador` = também pode **criar conteúdo** no mundo (futuro).
- Helper `is_membro_mundo(p_mundo)` SECURITY DEFINER (`set search_path=public`).

### 3.2 RLS a ajustar
- `mundo_select`: `publico OR dono_id=auth.uid() OR is_membro_mundo(id) OR is_admin()`.
- **Conteúdo do mundo privado:** `publicacoes`/`personagens`/`jornais`/`mapas`/linha do tempo precisam deixar o **membro do mundo** ver o conteúdo **público** daquele mundo (hoje `pub_select` usa `visibilidade + is_membro(mesa) + is_dono_mundo`). Acrescentar `is_membro_mundo(mundo_id)` na regra de leitura do conteúdo `publico/publicado`. Revisar caso a caso (segredos de mestre continuam por `visibilidade`).

### 3.3 Convite de acesso ao mundo (reaproveitar o padrão de mesa)
Duas opções — **recomendada: tabela paralela** (menor risco que mexer no `convites` de mesa em produção):
```sql
create table if not exists mundo_convites (
  id uuid primary key default gen_random_uuid(),
  mundo_id uuid not null references mundos(id) on delete cascade,
  convidado_id uuid not null references profiles(id) on delete cascade,
  papel text not null default 'leitor' check (papel in ('leitor','colaborador')),
  criado_por uuid not null references profiles(id),
  estado text not null default 'pendente' check (estado in ('pendente','aceito','recusado')),
  criado_em timestamptz default now(),
  unique (mundo_id, convidado_id)
);
```
- RLS: convidado/dono/admin veem; **dono do mundo** insere/cancela; convidado atualiza o próprio.
- RPCs (espelhando os de mesa): `aceitar_convite_mundo(p_id)` (insere em `mundo_membros` via DEFINER, pois o convidado não pode) e `meus_convites_mundo()` (lista pendentes com nome do mundo, contornando a RLS de mundo que o convidado ainda não vê). `notify pgrst,'reload schema';` no fim.
- *(Alternativa: generalizar `convites` com `mundo_id` nullable + `mesa_id` nullable + CHECK "exatamente um". Mais DRY, porém mexe numa tabela em uso — deixar para depois se quiser unificar.)*

### 3.4 Front (N3/N5)
- **Editar mundo:** toggle **Público/Privado** (campo `publico` — já existe no banco; expor no form de mundo). Quando privado, mostrar aviso "só convidados veem".
- **Área "Membros do Mundo"** (espelha "Jogadores da Mesa"): busca `buscar_usuarios` → **✉ Convidar** (papel leitor/colaborador), lista de convites pendentes (cancelar) e de membros (remover). Só para o **dono** (e admin).
- **Convidado:** notificação `tipo='convite_mundo'` → roteia para `#/convites` (ou aba própria) → **Aceitar/Recusar**; ao aceitar vira `mundo_membros` e o mundo passa a aparecer para ele.
- **Descoberta:** mundo privado **não** aparece na Home pública nem no seletor para quem não é membro (a RLS já garante; o front só reflete).
- **Painel admin:** já lista/filtra público×privado (feito). Super-admin pode alternar visibilidade/transferir dono no futuro.

## 4. Faseamento sugerido
1. `mundo_membros` + `is_membro_mundo` + ajuste do `mundo_select` + toggle Público/Privado no form. (Já dá mundos privados com membros adicionados manualmente/admin.)
2. `mundo_convites` + RPCs + Área "Membros do Mundo" + fluxo de aceitar no sino. (Convite self-service do dono.)
3. Ajuste fino da RLS de **conteúdo** para membros do mundo (ver 3.2) + papel `colaborador` criando conteúdo.

## 5. Decisões pendentes do autor
1. **Papéis de membro do mundo:** só `leitor`, ou já `leitor`+`colaborador` (quem pode criar conteúdo)?
2. **Convite paralelo (`mundo_convites`)** — recomendado — ou **unificar** em `convites` com `mundo_id`/`mesa_id`?
3. Um mundo privado pode receber **pedido de acesso** (jogador→dono, via `pedir_acesso` já existente) além do convite, ou só convite?
4. Mundo privado **lista as mesas/personagens públicos** aos membros, ou o dono controla item a item pela visibilidade?
