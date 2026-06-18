# Auditoria de Migração — Bruto (RPG - D&D) × Cânone (Dagorcain .md)

*Gerado em 16/06/2026. Documento de consultoria — não altera nem cria conteúdo do cenário.*

## Veredito rápido

O cânone em `.md` está **essencialmente completo** em relação ao material histórico/lore bruto. Todo documento das pastas legadas `ARQUIVO/` e `rpg/` já possui equivalente curado em `.md` (apenas renomeado com títulos mais limpos). O que falta migrar é **material recente de campanha**, não lore antiga.

## O que já está migrado (sem ação necessária)

Existem hoje **três representações** do mesmo cânone, todas em dia:

1. **Cânone de trabalho** — `Cenário RPG - Dagorcain e o Mundo de Skard/` (78 arquivos `.md`).
2. **Espelho DOCX** — `RPG - D&D/Cenario RPG - Mar de Sangue (Organizado)/_DOCX (Word)/` (cópia 1:1 do cânone em Word).
3. **Consolidados para IA** — `.../Fontes para Projetos IA/` (7 DOCX, um por seção).

As pastas `ARQUIVO/` e `rpg/` são os **originais brutos**; seu conteúdo já foi todo absorvido pelo cânone. Conferência por título normalizado: 0 textos de lore órfãos.

## O que NÃO está no cânone (lacunas reais)

### 1. Sessão 1 — "Ecos na Cidade dos Corvos" (PRIORIDADE ALTA)
Jogada em **14/06/2026**, existe apenas no bruto:
`RPG - D&D/Mestragem - Ecos na Cidade dos Corvos/Sessões/Sessão 1 - 14-06-2026/`

- `Sessão 1 - Introdução - Ecos na Cidade dos Corvos.docx`
- `resumo_v1_narrativo.docx`
- `resumo_v2_cronica.docx`
- `resumo_v3_jornalistico.docx`
- `resumo_whatsapp.txt`

No cânone, as pastas `03 - Mestragem.../Sessoes/` e `.../Personagens/` **existem mas estão vazias** — a estrutura está pronta esperando esse conteúdo.

### 2. Campanha "Shadows from the Old Age" (avaliar)
`RPG - D&D/Mestragem - Shadows from the Old Age/PLANEJAMENTO.docx` — nenhuma menção no cânone. Decidir se entra (campanha própria) ou fica fora do escopo.

### 3. "Aventura Asafe" (avaliar)
`RPG - D&D/Aventura Asafe/Aventura - nova.docx` — sem equivalente. (A "Cidade de Caledon" do mesmo grupo já existe no cânone como nota de mestre.)

## Higiene de arquivos (recomendações de limpeza)

- **Arquivos temporários do Word** a apagar: `ARQUIVO/~$SUMO DAGORCAIN.docx`, `Personagens/~$Elrik.docx`.
- **Arquivos de teste/scaffolding**: `_teste_escrita.txt`, `MODELO (1).docx` na raiz.
- **Quádrupla duplicação**: o mesmo texto de lore vive em até 4 lugares (`ARQUIVO/`, `rpg/`, espelho DOCX, consolidados). Risco de editar a cópia errada. Sugestão: eleger o `.md` como fonte única de verdade e tratar o resto como export/backup.
- **Inconsistência de grafia** confirmada já nos nomes: *Exar Kun* (parte um) vs *Exar Khun* (partes dois–quatro). Vale padronizar.

## Próximo passo sugerido

Integrar a **Sessão 1** ao cânone: posso organizar e formatar os resumos que você já produziu dentro de `03 .../Sessoes/`, sem inventar nada — apenas curadoria e padronização. Em seguida, decidir o destino de "Shadows" e "Aventura Asafe".
