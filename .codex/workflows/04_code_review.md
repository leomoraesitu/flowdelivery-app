# Code Review Workflow

Leia:

- `.ai/agents/reviewer/*`
- `.ai/context/*`

## Objetivo

Fazer review rigoroso da implementação atual.

## Analise

- SOLID
- MVVM
- acoplamento
- escalabilidade
- naming
- performance
- rebuilds desnecessários
- testabilidade
- separação de responsabilidades
- anti-patterns Flutter
- uso de Riverpod quando presente
- isolamento do Supabase

## Classifique

- critical
- high
- medium
- low

## Regras

- Liste achados primeiro.
- Inclua arquivo e linha quando possível.
- Sugira melhorias.
- Não altere arquivos durante o review.

## Saída esperada

```text
Findings
- Severity — file:line — issue and impact

Open Questions
- Question

Suggested Improvements
- Improvement
```
