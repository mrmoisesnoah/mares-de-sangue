# Roadmap

Desenvolvimento incremental: cada fase entrega algo usável antes da próxima. Nada além da fase atual deve ser implementado antes da necessidade.

## Fase 0 — Consolidação do conteúdo ✅
Fonte única de verdade, grafias padronizadas (Exar Khun; Dranor ≠ Dranorak), front-matter YAML em todos os `.md`.

## Fase 1 — Wiki estática pública ✅
Gerador Python → site estático com tema de fantasia, navegação por seções, busca e responsividade.

## Fase 2 — Estados de publicação + área do mestre ✅
`status` (publico/privado) e `audiencia` (jogadores/mestre) no front-matter. Builds separados: `site/` (público) e `site-mestre/` (tudo, com 🔒).

## Fase 3 — Tags e relações ✅
Página de tags, "Veja também" por tags compartilhadas, links internos `[[Título]]`.

## Arquitetura de informação (refinada com o autor) ✅
- Público: Cânone do Mundo, Lore do Universo, Ecos na Cidade dos Corvos, Contos, **Jornais** (A Trombeta de Dagor), Panimalia.
- Fora do público (histórico/base): Blog bruto, Sombras Vindas do Tempo, mesas antigas.
- Pendente (editorial): fundir Lore Original + textos exclusivos do Blog em "Lore do Universo".

## Fase 4 — Multiusuário 🚧 (em montagem)
Edição pela web com papéis, mantendo o modelo Markdown:
- **CMS git (Decap)** sobre o site estático, hospedado no GitHub + Pages/Netlify.
- Login para mestres/jogadores; estados rascunho → privado → público (editorial workflow).
- Coleções por tipo de conteúdo, incluindo **Jornais** (cada mesa pode criar o seu).
- Ver `FASE4-HOSPEDAGEM.md`. Requer conta GitHub (já existe) + ativar hospedagem/login.
- Alternativa para o futuro, se precisar de contas de jogador em escala/tempo real: backend tipo Supabase. Só se necessário.

## Fase 5 — Extras (sob demanda)
Nada obrigatório. Possíveis: mídia/galerias locais, linha do tempo, mapas interativos, calendário, comentários, favoritos, exportação. Implementar um a um, quando a necessidade aparecer.
