# Full Feature Workflow

## Objetivo

Executar o ciclo completo de uma feature no FlowDelivery.

## Etapas

1. Leia `.codex/workflows/01_feature_planning.md`
2. Gere planejamento arquitetural
3. Aguarde aprovação
4. Leia `.codex/workflows/02_technical_plan.md`
5. Gere plano técnico incremental
6. Aguarde aprovação
7. Leia `.codex/workflows/03_incremental_implementation.md`
8. Implemente uma etapa por vez
9. Leia `.codex/workflows/04_code_review.md`
10. Revise a implementação
11. Gere ou atualize testes
12. Atualize documentação quando necessário
13. Leia `.codex/workflows/05_learning.md`
14. Explique o aprendizado

## Regras

- Não pule aprovação entre planejamento e implementação.
- Não implemente múltiplas etapas de uma vez.
- Não ultrapasse 3 arquivos sem confirmação.
- Use MVVM, Clean Architecture e Riverpod.
- Preserve Supabase fora da UI.

## Saída esperada

- planejamento
- plano técnico
- implementação incremental
- review
- testes
- documentação
- aprendizado
