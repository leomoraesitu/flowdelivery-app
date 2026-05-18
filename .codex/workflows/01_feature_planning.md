# Feature Planning Workflow

Leia:

- `.codex/guardrails.md`
- `.ai/context/*`
- `.ai/agents/architect/*`
- `.ai/agents/teacher/*`
- `.agents/skills/*/SKILL.md` quando a skill for relevante para a feature

## Objetivo

Analisar a feature solicitada antes de qualquer implementação.

## Sua tarefa

1. analisar impacto arquitetural
2. propor arquitetura MVVM
3. definir responsabilidades
4. definir entidades
5. definir repositories
6. definir use cases
7. definir Riverpod providers e ViewModels
8. explicar tradeoffs
9. identificar riscos
10. identificar skills Flutter/Dart úteis para o plano técnico

## Regras

- Não implemente ainda.
- Explique a solução antes de propor arquivos.
- Use Clean Architecture.
- Não crie lógica diretamente na UI.
- Mantenha Supabase fora de widgets.
- Use `.ai/context/agent_skills.md` para escolher apenas skills pertinentes.
- Não aplique uma skill que contradiga ADRs ou contexto versionado do projeto.

## Saída esperada

- visão arquitetural
- camadas envolvidas
- responsabilidades por camada
- riscos e tradeoffs
- perguntas em aberto
- skills recomendadas para o plano técnico
