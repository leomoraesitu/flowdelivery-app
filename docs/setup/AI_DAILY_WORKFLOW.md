# FlowDelivery - AI Daily Workflow

## Objetivo

Este documento descreve o workflow diario recomendado para usar as tasks de `.vscode/tasks.json` durante o desenvolvimento assistido por IA no projeto FlowDelivery.

O objetivo do fluxo e manter:

- continuidade entre sessoes;
- memoria operacional atualizada;
- planejamento antes de implementacao;
- desenvolvimento incremental;
- revisao tecnica;
- aprendizado continuo;
- controle humano antes de mudancas no codigo.

## Como as Tasks Funcionam

As tasks configuradas em `.vscode/tasks.json` executam scripts PowerShell que carregam prompts do projeto, exibem o conteudo no terminal e copiam o prompt para a area de transferencia.

Elas nao executam a IA automaticamente.

O uso esperado e:

1. executar a task no VS Code;
2. colar o prompt gerado no Codex ou ferramenta de IA;
3. revisar a proposta;
4. aprovar explicitamente antes de qualquer alteracao em arquivos.

## Workflow Diario Padrao

Use este fluxo em um dia comum de desenvolvimento, quando ja existe uma feature atual em andamento.

```text
AI Session Context
AI Morning Start
AI Continue Feature
AI Review Feature
AI Learning Mode
AI End Day
```

### 1. AI Session Context

Use no inicio da sessao quando quiser carregar o contexto mais completo do projeto.

Esta task consolida informacoes como:

- sprint atual;
- feature atual;
- technical debt;
- known issues;
- notas de arquitetura;
- guardrails;
- workflow;
- contexto de produto;
- regras de Flutter, MVVM, Riverpod e Supabase.

Ela e util para recuperar rapidamente o estado do projeto antes de planejar, implementar, revisar ou explicar qualquer mudanca.

### 2. AI Morning Start

Use sempre no inicio do dia ou da sessao.

Objetivos:

- entender onde o projeto esta;
- identificar a feature atual;
- listar proximos passos;
- revisar riscos atuais;
- revisar technical debt relevante;
- ativar mentalmente os papeis de teacher, architect e reviewer.

Regra importante:

- nao implementar nesta etapa.

### 3. AI Continue Feature

Use durante o desenvolvimento da feature atual.

Objetivos:

- continuar apenas a proxima etapa pendente;
- explicar arquitetura antes de alterar arquivos;
- explicar responsabilidades;
- explicar tradeoffs;
- confirmar arquivos afetados;
- validar o menor recorte util;
- atualizar `.ai/memory/current_feature.md` quando necessario.

Regra importante:

- nao implementar multiplas etapas de uma vez.

### 4. AI Review Feature

Use depois de uma etapa implementada ou antes de fechar uma feature.

Objetivos:

- revisar bugs;
- validar SOLID;
- validar MVVM;
- validar Clean Architecture;
- revisar acoplamento;
- revisar testabilidade;
- verificar performance e rebuilds desnecessarios;
- identificar anti-patterns Flutter;
- conferir isolamento do Supabase;
- avaliar uso de Riverpod quando presente.

Regra importante:

- esta task e para review; nao deve alterar arquivos durante a revisao.

### 5. AI Learning Mode

Use quando quiser transformar a implementacao em aprendizado.

Objetivos:

- explicar conceitos Flutter envolvidos;
- explicar MVVM no contexto da feature;
- explicar Clean Architecture aplicada;
- explicar Riverpod quando houver uso;
- detalhar responsabilidades por camada;
- apontar tradeoffs;
- listar erros comuns;
- sugerir melhorias futuras.

### 6. AI End Day

Use no fim do dia.

Objetivos:

- atualizar memoria operacional;
- registrar progresso real;
- listar pendencias;
- listar riscos;
- registrar technical debt real;
- propor proximos passos.

Arquivos que podem ser atualizados quando necessario:

- `.ai/memory/current_feature.md`;
- `.ai/memory/technical_debt.md`;
- `.ai/decisions/`;
- `.ai/reviews/`.

Esta task tambem salva um snapshot do prompt de fim de dia em `.ai/reviews/YYYY-MM-DD-end-day-prompt.md`.

## Workflow Para Feature Nova

Use este fluxo quando uma nova feature ainda precisa de analise arquitetural e plano tecnico.

```text
AI Session Context
AI Morning Start
AI Memory Loop -> Start Feature
AI Memory Loop -> Technical Plan
AI Continue Feature
AI Review Feature
AI Learning Mode
AI End Day
```

### Start Feature

Esta opcao esta disponivel dentro de `AI Memory Loop`.

Use quando for iniciar uma nova feature.

Objetivos:

- analisar a feature antes de implementar;
- propor arquitetura MVVM incremental;
- explicar responsabilidades;
- mapear entidades, repositories, use cases, providers e ViewModels;
- explicar tradeoffs e riscos;
- bloquear implementacao ate aprovacao humana.

### Technical Plan

Esta opcao tambem esta disponivel dentro de `AI Memory Loop`.

Use depois da analise arquitetural e antes da implementacao.

Objetivos:

- confirmar a feature atual;
- confirmar pendencias arquiteturais;
- gerar um arquivo-plan em `.ai/plans/YYYY-MM-DD-<feature>-plan.md`;
- incluir validacao por etapa;
- incluir skills Flutter/Dart aplicaveis;
- definir riscos, criterios de aceite e itens fora de escopo.

Regra importante:

- nao implementar durante a criacao do plano tecnico.

## Papel do AI Memory Loop

A task `AI Memory Loop` abre um menu operacional com etapas do ciclo de trabalho.

Ela inclui opcoes que nao aparecem como tasks diretas em `.vscode/tasks.json`, como:

- `Start Feature`;
- `Technical Plan`.

Use `AI Memory Loop` quando quiser escolher manualmente qual etapa do fluxo executar.

## Regra Central

O fluxo do projeto prioriza planejamento, explicacao e aprovacao antes de mudancas.

Antes de editar arquivos, a IA deve:

1. explicar o plano;
2. explicar os tradeoffs;
3. indicar arquivos afetados;
4. pedir confirmacao;
5. aplicar apenas a proxima etapa aprovada;
6. validar o menor recorte executavel compativel com a mudanca;
7. resumir o que foi feito e como foi validado.
