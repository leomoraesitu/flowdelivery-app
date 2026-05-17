# FlowDelivery — Risk Management

## Objective

Define how FlowDelivery identifies, classifies, mitigates and tracks project risks.

---

## Risk Principles

Risks must be:

- visible
- owned
- reviewed regularly
- connected to concrete mitigation actions

---

## Risk Categories

### Product Risk

Examples:

- unclear MVP scope
- feature does not support portfolio goal
- user flow is incomplete

### Technical Risk

Examples:

- architecture inconsistency
- Supabase integration uncertainty
- missing validation coverage
- excessive technical debt

### Delivery Risk

Examples:

- sprint scope too large
- blocked dependencies
- unclear acceptance criteria
- delayed review or QA

### Operational Risk

Examples:

- missing credentials
- unavailable external tools
- broken CI workflow
- release process not followed

---

## Risk Levels

### High

Impact can block release, break core flows or require significant rework.

### Medium

Impact can slow delivery or create localized rework.

### Low

Impact is small, understood and easy to recover from.

---

## Risk Card Structure

Use this structure in Trello:

```text
# Risk

# Impact

# Probability

# Mitigation

# Owner

# Review Date
```

---

## Risk Workflow

### Identify

Create a risk card when a meaningful uncertainty appears.

Recommended Trello location:

- `⚠️ Risks & Blockers`
- `⛔ Blocked`

### Assess

Classify:

- impact
- probability
- affected area
- release or sprint impact

### Mitigate

Mitigation must define:

- concrete action
- owner
- expected outcome
- review date

### Monitor

Risks should be reviewed:

- during sprint planning
- during release preparation
- whenever a blocker appears

### Close

A risk can be closed when:

- it no longer applies
- mitigation was completed
- impact was accepted and documented

---

## Escalation Rules

Escalate a risk when:

- it blocks sprint progress
- it affects release quality
- it requires a product or architecture decision
- it has no clear owner

---

## Acceptance Criteria

- [ ] High and medium risks are visible in Trello
- [ ] Each active risk has an owner
- [ ] Mitigation is documented
- [ ] Blockers are reviewed before release
