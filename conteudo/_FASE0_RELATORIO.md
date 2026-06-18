# Fase 0 — Consolidação do Conteúdo · Relatório

*Mares de Sangue · executado em 17/06/2026*

Esta fase preparou o conteúdo para virar site, **sem reescrever nada** — só organizou metadados e padronizou grafia. Backup completo dos `.md` foi feito antes de qualquer alteração.

## O que foi feito

**1. Fonte única de verdade.** A pasta `Cenario RPG - Mar de Sangue (Organizado)/` é a oficial. A gêmea `Cenário RPG - Dagorcain e o Mundo de Skard.` é uma cópia idêntica (mesmos 96 .md, conteúdo byte a byte) e **pode ser apagada por você** — antes disso, o único arquivo exclusivo dela (`_AUDITORIA_MIGRACAO.md`) já foi copiado para cá.

**2. Padronização de grafia.** `Exar Kun` → `Exar Khun` em 15 arquivos (conteúdo + 2 nomes de arquivo). Confirmado também que **Dranor** (reino) e **Dranorak** (capital) são entidades distintas, não variação de grafia.

**3. Front-matter YAML em 96 arquivos.** Cada `.md` ganhou um cabeçalho de metadados legível por qualquer wiki/gerador de site:

```yaml
---
titulo: "..."
tipo: canone | lore | campanha | sessao | conto | jornal | indice
cenario: "Mar de Sangue"
campanha: "Ecos na Cidade dos Corvos"   # quando aplicável
status: publico | privado
audiencia: jogadores | mestre
data: 2013-07-23                          # blog e sessões
origem: blog                             # posts recuperados do blog
tags: ["..."]
---
```

Regras aplicadas: arquivos com "MESTRE", "não leia/ler", notas de mestre, planejamento e documentos de campanha → `status: privado` / `audiencia: mestre`. Os demais → `publico` / `jogadores`. Isso já implementa o requisito de **rascunho/privado/público** das instruções e a separação **jogador × mestre**.

## Distribuição resultante

| tipo | qtd | observação |
|---|---|---|
| lore | ~40 | textos históricos + blog de história |
| jornal | 22 | série *A Trombeta de Dagor* |
| campanha | 11 | Ecos + Sombras Vindas do Tempo |
| conto | 5 | contos e cultura |
| canone | 3 | lore oficial vigente |
| sessao | 6 | Sessão 1 de Ecos |
| indice | 2 | índice mestre + índice do blog |

Privados/mestre: ~9 arquivos. Públicos/jogadores: o restante.

## Arquivos de apoio gerados

- `backup_md_*.zip` — backup de todos os .md antes da Fase 0 (na pasta de saída).
- `fase0_frontmatter.py` — script idempotente (rodar de novo não duplica front-matter).

## Pendências para você decidir (divergências de lore)

1. **Aliança dos Suicidas:** "há 350 anos" × "cem anos após a Guerra das Chaves".
2. **Planos de eco:** origem de Agrestia/Pendor varia entre textos.
3. **Grafias restantes:** Erevan/Erol · Gaurhoth/Gauroth · Czar StormRange/StormBorn.

## Próximo passo sugerido (Fase 1)

Gerar a wiki estática pública a partir destes .md, lendo o front-matter para navegação por tipo/tag, escondendo o que é `status: privado`, com tema de livro de fantasia. Custo zero de hospedagem.
