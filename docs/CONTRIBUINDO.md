# Contribuindo / Manutenção

Guia para desenvolvedores (com ou sem Claude) e para o autor manterem o projeto.

## Pré-requisitos

- Python 3.9+ instalado.
- Instalar dependências (uma vez):

```bash
pip install -r requirements.txt
```

## Gerar o site

Dentro da pasta `Site Mares de Sangue/`:

```bash
python gerar_site.py            # site/        (público — jogadores)
python gerar_site.py --mestre   # site-mestre/ (tudo, com segredos)
```

Opções: `--conteudo CAMINHO` (pasta dos `.md`) e `--saida CAMINHO` (destino).

Abra `site/index.html` no navegador para conferir.

## Adicionar um artigo novo

1. Crie um `.md` na pasta de conteúdo certa (`../Cenario RPG - Mar de Sangue (Organizado)/...`).
2. Coloque o front-matter no topo (ver `FRONT-MATTER.md`). O mínimo:

   ```yaml
   ---
   titulo: "Nome do artigo"
   tipo: lore
   status: publico
   audiencia: jogadores
   tags: ["Elódia"]
   ---
   ```
3. Escreva o conteúdo em Markdown.
4. Rode `python gerar_site.py` de novo.

Para esconder dos jogadores: use `status: privado` ou `audiencia: mestre` — aparece só na edição do mestre. Quando quiser revelar, troque para `publico` e regenere.

## Ligar artigos

- Tags: liste em `tags:`. Artigos com tags em comum aparecem em "Veja também".
- Link direto: escreva `[[Título exato de outro artigo]]` no texto.

## Convenções

- **Não reescreva a lore** sem pedido do autor — preserve o texto original. Cânone é decisão dele.
- Um H1 por artigo: o gerador usa `titulo` do front-matter; pode manter o `# Título` no corpo (ele é removido na renderização para não duplicar).
- Caminhos com espaços/acentos: sempre entre aspas.
- Grafias canônicas: **Exar Khun**; **Dranor** (reino) ≠ **Dranorak** (capital).

## Mexer no gerador

- Tema: edite a constante `CSS` em `gerar_site.py`.
- Busca: constante `JS`.
- O que é público: `PUBLICO_MAPA` e `secao_publica()`.
- Depois de qualquer mudança: rode os dois builds e confira `index.html`, `tags.html`, `busca.html` e alguns artigos. Verifique se não há links quebrados.

## Solução de problemas

| Sintoma | Causa provável | Solução |
|---|---|---|
| `ModuleNotFoundError: markdown/yaml` | dependências não instaladas | `pip install -r requirements.txt` |
| Artigo não aparece no público | `status: privado`, `audiencia: mestre`, ou seção não pública | ajuste o front-matter / veja `PUBLICO_MAPA` |
| Front-matter ignorado | YAML inválido (indentação/aspas) | valide o bloco entre `---` |
| Acento estranho no HTML | arquivo não está em UTF-8 | salve o `.md` como UTF-8 |

## Git (resumo)

A saída (`site/`, `site-mestre/`) é gerada e está no `.gitignore` — não versione. Versione só conteúdo, `gerar_site.py`, `docs/` e `admin/`. Passo a passo de repositório e publicação em `FASE4-HOSPEDAGEM.md`.
