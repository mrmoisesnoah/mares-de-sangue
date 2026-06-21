# Mares de Sangue

Plataforma wiki/enciclopédia para o cenário de RPG **Mares de Sangue — O Mundo de Skard**. Combina blog, wiki e ferramenta de worldbuilding para mestres e jogadores construírem e consultarem o universo, suas campanhas, personagens e histórias.

Inspirações: [World Anvil](https://www.worldanvil.com/) (estrutura) e o [blog original](https://maresdesangue.blogspot.com/) (conteúdo e tom).

## Visão em 30 segundos

- O conteúdo são arquivos **Markdown** com **front-matter** (metadados no topo), em `conteudo/`.
- O script `gerar_site.py` lê esses `.md` e gera um **site estático** (HTML puro, sem servidor nem banco).
- Gera duas edições: **pública** (jogadores) e **mestre** (com segredos, 🔒).
- Hospedagem gratuita (GitHub Pages via Actions). Edição multiusuário via CMS git em `admin/` (Fase 4).

> Filosofia: **simplicidade acima de tudo**, baixo/zero custo, fácil manutenção, crescer aos poucos. Não adicionar complexidade antes da necessidade.

## Começar rápido

```bash
pip install -r requirements.txt
python gerar_site.py            # gera site/        (público)
python gerar_site.py --mestre   # gera site-mestre/ (com segredos)
```

Abra `site/index.html` no navegador.

## Estrutura

```
mares-de-sangue/                 ← raiz do repositório
  gerar_site.py                  ← gerador do site estático
  requirements.txt
  README.md  ·  CLAUDE.md  ·  .gitignore
  .github/workflows/deploy.yml   ← build + publicação automática (GitHub Pages)
  admin/                         ← painel de edição (Sveltia CMS) — Fase 4
    index.html  ·  config.yml
  docs/
    ARQUITETURA.md  ·  CONTRIBUINDO.md  ·  ROADMAP.md
    FRONT-MATTER.md ·  FASE4-HOSPEDAGEM.md
  conteudo/                      ← CONTEÚDO (.md) — fonte única de verdade
    01 - Canone Atual/  02 - Lore Original .../  03 - Mestragem .../  ...
  site/         (gerado)         ← edição pública  — não versionar
  site-mestre/  (gerado)         ← edição do mestre — não versionar/publicar
```

## Documentação

Comece por `docs/ARQUITETURA.md`; para colaborar, `docs/CONTRIBUINDO.md`; para publicar, `docs/FASE4-HOSPEDAGEM.md`. Se for manter o projeto com ajuda do Claude (ou outra IA), leia o `CLAUDE.md`.


---

## ⚙️ Estado atual do deploy (atualizado)

A **plataforma dinâmica** (`plataforma/app/`) agora é o site publicado, **sozinho, na raiz**:
**https://mrmoisesnoah.github.io/mares-de-sangue**

- O **site estático** antigo (gerador `gerar_site.py` + `conteudo/` + CMS `admin/`) foi **aposentado** e movido para **`arquivo/`** (nada lá é publicado; mantido só como referência).
- O deploy (`.github/workflows/deploy.yml`) agora **publica `plataforma/app` direto na raiz** via GitHub Pages (sem build Python).
- Para publicar mudanças: edite em `plataforma/app/`, faça `git push` na `main` — o GitHub Actions republica.
- Banco/migrations: rodar na ordem de **`docs/MIGRACOES.md`** (Supabase → SQL Editor).
