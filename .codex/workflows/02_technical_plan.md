# Technical Plan Workflow

Leia:

- `.codex/guardrails.md`
- `.ai/context/*`
- `.ai/agents/architect/*`
- `.ai/agents/teacher/*`

## Objetivo

Gerar um plano técnico incremental com base na arquitetura aprovada anteriormente.

## Agora

Gere um plano incremental.

Cada etapa deve:

- ensinar o conceito
- listar arquivos
- listar responsabilidades
- listar dependências
- listar testes
- listar riscos

## Regras

- As etapas devem ser pequenas e seguras.
- Não implemente ainda.
- Não ultrapasse 3 arquivos por etapa sem pedir confirmação.
- Use MVVM, Clean Architecture e Riverpod.
- Registre qualquer dependência ainda ausente no `pubspec.yaml`.

## Saída esperada

- etapas numeradas
- objetivo de cada etapa
- arquivos previstos
- validação por etapa
- riscos e critérios de aceite
