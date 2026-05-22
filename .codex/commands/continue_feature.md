# Continue Feature Command

Leia:

- `.ai/memory/current_feature.md`
- `.ai/context/*`
- `.codex/workflows/03_incremental_implementation.md`

Continue a feature atual.

Implemente somente a próxima etapa pendente.

Antes:

- explique arquitetura
- explique responsabilidades
- explique tradeoffs
- confirme arquivos afetados
- confirme se a etapa introduz novos textos de usuario;
- se introduzir, inclua o checklist de localization guard na etapa;
- garanta que ARB + `AppLocalizations` sejam a fonte de verdade para strings novas;

Depois:

- explique código criado
- explique boas práticas
- valide o menor recorte útil
- atualize `.ai/memory/current_feature.md` quando necessário

## Checklist de Localization Guard

Quando a tarefa adicionar ou alterar texto de usuario, a IA deve verificar explicitamente:

- existe chave nova em ARB para cada string nova?
- a UI consome `AppLocalizations` em vez de texto hardcoded?
- placeholders, `SnackBar`, `Tooltip`, `AlertDialog`, `BottomSheet`, `showModalBottomSheet` e `semanticLabel` tambem estao localizados?
- o guard test continua verde depois da mudanca?

Se a resposta para qualquer item for nao, a etapa nao esta pronta para fechamento.

Aguarde confirmação antes de continuar para outra etapa.

## Uso

```text
Leia:
.codex/commands/continue_feature.md
```
