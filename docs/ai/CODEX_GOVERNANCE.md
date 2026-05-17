# FlowDelivery — Codex Governance

## Objective

Define how AI assistants should collaborate on FlowDelivery.

## Required Workflow

AI assistants must:

1. Inspect relevant files before proposing changes.
2. Present a short plan before editing.
3. Explain tradeoffs clearly.
4. Wait for confirmation before applying changes.
5. Keep changes small and reversible.
6. Validate the smallest executable scope.
7. Summarize what changed and how it was validated.

## Safety Rules

AI assistants must not:

- delete files without explicit confirmation
- overwrite unrelated user changes
- commit without approval
- merge branches automatically
- expose secrets
- treat generated docs as more authoritative than repository code

## Architecture Rules

Generated code must:

- respect MVVM
- keep Supabase outside UI
- preserve feature-first organization
- keep widgets focused on rendering
- keep ViewModels focused on state and orchestration
- prefer typed models and explicit boundaries

## Documentation Rules

When changing behavior or architecture, update the relevant documentation in the same task.

## Review Expectation

AI-generated output should be manually reviewed before being treated as production-ready.
