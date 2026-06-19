# Acessos & Handoff — Projeto Mares de Sangue

Tudo o que outro chat/dev precisa para assumir o projeto com acesso total. **Comece lendo `CLAUDE.md` (raiz) e `docs/PLATAFORMA.md`.**

---

## 1. Endereços no ar (URLs públicas)

| O quê | URL |
|---|---|
| Site estático (wiki pública) | https://mrmoisesnoah.github.io/mares-de-sangue/ |
| **Plataforma** (app dinâmico) | https://mrmoisesnoah.github.io/mares-de-sangue/plataforma/ |
| Painel CMS do site estático (Sveltia, opcional) | https://mrmoisesnoah.github.io/mares-de-sangue/admin/ |
| Blog original (referência) | https://maresdesangue.blogspot.com/ |

## 2. Repositório (código + conteúdo)

- **GitHub:** https://github.com/mrmoisesnoah/mares-de-sangue  (branch `main`)
- **Usuário GitHub:** `mrmoisesnoah`
- **Pasta local (Windows):** `C:\Users\Noah\Desktop\Outros\RPG\RPG - D&D\mares-de-sangue`
- **Deploy:** automático via GitHub Actions (`.github/workflows/deploy.yml`) a cada `git push` na `main`.
- O Claude Code, aberto nessa pasta, **carrega o contexto sozinho** (lê `CLAUDE.md` + `docs/`).

Estrutura: `gerar_site.py` (gera o site estático de `conteudo/` → `site/`), `plataforma/app/` (o app real: `index.html`, `config.js`, `estilo.css`, `app.js`), `plataforma/schema.sql` (banco), `plataforma/migracao.sql` (conteúdo→banco), `plataforma/storage.sql` (upload), `docs/` (documentação).

## 3. Supabase (banco, login, storage)

- **Painel (dashboard):** https://supabase.com/dashboard/project/niepiaiwusptmwepgmlq
- **Project Ref / ID:** `niepiaiwusptmwepgmlq`
- **Project URL (API):** `https://niepiaiwusptmwepgmlq.supabase.co`
- **SQL Editor:** Painel → SQL Editor (onde se rodam `schema.sql`, `migracao.sql`, `storage.sql`)
- **Chave anon/public** (pode ficar exposta — já está em `plataforma/app/config.js`):
  ```
  eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5pZXBpYWl3dXNwdG13ZXBnbWxxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE3NTU0MTEsImV4cCI6MjA5NzMzMTQxMX0.w7YFACJkX4Muebjfgg7RSIIwchnfa23aGx9VRTeuPh4
  ```

### Estado do banco (SQL já aplicado / a aplicar)
Rodar no SQL Editor (idempotentes): `schema.sql` (tabelas + RLS) ✅, `storage.sql` (bucket de imagens), e as colunas de capa/fundo:
```sql
alter table publicacoes add column if not exists capa_url text;
alter table mundos add column if not exists capa_url text;
alter table mundos add column if not exists fundo_url text;
alter table mesas  add column if not exists capa_url text;
alter table mesas  add column if not exists fundo_url text;
```
`migracao.sql` traz os 94 textos do cenário para a tabela `publicacoes`.

## 4. Credenciais que VOCÊ guarda (NÃO estão no repositório)

Estas são pessoais/secretas — **passe em canal privado**, nunca commite:

| Credencial | Onde obter | Observação |
|---|---|---|
| Login Supabase (e-mail/senha) | sua conta supabase.com | dá acesso total ao painel |
| Senha do banco Postgres | definida na criação do projeto | raramente usada (o painel basta) |
| **service_role key** (SECRETA) | Painel → Project Settings → API | só se precisar de scripts admin que furam o RLS. **Nunca** no front nem no Git |
| Login GitHub (mrmoisesnoah) | sua conta GitHub | para dar `push` / administrar o repo |
| Conta Cloudflare (se for usar) | cloudflare.com | só se ligar o login do CMS Sveltia (Fase 4) |

> Para outro chat **atuar no código**: basta o repositório (com `CLAUDE.md`) + a chave **anon** (já pública). Para **operar o banco** (rodar SQL, migrações), ele precisa que você rode no SQL Editor ou que receba a **service_role** em privado.

## 5. Como dar acesso a outro colaborador

- **Código:** GitHub → repo → Settings → Collaborators → convidar o usuário. (Ou enviar o ZIP da pasta.)
- **Plataforma (editar conteúdo logado):** a pessoa cria conta no app e você a adiciona como membro/mestre da mesa (hoje via SQL `mesa_membros`, ou no app conforme evoluir).
- **Banco (admin):** Supabase → Settings → Team → convidar (requer plano) **ou** compartilhar credenciais em privado.

## 6. Como rodar localmente

```
pip install -r requirements.txt          # markdown, pyyaml (site estático)
python gerar_site.py                      # gera site/ (público)  e  --mestre p/ site-mestre/
# a plataforma (plataforma/app) é HTML/JS puro: abre no navegador ou via /plataforma/ no Pages
git add -A && git commit -m "..." && git push   # publica tudo
```

## 7. Pendências / próximos passos (contexto)
Ver `docs/ROADMAP.md` e `docs/FRONT-END-TODO.md`. Em aberto: separar "Personagem do Mestre × do Jogador" por papel em `mesa_membros` (hoje por dono do mundo); refinar upload/galerias; busca global; convites de jogador pela UI.
