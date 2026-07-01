# Migrations — ordem de execução (Supabase → SQL Editor)

Banco da plataforma (Postgres + RLS). Para montar do zero, rode **nesta ordem**. Para um banco já existente, rode só as que ainda faltam — todas são **idempotentes** (`if not exists`, `drop policy if exists` antes de `create policy`), então repetir não quebra.

## Base
1. `plataforma/schema.sql` — tabelas centrais (mundos, mesas, publicacoes, profiles, mesa_membros) + RLS de visibilidade.
2. `plataforma/storage.sql` — bucket público `midias` + políticas de upload.
3. `plataforma/migracao.sql` — (opcional) importa os `.md` de `conteudo/` como publicações.

## Evolução (rodar em ordem)
4. `migracao-perfil-e-mesas.sql` — colunas de perfil (avatar/bio/epíteto) + trigger de mesa.
5. `migracao-acesso-mesas.sql` — acesso público/leitura a mesas.
6. `migracao-permissoes.sql` — colaboradores de mundo / permissões.
7. `migracao-personagens.sql` e `migracao-personagens-tipo.sql` — personagens + NPC×jogador.
8. `migracao-jornais.sql` — jornais e escritores.
9. `migracao-sessoes.sql` — sessões de mesa.
10. `migracao-recompensas.sql` — XP/itens/prêmios por sessão.
11. `migracao-pedidos-acesso.sql` — pedidos de acesso (aprovação).
12. `migracao-linha-do-tempo.sql` e `migracao-timeline-v2.sql` — eventos + períodos (agrupamento/retrátil).
13. `migracao-evento-links.sql` — vínculo de conteúdos a eventos.

## Recentes (Blocos 1–4)
14. `migracao-favoritos.sql` — tabela `favoritos` (acesso rápido pessoal).
15. `migracao-ficha-arquivo.sql` — colunas `arquivo_url`/`arquivo_nome` em `publicacoes` (anexo da ficha em PDF/Word).
16. `migracao-temas.sql` — coluna `tema` em `mundos` (tema visual do mundo).
17. `migracao-comentarios-notificacoes.sql` — tabelas `comentarios` e `notificacoes` + RLS.

## Notas de segurança (revisão de código)
- **`esc()`** escapa `& < > "` — evita injeção por atributo (XSS) em formulários, títulos e URLs de imagem.
- **`notificacoes` (insert):** qualquer usuário autenticado pode criar notificação para outro `user_id` — é proposital (o comentarista precisa avisar o dono do conteúdo). Aceitável numa comunidade pequena/confiável; dá para endurecer depois com uma função `SECURITY DEFINER`.
- **`comentarios` (select):** leitura pública. OK para uma wiki; pode-se restringir à visibilidade do alvo no futuro.
- Funções `SECURITY DEFINER` no Postgres usam `set search_path = public` (senão "relation does not exist").

## Subtítulo do mundo
18. `migracao-mundo-subtitulo.sql` — coluna `subtitulo` em `mundos` (linha curta sob o card; descrição completa fica no hero).

## Subtítulo geral (mesa/publicação/sessão)
19. `migracao-subtitulo-geral.sql` — coluna `subtitulo` em `mesas`, `publicacoes` e `sessoes` (linha curta exibida no card).

## Editor visual (Quill) no corpo da publicação
20. `migracao-publicacoes-formato.sql` — coluna `formato` em `publicacoes` (`md` = Markdown antigo; `html` = HTML do editor Quill). Default `md`, então conteúdo existente segue renderizando como antes. O front decide a renderização por esse campo (`renderCorpo`).

## Imagem da sessão
21. `migracao-sessoes-imagem.sql` — coluna `imagem_url` em `sessoes` (capa opcional da sessão).

## Permissão de personagem por mesa
22. `migracao-personagem-membro.sql` — endurece `pers_insert`: personagem ligado a uma **mesa** exige `is_membro(mesa_id)` (antes qualquer autenticado criava personagem em qualquer mesa). Personagem livre no mundo (`mesa_id IS NULL`) mantém o comportamento. Idempotente.

## Área de usuários — apelido, busca e convites
23. `migracao-usuarios-convites.sql` — **Fase 1** coluna `profiles.apelido` (nome de exibição, com índice). **Fase 2** função `buscar_usuarios(termo)` (SECURITY DEFINER): e-mail é match **exato** e **nunca** retornado; apelido/nome por prefixo; `limit 20`; só autenticado. **Fase 3** tabela `convites` (mestre→jogador) + RLS, `aceitar_convite(p_convite)` (insere em `mesa_membros` via DEFINER, pois o jogador não pode), `meus_convites()` (lista pendentes já com nome de mesa/mundo/convidante). Termina com `notify pgrst, 'reload schema';`. Idempotente.
