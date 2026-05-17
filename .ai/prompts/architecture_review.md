# Architecture Review Prompt

## Objective

Review FlowDelivery architecture for consistency with MVVM, feature-first organization, Riverpod and Supabase boundaries.

## Required Context

Read before reviewing:

- `.ai/context/architecture.md`
- `.ai/context/mvvm_rules.md`
- `.ai/context/state_management_riverpod.md`
- `.ai/context/supabase_patterns.md`
- `.ai/context/coding_standards.md`

## Review Areas

Check:

- folder structure
- dependency direction
- feature isolation
- UI responsibilities
- ViewModel responsibilities
- repository boundaries
- datasource boundaries
- Riverpod provider responsibilities
- Supabase isolation
- documentation alignment

## Output Format

Use this structure:

```text
Architecture Findings
- Severity — file:line — issue and architectural impact

Recommended Fixes
- Focused corrective action

Open Questions
- Decision or ambiguity to resolve
```

## Rules

- Prefer concrete findings over broad opinions.
- Reference files and lines where possible.
- Do not propose unrelated rewrites.
- Separate immediate issues from future improvements.

## Validation Checklist

- [ ] Dependency direction was checked
- [ ] Supabase isolation was checked
- [ ] Riverpod usage was checked when present
- [ ] Documentation drift was noted
