# Generate Tests Prompt

## Objective

Generate focused tests for FlowDelivery code while preserving MVVM boundaries.

## Required Context

Read before acting:

- `.ai/context/coding_standards.md`
- `.ai/context/mvvm_rules.md`
- `.ai/context/flutter_rules.md`
- `.ai/context/state_management_riverpod.md`

## Instructions

1. Inspect the code under test first.
2. Identify behavior, not implementation details.
3. Prefer unit tests for ViewModels, repositories, services and mappers.
4. Prefer widget tests for critical rendering and user flows.
5. Mock or fake external dependencies.
6. Keep Supabase client calls behind datasource or repository fakes.
7. Run the smallest relevant test command.

## Test Targets

Prioritize:

- loading states
- success states
- error states
- empty states
- repository mapping
- validation rules
- critical user interactions

## Expected Deliverables

- test files added or updated
- clear test names
- focused assertions
- validation command and result

## Validation Checklist

- [ ] Tests cover observable behavior
- [ ] Tests avoid brittle internals
- [ ] External dependencies are isolated
- [ ] Test command was run or blocker documented
