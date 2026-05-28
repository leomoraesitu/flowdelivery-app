# Incremental Implementation Workflow

Leia:

- `.codex/guardrails.md`
- `.ai/context/*`
- `.ai/agents/teacher/*`
- `.ai/agents/senior_flutter_engineer/*`
- `.ai/context/agent_skills.md`

## Objetivo

Implementar somente a etapa solicitada.

## Antes

- leia o arquivo-plan pertinente em `.ai/plans/`
- identifique a próxima etapa pendente
- identifique as skills aplicáveis em `.agents/skills`
- Execute comandos flutter e dart pelo Dart MCP. Antes execute 'add_roots' .
- explique o objetivo
- explique o conceito
- explique os arquivos
- explique por que as skills escolhidas se aplicam
- confirme que a etapa respeita o limite de mudanças

## Depois

- explique o código
- explique responsabilidades
- explique boas práticas
- rode a menor validação útil
- registre o que foi validado
- atualize o checklist do arquivo-plan quando apropriado

## Nunca

- implementar múltiplas etapas
- modificar muitos arquivos sem confirmação
- prosseguir sem confirmação
- criar lógica diretamente na UI
- chamar Supabase diretamente em widgets
- usar skills genéricas que conflitem com as ADRs do projeto

## Saída esperada

- arquivos alterados
- resumo técnico
- aprendizado Flutter
- skills usadas
- validação executada
- próximos passos
