# FlowDelivery — Incident Management

## Objective

Define how FlowDelivery responds to bugs, regressions, broken releases and operational incidents.

---

## Incident Principles

Incident response must prioritize:

- user impact
- data integrity
- clear communication
- fast containment
- documented learning

---

## Incident Severity

### Critical

Examples:

- app cannot start
- authentication is unavailable
- data loss or data corruption risk
- release artifact is unusable

Response:

- stop related release work
- create incident card
- prioritize containment immediately

### High

Examples:

- core user flow is broken
- checkout or order tracking fails
- major regression affects many users

Response:

- move issue to top priority
- assign owner
- validate fix before release

### Medium

Examples:

- non-critical feature fails
- UI issue blocks a secondary flow
- workaround exists

Response:

- triage in bug workflow
- plan fix based on release impact

### Low

Examples:

- minor visual issue
- typo
- low-impact edge case

Response:

- add to backlog
- fix when aligned with sprint priorities

---

## Incident Workflow

### 1. Detect

Sources:

- QA
- manual testing
- user report
- CI failure
- release validation

### 2. Triage

Record:

- severity
- environment
- affected flow
- reproduction steps
- evidence

Recommended Trello location:

- bug triage board
- `⛔ Blocked` when it blocks delivery
- `⚠️ Risks & Blockers` when it affects release confidence

### 3. Contain

Containment may include:

- revert
- disable risky path
- postpone release
- document workaround
- isolate affected scope

### 4. Fix

Fix must include:

- root cause hypothesis
- focused implementation
- validation evidence
- regression check when applicable

### 5. Validate

Validation must confirm:

- original issue no longer reproduces
- nearby flows still work
- no new blocker was introduced

### 6. Close

Closure requires:

- incident card updated
- fix evidence attached or summarized
- follow-up tasks created when needed

---

## Postmortem

Use a postmortem for critical or repeated incidents.

Structure:

```text
# Summary

# Impact

# Timeline

# Root Cause

# Resolution

# Follow-up Actions
```

---

## Communication Rules

Incident updates should be:

- factual
- short
- timestamped when needed
- clear about current status and next action

Avoid declaring resolution before validation evidence exists.

---

## Acceptance Criteria

- [ ] Incident severity is classified
- [ ] Reproduction steps are documented
- [ ] Owner is assigned
- [ ] Fix is validated
- [ ] Follow-up work is tracked
