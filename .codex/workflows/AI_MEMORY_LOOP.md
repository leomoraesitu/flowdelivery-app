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

## 2. Desenvolvimento Incremental

Durante o desenvolvimento da feature atual.

### Comando

```txt
Leia:
.codex/commands/continue_feature.md
```

### Objetivos

- continuar implementação incremental;
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

## 3. Review Técnico

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
- melhorar legibilidade e naming.

### Severidade

Classificar problemas como:

- critical
- high
- medium
- low

## 4. Learning Mode

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

## 5. Finalização do Dia (End Day)

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
- implementar incrementalmente;
- seguir MVVM;
- seguir Clean Architecture;
- manter separação de responsabilidades;
- gerar testes;
- revisar arquitetura;
- justificar tradeoffs;
- atualizar memória operacional.

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
