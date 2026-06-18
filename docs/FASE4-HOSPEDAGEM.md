# Fase 4 — Publicar e habilitar edição multiusuário

Objetivo: colocar o site no ar de graça e permitir que mestres/jogadores editem pela web, com papéis e os estados rascunho → privado → público — **sem abandonar o Markdown**.

A ferramenta é o **Decap CMS** (`admin/`): um painel web que edita os mesmos `.md` e faz commit no GitHub; a cada commit o site é reconstruído e publicado. Zero servidor próprio.

## Fluxo

```
edita no painel /admin → commit no GitHub → build automático (Actions) → site/ publicado
```

## Estrutura do repositório (já montada)

O repositório é a pasta **`mares-de-sangue/`** (autocontida, sem os PDFs/músicas):

```
mares-de-sangue/
  gerar_site.py · requirements.txt · README.md · CLAUDE.md · .gitignore
  .github/workflows/deploy.yml      ← build + publicação automática
  admin/  (index.html, config.yml)  ← painel de edição
  docs/
  conteudo/                         ← o conteúdo .md (fonte única)
  site/ (gerado, não versionar)
```

## Parte A — Publicar (rápido)

1. Crie um repositório no GitHub (ex.: `mares-de-sangue`) e suba o conteúdo desta pasta.
   `site/` e `site-mestre/` não vão (estão no `.gitignore`).
2. No repositório: *Settings → Pages → Source = GitHub Actions*.
3. O workflow `.github/workflows/deploy.yml` já está incluído: a cada push na `main`,
   ele instala as dependências, roda `python gerar_site.py` e publica `site/`.

Alternativa: Cloudflare Pages/Netlify conectados ao repo (build `pip install -r requirements.txt && python gerar_site.py`, saída `site/`).

> A edição do **mestre** (`site-mestre/`) não deve ser publicada.

## Parte B — Painel de edição (login + papéis)

O Decap precisa de um provedor de login:

**Opção 1 — Netlify Identity (mais simples):**
1. Hospede no Netlify (conectado ao repo GitHub).
2. Ative *Identity* e *Git Gateway*.
3. Em `admin/config.yml`, troque o backend para `name: git-gateway`.
4. Convide editores em *Identity → Invite users*.

**Opção 2 — Backend GitHub** (já configurado no `config.yml`, ajuste `repo:`): exige um pequeno proxy OAuth. Só vale se não quiser usar o Netlify.

### Papéis e estados
- Quem edita = quem você convida (Netlify) ou colaboradores do repo (GitHub).
- `publish_mode: editorial_workflow` dá rascunho → em revisão → publicado.
- `status`/`audiencia` controlam o que vai ao site público (mestre fica fora).
- Permissões por usuário mais finas (cada mestre só na sua mesa) só pedem backend dinâmico (ex.: Supabase) — implementar se/quando for essencial.

### "Cada mesa cria seu jornal"
A coleção **Jornais** do `config.yml` permite criar edições; o campo *Jornal / Mesa* identifica de qual jornal/mesa é. Assim A Trombeta de Dagor convive com jornais próprios de cada mesa.

## O que depende de você (contas)
1. Criar o repositório no GitHub e subir a pasta `mares-de-sangue/`.
2. Ativar GitHub Pages (Actions) — ou conectar Netlify/Cloudflare.
3. Para o painel: ativar Netlify Identity + Git Gateway e convidar os editores.

Tudo gratuito.
