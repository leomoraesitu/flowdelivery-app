# Code Review Workflow

Leia:

- `.ai/agents/reviewer/*`
- `.ai/context/*`
- `.ai/context/agent_skills.md`

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
- aderência às skills Flutter/Dart relevantes para a mudança
- suficiência de testes widget/unit/integration conforme a task

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
- Use skills de `.agents/skills` como checklist auxiliar, não como fonte acima do código versionado.
- Execute comandos flutter e dart pelo Dart MCP. Antes execute 'add_roots' .

## Saída esperada

```text
Findings
- Severity — file:line — issue and impact

Open Questions
- Question

Suggested Improvements
- Improvement

Skills Considered
- Skill and reason
```
