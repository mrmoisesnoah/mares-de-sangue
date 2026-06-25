# Processo de Agentes — Mares de Sangue

Pipeline de papéis que o assistente (Claude) **incorpora em sequência** para tratar qualquer demanda de produto. Cada papel tem foco próprio; o **PO (Product Owner)** capta a voz do cliente/usuário e, junto ao **Líder de Entrega (Agente de Qualidade)**, prepara a estratégia; a **Qualidade** orquestra: refina a demanda antes, revisa a entrega de cada nível e faz a revisão holística no fim. Os níveis 4, 5, 6 e Qualidade priorizam **performance, otimização e menor custo de recursos**.

> Como é "salvo": este documento é o contrato do processo (versionado no repo). O assistente o segue a cada demanda. Em Cowork, etapas pesadas e isoladas podem ser delegadas a subagentes (`general-purpose`), mas o padrão é o assistente incorporar os papéis para economizar recursos.

## Quando aplicar (gatilho) — método intrínseco

Este processo é **o modo padrão de operar** o projeto, vinculado no `CLAUDE.md` (carregado em toda sessão). Dispare-o sempre que a demanda for:

- **Levantamento técnico** — investigar como algo funciona, viabilidade, trade-offs.
- **Correção de funcionalidade** — bug, regressão, comportamento errado.
- **Criação de feature** — nova tela, card, fluxo, campo.
- **Manutenção e suporte** — refactor, performance, acessibilidade, migrations, dúvidas do autor.

Para tarefas triviais (1 arquivo, mudança óbvia, sem risco), o **Agente de Qualidade** pode condensar os papéis numa passada única — mas os critérios de aceite transversais continuam valendo. Quanto maior o risco/escopo, mais explícita deve ser a passagem por cada nível.

## Fluxo

```
Demanda / feedback do autor (cliente · usuário final)
  → [PO] escuta reclamações, sugestões e elogios; organiza e prioriza (sem jargão técnico)
  → [PO] + [Líder de Entrega = Qualidade] conversam e definem a estratégia
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

**PO — Product Owner.** Ponto de contato com o cliente/usuário final. Escuta as reclamações, sugestões e elogios na linguagem do usuário, organiza e prioriza o que chega, e leva ao **Líder de Entrega (Agente de Qualidade)**. Os dois conversam e preparam a **estratégia** (o quê, por quê, prioridade, recorte) antes de repassar ao time. O PO não decide solução técnica — ele traduz a voz do usuário em demanda clara e protege o foco no valor para quem usa.

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
