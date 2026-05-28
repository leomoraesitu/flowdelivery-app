# Technical Plan Workflow

Leia:

- `.codex/guardrails.md`
- `.ai/context/*`
- `.ai/agents/architect/*`
- `.ai/agents/teacher/*`
- `.ai/context/agent_skills.md`

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
- listar skills Flutter/Dart aplicáveis

Se a etapa tocar UI, placeholders, dialogs, snackbars, routes ou qualquer copy de usuario, inclua tambem um checklist de localization guard com estes itens:

- existe chave ARB para cada string nova;
- a UI consome `AppLocalizations`;
- nao ha texto hardcoded em `Text`, `SnackBar`, `Tooltip`, `AlertDialog`, `BottomSheet`, `showModalBottomSheet` ou `semanticLabel`;
- o guard test permanece verde.

Se a etapa tocar estilo visual de UI, inclua tambem um checklist de theme guard com estes itens:

- a UI usa `Theme.of(context)` e tokens (`AppSpacing`, `AppRadius`, `AppSizes`, `AppDurations`) quando aplicavel;
- nao ha `Color(0x...)` hardcoded em presentation;
- nao ha uso direto de `AppLightColors`/`AppDarkColors` fora de `lib/app/theme`;
- o guard test visual permanece verde.

## Registro do plano

Crie um arquivo-plan em `.ai/plans/` com o plano aprovado.

Use o padrão:

```txt
.ai/plans/YYYY-MM-DD-<feature>-plan.md
```

O arquivo deve conter:

- objetivo
- contexto arquitetural
- etapas numeradas com checklist executável
- arquivos previstos por etapa
- validação por etapa
- skills aplicáveis por etapa
- checklist de localization guard para etapas com UI ou copy de usuario
- checklist de theme guard para etapas com alteracao visual de UI
- riscos
- critérios de aceite
- itens fora de escopo

## Regras

- As etapas devem ser pequenas e seguras.
- Não implemente ainda.
- Não ultrapasse 3 arquivos por etapa sem pedir confirmação.
- Use MVVM, Clean Architecture e Riverpod.
- Registre qualquer dependência ainda ausente no `pubspec.yaml`.
- O arquivo-plan deve ser criado antes de iniciar qualquer implementação.
- Use skills de `.agents/skills` somente quando forem pertinentes à etapa.
- Execute comandos flutter e dart pelo Dart MCP. Antes execute 'add_roots' .

## Saída esperada

- etapas numeradas
- objetivo de cada etapa
- arquivos previstos
- validação por etapa
- skills aplicáveis por etapa
- riscos e critérios de aceite
- caminho do arquivo-plan criado em `.ai/plans/`
