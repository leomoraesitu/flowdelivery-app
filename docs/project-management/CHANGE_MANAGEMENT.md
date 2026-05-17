# FlowDelivery — Change Management

## Objective

Define how FlowDelivery evaluates, approves and tracks changes to scope, architecture, process and delivery plans.

---

## Change Principles

Changes must be:

- intentional
- documented
- reviewed before implementation
- connected to impact and tradeoffs

---

## Change Types

### Scope Change

Examples:

- adding a new feature to a sprint
- removing a planned deliverable
- changing MVP boundaries

### Technical Change

Examples:

- changing architecture direction
- replacing a package or service
- modifying folder structure
- changing data model assumptions

### Process Change

Examples:

- changing Trello workflow
- changing Definition of Done
- changing release gates
- changing review expectations

---

## Change Request Structure

Use this structure for change cards or documentation:

```text
# Change

# Reason

# Impact

# Alternatives Considered

# Decision

# Follow-up Actions
```

---

## Evaluation Criteria

Evaluate each change by:

- user value
- delivery impact
- technical risk
- documentation impact
- testing impact
- release impact

---

## Approval Rules

### Low-Risk Change

Can proceed when:

- scope is clear
- validation is simple
- no release risk exists

### Medium-Risk Change

Requires:

- documented impact
- updated acceptance criteria
- review before implementation

### High-Risk Change

Requires:

- explicit approval
- mitigation plan
- rollback or fallback path
- release impact review

---

## Trello Workflow

Recommended locations:

- `🧠 Refinement` for proposed changes
- `🏗️ Architecture` for architecture changes
- `✅ Decisions Log` for accepted decisions
- `⚠️ Risks & Blockers` for risky or unresolved changes

---

## Documentation Rules

Update related documents when a change affects:

- architecture
- design system
- release process
- QA strategy
- Trello workflow
- project management standards

---

## Acceptance Criteria

- [ ] Change reason is documented
- [ ] Impact is understood
- [ ] Decision is recorded
- [ ] Follow-up cards are created when needed
- [ ] Related documentation is updated
