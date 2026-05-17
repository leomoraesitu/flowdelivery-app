# Review Code Prompt

## Objective

Review FlowDelivery code for correctness, architecture consistency, maintainability and missing validation.

## Required Context

Read before reviewing:

- `.ai/context/architecture.md`
- `.ai/context/coding_standards.md`
- `.ai/context/mvvm_rules.md`
- `.ai/context/flutter_rules.md`
- `.ai/context/supabase_patterns.md`

## Review Priorities

Lead with findings.

Prioritize:

- behavioral bugs
- architecture violations
- direct Supabase usage in UI
- state management misuse
- missing error/loading states
- missing tests for risky changes
- documentation drift

## Output Format

Use this structure:

```text
Findings
- Severity — file:line — issue and impact

Open Questions
- Question or assumption

Summary
- Short change summary if useful
```

## Rules

- Do not rewrite code during review unless explicitly asked.
- Include file and line references.
- Avoid style-only comments unless they affect maintainability.
- Call out unvalidated claims.

## Validation Checklist

- [ ] Findings are ordered by severity
- [ ] Each finding has a concrete impact
- [ ] Architecture rules were checked
- [ ] Test gaps were identified
