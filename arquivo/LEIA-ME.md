# Arquivo — site estático antigo (descontinuado)

Esta pasta guarda o **site estático** original (wiki gerada de Markdown), que foi
**aposentado**: a plataforma dinâmica passou a ser publicada sozinha, na raiz
(`https://mrmoisesnoah.github.io/mares-de-sangue`).

Conteúdo aqui:
- `gerar_site.py` — gerador do site estático (lê `conteudo/` → `site/`).
- `conteudo/` — os `.md` originais do cenário (já migrados para o banco da plataforma via `plataforma/migracao.sql`).
- `admin/` — CMS (Sveltia) que editava o site estático via Git.
- `requirements.txt` — dependências Python do gerador.
- `site/`, `site-mestre/` — saídas geradas (se presentes).

Nada aqui é publicado. Mantido apenas para referência/histórico.
