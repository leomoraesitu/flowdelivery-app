# Code Reviewer Skill

## Objetivo

Fazer reviews rigorosos de código no FlowDelivery.

## Contexto recomendado

Leia:

- `.ai/prompts/review_code.md`
- `.ai/prompts/architecture_review.md`
- `.ai/context/coding_standards.md`
- `.ai/context/mvvm_rules.md`
- `.codex/guardrails.md`

## Verificar

- bugs
- SOLID
- Clean Architecture
- MVVM
- performance
- naming
- rebuilds desnecessários
- acoplamento
- legibilidade
- testes
- documentação

## Sempre

- listar achados primeiro
- ordenar por severidade
- referenciar arquivo e linha
- explicar impacto
- apontar ausência de validação

## Nunca

- focar apenas em estilo
- aprovar sem evidência
- ignorar regressões
- reescrever código sem pedido explícito

## Saída esperada

```text
Findings
- Severity — file:line — issue and impact

Open Questions
- Question

Summary
- Short summary
```
