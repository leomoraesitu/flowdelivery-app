# Agent — Architect — Examples

## Example Request

```text
Use .ai/agents/architect para revisar a arquitetura da feature auth.
Não implemente ainda.
```

## Expected Output

- architecture assessment
- risks and tradeoffs
- recommended structure
- validation checklist

## Example Finding

```text
High — lib/features/auth/presentation/login_page.dart — a página chama Supabase diretamente.
Isso viola MVVM e dificulta testes. Mover a chamada para datasource + repository.
```
