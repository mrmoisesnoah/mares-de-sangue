# Fase 4 — Publicar e habilitar edição multiusuário

Objetivo: colocar o site no ar de graça e permitir que **mestres e jogadores** criem e publiquem textos pela web, com papéis e os estados rascunho → privado → público — **sem abandonar o Markdown**.

A ferramenta é a **Sveltia CMS** (`admin/`): a sucessora moderna do Decap/Netlify CMS, gratuita, compatível com o mesmo `config.yml`. Edita os `.md` e faz commit no GitHub; a cada commit o site é reconstruído e publicado.

> Por que Sveltia e não Decap: o login do Decap dependia do **Netlify Identity**, que foi **descontinuado**. A Sveltia é mantida ativamente e tem login via GitHub.

## Fluxo

```
edita no painel /admin → commit no GitHub → build automático (Actions) → site/ publicado
```

## A — Publicar o site (já feito ✅)

O site já está no ar via GitHub Pages + Actions: https://mrmoisesnoah.github.io/mares-de-sangue/
O workflow `.github/workflows/deploy.yml` reconstrói tudo a cada `git push` na branch `main`.

> A edição do **mestre** (`site-mestre/`) não é publicada.

## B — Ligar o painel de edição (login) — passos que dependem de você

O painel já está publicado em `/admin/` (ex.: .../mares-de-sangue/admin/). Falta só o login. Caminho recomendado (gratuito):

**Sveltia CMS + autenticador no Cloudflare Workers**
1. Crie uma conta gratuita no Cloudflare.
2. Faça deploy do autenticador oficial **`sveltia-cms-auth`** (Cloudflare Worker) — repositório com instruções: https://github.com/sveltia/sveltia-cms-auth
3. No GitHub, crie um *OAuth App* (Settings → Developer settings → OAuth Apps), apontando o callback para a URL do Worker; coloque o Client ID/Secret no Worker.
4. Em `admin/config.yml`, descomente e preencha `base_url: https://SEU-AUTENTICADOR.workers.dev`.
5. `git push`. Pronto: abra `/admin/`, entre com GitHub e edite.

**Alternativa ainda mais simples para não-técnicos (jogadores sem conta GitHub):** o serviço **DecapBridge** (gratuito) faz o login sem exigir conta GitHub de cada editor. É um serviço hospedado por terceiros — bom quando vários jogadores vão editar. Docs: https://decapbridge.com/

### Papéis e estados
- **Quem edita** = colaboradores do repositório no GitHub (você convida em *Settings → Collaborators*). Admin = você; mestres/jogadores = colaboradores.
- **Estados:** `publish_mode: editorial_workflow` dá rascunho → em revisão → publicado.
- **Mestre × jogador:** os campos `status` e `audiencia` de cada texto controlam o que vai ao site público (conteúdo de mestre fica fora). É o mesmo controle que você já viu funcionando (ex.: o Planejamento da Sessão 1 é mestre; os resumos são públicos).
- Permissões por usuário mais finas (cada mestre só na sua mesa) só pediriam um backend dinâmico (ex.: Supabase) — implementar apenas se/quando for essencial.

### "Cada mesa cria seu jornal / seus textos"
As coleções do `config.yml` (Lore, Cânone, Jornais, Contos, Ecos) têm `create: true`: qualquer editor logado cria textos novos por ali. Na coleção **Jornais**, o campo *Jornal / Mesa* identifica de qual jornal/mesa é — assim A Trombeta de Dagor convive com jornais próprios de cada mesa.

## Resumo do que falta (só depende de você)
1. (Login) Criar conta Cloudflare + publicar o Worker `sveltia-cms-auth` + OAuth App no GitHub, e preencher `base_url` no `config.yml`. (Ou usar DecapBridge.)
2. Convidar mestres/jogadores como colaboradores do repositório.

Tudo gratuito. Posso te guiar em cada passo quando você for fazer.
