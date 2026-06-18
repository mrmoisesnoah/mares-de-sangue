# Arquitetura

## Decisão central: site estático a partir de Markdown

O conteúdo já existia em Markdown. Em vez de montar um servidor e banco de dados, o projeto gera um **site estático** (HTML/CSS/JS puro) a partir desses arquivos. Vantagens, alinhadas à filosofia do projeto:

- **Custo zero** de hospedagem (GitHub Pages, Cloudflare Pages, Netlify).
- **Sem servidor para manter**, sem banco para administrar, sem falhas de runtime.
- **Conteúdo legível e portável** — Markdown abre em qualquer editor, versiona bem no Git e importa para Notion/Obsidian/MkDocs se um dia quiser trocar.
- **Fácil de entender** por um dev iniciante: um único script, sem mágica.

A alternativa (app dinâmico com login para todos) só é necessária quando vários usuários precisarem **criar/editar** conteúdo pela web — isso é a Fase 4, resolvida com um CMS git (ver `FASE4-HOSPEDAGEM.md`) que mantém o mesmo modelo de arquivos.

## Fluxo de dados

```
.md (conteúdo + front-matter)
        │
        ▼
  gerar_site.py   ── lê front-matter, filtra por status/seção,
        │             renderiza Markdown→HTML, monta nav/busca/tags
        ▼
  site/  (público)  +  site-mestre/  (tudo, com 🔒)
        │
        ▼
  navegador / GitHub Pages
```

## Componentes do `gerar_site.py`

| Função | Papel |
|---|---|
| `coletar()` | Varre o conteúdo, lê o front-matter de cada `.md`, cria objetos `Artigo` e slugs únicos. |
| `parse_front_matter()` | Separa o bloco YAML do corpo Markdown. |
| `secao_publica()` / `PUBLICO_MAPA` | Define quais pastas/tipos entram no site **público** e em que seção (inclui a área **Jornais**). |
| `render_corpo()` | Converte Markdown em HTML; resolve links internos `[[Título]]`; remove o H1 duplicado. |
| `montar_nav()` | Barra lateral agrupada por seção. |
| `pagina()` | Molde HTML comum (cabeçalho, busca, rodapé). |
| `construir()` | Orquestra tudo: artigos, `index.html`, `tags.html`, `busca.html`, `busca.json`, assets. |
| `CSS` / `JS` | Tema (constante `CSS`) e busca client-side (constante `JS`). |

## Modelo de conteúdo

Cada `.md` é um **artigo**. O front-matter classifica e controla visibilidade (ver `FRONT-MATTER.md`). As pastas numeradas (`01 - ...` a `07 - ...`) organizam o acervo; o gerador decide o que é público a partir de `PUBLICO_MAPA` + `tipo`.

Relações entre artigos:
- **Tags** geram a página `tags.html` e o bloco "Veja também" (por tags compartilhadas).
- **Links internos:** escreva `[[Título exato de outro artigo]]` no Markdown e o gerador transforma em link.

## Busca

`busca.json` é um índice leve (título, seção, tipo, tags, resumo, trecho). `assets/app.js` filtra no navegador — sem servidor. Funciona offline depois de carregado.

## Por que duas edições

`status`/`audiencia` no front-matter separam **jogadores** de **mestre**. O build público omite segredos; o build do mestre inclui tudo com 🔒. Assim o autor prepara conteúdo escondido e revela quando quiser — só mudando `status` e regenerando.

## Limites atuais e evolução

- **Mídia local** (imagens de sessão) ainda não é copiada para o site — fase futura.
- **Edição multiusuário** pela web: Fase 4 (CMS git).
- Se um dia o volume/colaboração exigir, dá para migrar o mesmo Markdown para um backend (ex.: Supabase) sem perder o conteúdo. Só fazer quando necessário.

Ver `ROADMAP.md` para o plano completo.
