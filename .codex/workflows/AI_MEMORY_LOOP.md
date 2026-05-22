# AI Memory Loop

## Objetivo

Este workflow define o ciclo operacional padrão de desenvolvimento assistido por IA no projeto FlowDelivery.

O objetivo é garantir:

- continuidade entre sessões;
- memória persistente;
- aprendizado guiado;
- arquitetura consistente;
- desenvolvimento incremental;
- revisão sistemática;
- controle humano sobre alterações.

---

# Fluxo Operacional Diário

## 1. Início da Sessão (Morning Start)

Sempre iniciar a sessão carregando o contexto completo do projeto.

### Comando

```txt
Leia:
.codex/commands/morning_start.md
```

### Objetivos

- recuperar contexto atual;
- recuperar sprint atual;
- recuperar feature atual;
- ativar agentes necessários;
- revisar riscos e technical debt;
- evitar perda de continuidade.

### Agentes Ativados

- teacher
- architect
- reviewer

## 2. Início de Feature (Start Feature)

Executar quando uma nova feature ainda precisa de análise arquitetural e plano técnico.

### Comando

```txt
Leia:
.codex/commands/start_feature.md
```

### Objetivos

- analisar a feature antes de implementar;
- propor arquitetura MVVM incremental;
- explicar responsabilidades e tradeoffs;
- gerar plano técnico em `.ai/plans/`;
- identificar skills Flutter/Dart relevantes por etapa;
- incluir no plano um checklist de localization guard para novos textos de UI;
- incluir no plano um checklist de theme guard para alteracoes visuais de UI;
- confirmar que a feature usará Flutter gen-l10n ARB + `AppLocalizations` para user-facing copy;
- registrar que novas telas, placeholders e dialogs nao devem nascer com strings hardcoded;
- registrar que estilos novos nao devem nascer com hardcoded visual quando houver tema/tokens;
- manter implementação bloqueada até aprovação humana.

### Regras

- não implementar durante o planejamento;
- registrar o arquivo-plan antes de executar tasks;
- respeitar ADRs, contexto versionado e guardrails.

## 3. Plano Tecnico (Technical Plan)

Executar depois da analise arquitetural da feature e antes da implementacao.

### Comando

```txt
Leia:
.codex/commands/technical_plan.md
```

### Objetivos

- confirmar a feature atual;
- revisar contexto, ADRs e skills Flutter/Dart pertinentes;
- atualizar documentacao pertinente quando houver impacto;
- gerar arquivo-plan em `.ai/plans/`;
- registrar validacao, riscos, criterios de aceite e fora de escopo;
- incluir um checklist de localization guard em toda nova task de UI;
- incluir um checklist de theme guard em toda task que alterar estilo de UI;
- exigir ARB + `AppLocalizations` antes de adicionar copy nova;
- exigir cobertura do guard test quando a task introduzir placeholders ou copy visual;
- exigir cobertura do guard test visual quando a task introduzir novos padroes de estilo;
- manter implementacao bloqueada ate aprovacao humana.

### Regras

- nao implementar durante a geracao do plano;
- cada etapa deve ser pequena e validavel;
- cada etapa deve listar arquivos, validacao e skills aplicaveis.

## 4. Desenvolvimento Incremental

Durante o desenvolvimento da feature atual.

### Comando

```txt
Leia:
.codex/commands/continue_feature.md
```

### Objetivos

- continuar implementação incremental;
- executar a próxima task pendente do arquivo em `.ai/plans`;
- identificar skills Flutter/Dart pertinentes para a task;
- evitar implementação excessiva;
- manter separação de responsabilidades;
- garantir aprendizado contínuo;
- validar arquitetura antes de codar.

### Regras

- implementar apenas a próxima etapa;
- explicar antes de modificar;
- aguardar confirmação;
- limitar quantidade de arquivos alterados;
- seguir MVVM + Clean Architecture.

## 5. Review Técnico

Executar review rigoroso da implementação atual.

### Comando

```txt
Leia:
.codex/commands/review_feature.md
```

### Objetivos

- detectar code smells;
- validar SOLID;
- validar MVVM;
- validar testabilidade;
- validar escalabilidade;
- identificar anti-patterns Flutter;
- conferir aderência às skills Flutter/Dart pertinentes;
- melhorar legibilidade e naming.

### Severidade

Classificar problemas como:

- critical
- high
- medium
- low

## 6. Learning Mode

Transformar implementação em aprendizado.

### Comando

```txt
Leia:
.codex/commands/learning_mode.md
```

### Objetivos

- aprender arquitetura;
- aprender Flutter;
- aprender Clean Architecture;
- entender tradeoffs;
- entender responsabilidades;
- reforçar boas práticas.

### Deve Explicar

- conceitos utilizados;
- fluxo da feature;
- responsabilidades dos arquivos;
- padrões arquiteturais;
- melhorias futuras;
- erros comuns.

## 7. Finalização do Dia (End Day)

Persistir memória operacional do projeto.

### Comando

```txt
Leia:
.codex/commands/end_day.md
```

### Objetivos

- atualizar memória do projeto;
- atualizar technical debt;
- atualizar decisões arquiteturais;
- registrar progresso diário;
- preparar continuidade futura.

### Arquivos Atualizados

- `.ai/memory/current_feature.md`
- `.ai/memory/technical_debt.md`
- `.ai/decisions/`
- `.ai/reviews/`

# Regras Gerais do AI Memory Loop

## Sempre

- explicar antes de implementar;
- planejar feature quando necessário;
- gerar arquivo-plan em `.ai/plans` antes da implementação;
- implementar incrementalmente;
- seguir MVVM;
- seguir Clean Architecture;
- manter separação de responsabilidades;
- gerar testes;
- incluir checklist de localization guard quando a task tocar UI, placeholders, dialogs, snackbars ou routes;
- incluir checklist de theme guard quando a task alterar estilo visual de UI;
- usar ARB + `AppLocalizations` para copy de usuario nova;
- manter o guard test de hardcoded strings atualizado quando surgirem novos padroes;
- manter o guard test visual atualizado quando surgirem novos padroes de estilo;
- revisar arquitetura;
- justificar tradeoffs;
- atualizar memória operacional.
- Execute comandos flutter e dart pelo Dart MCP. Antes execute 'add_roots' .

## Nunca

- modificar arquivos sem aprovação;
- implementar múltiplas etapas simultaneamente;
- criar lógica diretamente na UI;
- ignorar testes;
- ignorar review;
- ignorar technical debt.

# Filosofia Operacional

O Codex CLI deve atuar como:

- professor;
- arquiteto;
- pair programmer;
- reviewer;
- QA engineer;
- mentor técnico.

O desenvolvedor humano mantém:

- controle arquitetural;
- aprovação de alterações;
- decisões estratégicas;
- validação final.

# Resultado Esperado

Este workflow deve proporcionar:

- aprendizado contínuo;
- desenvolvimento profissional;
- arquitetura consistente;
- memória persistente;
- redução de retrabalho;
- maior qualidade técnica;
- evolução sustentável do projeto.
