# CLAUDE.md — Contexto do projeto para assistentes de IA

Orienta o Claude (ou outra IA) que ajude a manter/evoluir o projeto **Mares de Sangue**. Leia antes de propor mudanças.

## O que é

Site wiki/enciclopédia de um cenário de RPG de mesa. Conteúdo em Markdown + front-matter; um gerador Python produz um site estático. Sem servidor, sem banco (até a Fase 4). Refs: World Anvil (estrutura) e maresdesangue.blogspot.com (conteúdo).

## Princípio inegociável: SIMPLICIDADE

Prioridade máxima é simplicidade, baixo/zero custo e fácil manutenção por iniciantes. **Sempre prefira a solução mais simples que resolve.** Não introduza frameworks/dependências/serviços sem necessidade real e justificada. Não assuma complexidade prematuramente.

## Arquitetura (resumo)

- **Conteúdo:** `conteudo/` — arquivos `.md` com front-matter YAML. **Fonte única de verdade.**
- **Gerador:** `gerar_site.py` (stdlib + `markdown` + `pyyaml`). Lê os `.md`, renderiza HTML, monta navegação/busca/tags.
- **Saída:** `site/` (público) e `site-mestre/` (tudo, com 🔒). Reconstruídos a cada execução; não versionar (estão no `.gitignore`).
- **Tema:** CSS embutido no gerador (constante `CSS`), estética de livro de fantasia.
- **Deploy:** `.github/workflows/deploy.yml` builda e publica no GitHub Pages a cada push.
- **Edição multiusuário:** `admin/` (Decap CMS) — Fase 4.

## Front-matter (esquema)

```yaml
---
titulo: "..."
tipo: canone | lore | campanha | sessao | conto | jornal | indice
cenario: "Mar de Sangue"
campanha: "..."          # opcional
status: publico | privado
audiencia: jogadores | mestre
data: AAAA-MM-DD         # opcional
origem: blog             # opcional
tags: ["...", "..."]
---
```

Site **público** mostra só `status: publico` e `audiencia != mestre`. Detalhes em `docs/FRONT-MATTER.md`.

## Arquitetura de informação pública (decisão do autor — NÃO mudar sem pedido)

- **Publicado:** Cânone do Mundo (01), Lore do Universo (02), Ecos na Cidade dos Corvos (03 — campanha atual), Contos (04), **Jornais** (qualquer `tipo: jornal`, ex.: A Trombeta de Dagor), Panimalia (06).
- **NÃO publicado** (histórico/base, só na edição do mestre): Blog bruto (05, exceto jornais), Sombras Vindas do Tempo (07), mesas antigas.
- **Lore do Universo** deve, com o tempo, **fundir** Lore Original (02) + textos exclusivos do Blog (05). Tarefa editorial pendente — com revisão do autor.
- **Jornais:** A Trombeta de Dagor é o jornal canônico; o modelo prevê novos jornais por mesa (Fase 4 / CMS).

## Cânone — grafias e fatos confirmados

- **Exar Khun** é a grafia correta (não "Exar Kun").
- **Dranor** = reino/Império Dranoriano (região). **Dranorak** = a capital, em Dranor. Entidades distintas.
- Divergências abertas (decisão do autor): datas da Aliança dos Suicidas; origem dos planos de eco (Agrestia/Pendor); grafias Erevan/Erol, Gaurhoth/Gauroth, Czar StormRange/StormBorn.

## Fluxo de trabalho

- O autor (Moisés) autorizou seguir o roadmap (`docs/ROADMAP.md`) sem confirmar cada etapa. Pare só para algo irreversível/destrutivo ou que exija conta/credencial dele.
- **Nunca reescreva a lore sem necessidade** — preserve o texto original. Cânone é decisão do autor.
- Ao mexer no `gerar_site.py`: rode `python gerar_site.py` e `--mestre`, confira `index.html`, `tags.html`, `busca.html` e alguns artigos; cheque links quebrados.
- Nomes de pastas têm espaços/acentos — cite caminhos entre aspas.

## Estado atual

Fases 0–3 concluídas; IA pública refinada; repositório autocontido montado; Fase 4 (CMS git no GitHub + deploy) pronta para subir. Ver `docs/ROADMAP.md`.
