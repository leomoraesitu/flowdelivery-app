# Plans

Diretório para planos técnicos e planos de implementação gerados durante o desenvolvimento assistido por IA.

## Padrão de nome

```text
YYYY-MM-DD-<feature>-plan.md
```

Exemplo:

```text
2026-05-17-authentication-plan.md
```

## Quando criar

Crie ou atualize um arquivo-plan durante o workflow `Technical Plan`, antes de qualquer implementação de feature.

O fluxo esperado é:

```text
Morning Start
Start Feature
Technical Plan
Continue Feature
Review Feature
Learning Mode
End Day
```

## Estrutura mínima

Cada plan deve conter:

- objetivo da feature
- contexto arquitetural
- stack e dependências previstas
- arquivos que serão criados ou modificados
- tarefas pequenas com checklist (`- [ ]`)
- validação por tarefa
- skills Flutter/Dart aplicáveis por etapa
- localization guard checklist for any stage that introduces or changes user-facing copy
- theme guard checklist for any stage that introduces or changes user-facing UI styling
- riscos
- critérios de aceite
- itens fora de escopo

## Regra operacional

`Continue Feature` deve executar somente a próxima task pendente do plan pertinente.

Não implemente múltiplas tasks em uma mesma etapa sem confirmação explícita.
