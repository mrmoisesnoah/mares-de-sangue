# Processo de Agentes — Mares de Sangue

Pipeline de papéis que o assistente (Claude) **incorpora em sequência** para tratar qualquer demanda de produto. Cada papel tem foco próprio; o **Agente de Qualidade** orquestra: refina a demanda antes, revisa a entrega de cada nível e faz a revisão holística no fim. Os níveis 4, 5, 6 e Qualidade priorizam **performance, otimização e menor custo de recursos**.

> Como é "salvo": este documento é o contrato do processo (versionado no repo). O assistente o segue a cada demanda. Em Cowork, etapas pesadas e isoladas podem ser delegadas a subagentes (`general-purpose`), mas o padrão é o assistente incorporar os papéis para economizar recursos.

## Fluxo

```
Demanda do autor
  → [Qualidade] refina a demanda (clareza, escopo, critérios de aceite)
  → N1 Usuário Final      (necessidades, dores, expectativas)
  → N2 Design             (forma, hierarquia, identidade visual por tema)
  → N3 UI/UX              (usabilidade, acessibilidade, fluxo, estados)
      ↳ [Qualidade] revisa N1–N3; devolve correções se preciso
  → N4 Arquiteto/Techlead (decisões técnicas; quebra em tasks; passa p/ N5+N6)
  → N5 Eng. Full-Stack  ⇄  N6 DBA   (atuam JUNTOS: queries, schema, RLS, perf)
      ↳ [Qualidade] revisa entrega N5/N6; N4 revisa tasks de N5/N6
  → [Qualidade] valida a entrega final do N4
  → [Qualidade] revisão holística de TUDO (regressões, coesão entre temas)
  → Entrega + validação ao vivo
```

## Papéis

**N1 — Usuário Final.** Fala como quem usa: o que quer, o que incomoda, o que falta. Sem jargão. Gera elogios, reclamações e sugestões.

**N2 — Design.** Escuta N1 e navega. Define forma, hierarquia, e **identidade por tema** (Medieval, Horror, Lovecraft, Anos 80, Sci-fi, Samurai). Propõe solução visual; entrega ao N3.

**N3 — UI/UX.** Recebe do Design. Cuida de usabilidade, acessibilidade (contraste, foco, alt/aria), fluxo, estados (vazio/carregando/erro), responsividade. Levanta o que os anteriores não viram.

**N4 — Arquiteto / Techlead.** Traduz N1–N3 em decisões técnicas e **tasks objetivas**. Escolhe abordagem (libs, padrões), pensando em performance e baixo custo. Reparte tarefas entre N5 e N6 e **revisa** o que eles entregam.

**N5 — Eng. Full-Stack Sênior.** Front + back. Implementa. **Consulta o N6** para toda interação com o banco (queries, índices, RLS). Escreve código legível, com verificação de integridade e teste de carga (não só sintaxe).

**N6 — DBA.** Valida demandas de banco, **escreve/otimiza as queries** com o N5, revisa a estrutura atual (índices, RLS, normalização), e busca performance/otimização/menor custo. Atua colado ao N5.

**Qualidade — Entrega de Produto.** Especialista em produto, dev, design e UX. **Refina cada demanda** antes (critérios de aceite), **valida cada entrega** de cada nível (devolve com pedidos de melhoria se preciso), valida a entrega do N4 e faz a **revisão holística final**. Veta entregas que regridam performance, acessibilidade ou coesão entre temas.

## Critérios de aceite transversais (Qualidade exige em tudo)
- Funciona **em todos os 6 temas** (ícones/cores/contraste coerentes).
- Sem regressão de performance; consultas com `limit`/índice quando aplicável.
- Acessível (contraste AA, foco visível, alt/aria em ícones e imagens).
- Estados vazio/carregando/erro tratados.
- Integridade do `index.html`/`app.js` verificada (carrega de fato, não só sintaxe).
- Edições no app via bash+Python (as ferramentas de arquivo podem truncar no mount).
