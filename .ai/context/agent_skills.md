# FlowDelivery AI Context - Agent Skills

## Objetivo

Usar as skills oficiais Flutter/Dart instaladas em `.agents/skills` como apoio por task.

As skills complementam os workflows do projeto. Elas não substituem:

- `.codex/guardrails.md`
- `.ai/context/*`
- ADRs do projeto
- MVVM
- Clean Architecture
- isolamento do Supabase fora da UI

## Regra Principal

Antes de planejar, implementar ou revisar uma task Flutter/Dart, identifique quais skills são relevantes.

Use apenas as skills necessárias para a task atual.

## Matriz de Uso

Planejamento e arquitetura:

- `flutter-apply-architecture-best-practices`

Rotas e navegação:

- `flutter-setup-declarative-routing`

Widgets, telas e layout:

- `flutter-add-widget-test`
- `flutter-build-responsive-layout`
- `flutter-add-widget-preview`

Correção de layout:

- `flutter-fix-layout-issues`

Lógica Dart e testes:

- `dart-add-unit-test`
- `dart-generate-test-mocks`

Validação:

- `dart-run-static-analysis`
- `dart-collect-coverage`

Dependências:

- `dart-resolve-package-conflicts`

JSON e modelos simples:

- `flutter-implement-json-serialization`

Internacionalização:

- `flutter-setup-localization`

## Uso Condicional

Use `flutter-add-integration-test` apenas para fluxos ponta a ponta.

Use `flutter-use-http-package` apenas quando houver uma API REST externa real. Para Supabase, preserve o fluxo:

```text
Widget
|
v
ViewModel / Provider
|
v
Repository
|
v
Datasource
|
v
Supabase Client
```

Use `dart-build-cli-app` apenas para scripts ou ferramentas Dart de linha de comando.

Use `dart-migrate-to-checks-package` apenas se a estratégia de testes do projeto for migrar para `package:checks`.

## Aplicação por Task

Ao gerar um plano em `.ai/plans`, registre em cada etapa:

```text
Skills aplicáveis:
- <skill>
```

Ao implementar uma etapa:

1. leia a próxima task pendente do plan;
2. identifique as skills aplicáveis;
3. explique por que elas se aplicam;
4. implemente somente a task aprovada;
5. valide com o menor comando confiável.
