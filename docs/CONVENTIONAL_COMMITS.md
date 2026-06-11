# Conventional Commits — FlowDelivery

## Objetivo

Este documento define o padrão oficial de commits do projeto **FlowDelivery**.

O objetivo é garantir:

- Histórico Git padronizado
- Melhor rastreabilidade
- Changelog automático
- Integração com CI/CD
- Releases semânticas
- Melhor contexto para IA (Codex/Copilot)
- Facilidade em code reviews
- Organização profissional do projeto

---

## Especificação

O projeto utiliza o padrão:

```text
<type>(scope): <description>
```

Exemplo:

```text
feat(auth): implement Supabase Google login
```

## Regras Gerais

### Idioma

Todos os commits devem ser escritos em inglês.

### Estilo

A descrição deve:

- Ser curta
- Ser objetiva
- Estar no imperativo
- Não terminar com ponto final

### Exemplos corretos

```text
feat(cart): add quantity selector
fix(checkout): prevent duplicated orders
refactor(core): reorganize MVVM structure
```

### Exemplos incorretos

```text
Added new cart feature
fixing bug
Refactor: Refactor code
```

## Tipos de Commit

### feat

Nova funcionalidade.

```text
feat(home): create restaurant feed
```

Impacto SemVer:

- MINOR

### fix

Correção de bug.

```text
fix(cart): prevent negative quantity
```

Impacto SemVer:

- PATCH

### refactor

Refatoração sem mudança funcional.

```text
refactor(viewmodel): simplify checkout validation
```

### docs

Mudanças em documentação.

```text
docs(readme): update setup instructions
```

### style

Mudanças visuais ou formatação sem alterar lógica.

```text
style(theme): adjust spacing tokens
```

### test

Testes automatizados.

```text
test(auth): add login repository tests
```

### chore

Tarefas de manutenção.

```text
chore(deps): update flutter_riverpod
```

### build

Build system, Gradle, scripts e pipelines.

```text
build(android): configure release signing
```

### ci

Integração contínua.

```text
ci(github): add Flutter workflow
```

### perf

Melhoria de performance.

```text
perf(feed): optimize image caching
```

## Scopes Oficiais do Projeto

### Features

- auth
- home
- restaurants
- product
- cart
- checkout
- orders
- profile
- search
- delivery
- payments

### Arquitetura

- ui
- viewmodel
- repository
- datasource
- domain
- core
- routing
- theme
- design-system

### Infraestrutura

- firebase
- supabase
- api
- android
- ios
- web
- ci
- analytics

## Breaking Changes

Mudanças incompatíveis devem utilizar `!`.

Exemplo:

```text
feat(api)!: migrate order payload structure
```

Ou:

```text
feat(api): migrate order payload structure

BREAKING CHANGE: order payload now requires addressId
```

Impacto SemVer:

- MAJOR

## Padrão Recomendado para Branches

### Main branches

- main
- develop

### Feature branches

- feat/cart-flow
- feat/auth-google-login
- feat/order-history

### Hotfix branches

- hotfix/payment-crash

### Release branches

- release/v1.1.0

## Fluxo Recomendado

### Exemplo completo

Branch:

```text
feat/cart-state-management
```

Commits:

```text
feat(cart): create cart entity
feat(cart): implement cart repository
feat(cart): add cart viewmodel
feat(cart): create cart page UI
```

Pull Request:

```text
feat(cart): implement shopping cart flow
```

## Integração com Ferramentas

### Changelog automático

Ferramentas recomendadas:

- semantic-release
- standard-version
- conventional-changelog

### Git Hooks

Ferramentas recomendadas:

- commitlint
- husky

### Exemplo de Configuração do Commitlint

```js
module.exports = {
  extends: ['@commitlint/config-conventional'],
};
```

## Boas Práticas

### Commits pequenos

Prefira commits pequenos e objetivos.

### Um objetivo por commit

Evite commits gigantes misturando:

- UI
- lógica
- refatoração
- dependências

### Commits frequentes

Commits frequentes facilitam:

- rollback
- review
- debugging
- análise da IA

## Convenção Oficial do FlowDelivery

Formato obrigatório:

```text
type(scope): description
```

## Exemplos Oficiais do Projeto

### MVVM

```text
refactor(core): migrate architecture to MVVM
feat(viewmodel): implement order tracking state
```

### Supabase

```text
feat(supabase): configure authentication client
```

### Flutter UI

```text
feat(home): create featured restaurants section
```

### Design System

```text
style(theme): apply semantic color tokens
```

## Referências

- https://www.conventionalcommits.org/
- https://semver.org/
- https://commitlint.js.org/
- https://semantic-release.gitbook.io/

## Status

FlowDelivery Git Convention:

```text
ACTIVE
```
