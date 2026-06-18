# Front-matter — esquema de metadados

Todo `.md` de conteúdo começa com um bloco YAML entre `---`. Ele classifica o artigo e controla a visibilidade.

```yaml
---
titulo: "Nome exibido do artigo"
tipo: lore
cenario: "Mar de Sangue"
campanha: "Ecos na Cidade dos Corvos"   # opcional
status: publico
audiencia: jogadores
data: 2013-07-23                          # opcional (AAAA-MM-DD)
origem: blog                              # opcional
tags: ["Elódia", "Grandes Cidades"]
---
```

## Campos

| Campo | Obrigatório | Valores | Função |
|---|---|---|---|
| `titulo` | sim | texto | Título exibido e alvo de links `[[...]]`. |
| `tipo` | sim | `canone`, `lore`, `campanha`, `sessao`, `conto`, `jornal`, `indice` | Classifica o artigo. `jornal` vai para a área **Jornais**. |
| `cenario` | recomendado | texto | Sempre `"Mar de Sangue"` por enquanto. |
| `campanha` | opcional | texto | Ex.: `"Ecos na Cidade dos Corvos"`. |
| `status` | sim | `publico`, `privado` | `publico` aparece no site dos jogadores; `privado` só na edição do mestre. |
| `audiencia` | sim | `jogadores`, `mestre` | `mestre` nunca aparece no site público. |
| `data` | opcional | `AAAA-MM-DD` | Datados entram em "Adições recentes" e ordenam jornais/sessões. |
| `origem` | opcional | ex.: `blog` | Procedência do texto. |
| `tags` | recomendado | lista | Geram a página de tags e o "Veja também". |

## Regra de visibilidade (site público)

Um artigo aparece no site público somente se **todas** forem verdadeiras:

1. `status: publico`
2. `audiencia` diferente de `mestre`
3. está numa seção pública (Cânone 01, Lore 02, Ecos 03, Contos 04, Panimalia 06) **ou** tem `tipo: jornal`

Tudo o mais (Blog bruto, Sombras Vindas do Tempo, mesas antigas, notas de mestre) fica apenas na edição do mestre. Veja `PUBLICO_MAPA`/`secao_publica()` em `gerar_site.py`.

## Boas práticas

- Mantenha `titulo` único; se dois forem iguais, o gerador cria slugs distintos, mas links `[[...]]` podem ficar ambíguos.
- Use tags consistentes (mesma grafia) para o "Veja também" funcionar bem.
- Para preparar um segredo e revelar depois: comece com `status: privado`; quando for a hora, troque para `publico` e regenere.
