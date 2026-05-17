# FlowDelivery — Estimation Guide

## Objective

Define how FlowDelivery estimates work for planning, prioritization and delivery tracking.

---

## Estimation Principles

Estimates represent:

- complexity
- uncertainty
- effort
- coordination cost

Estimates are not exact time promises.

---

## Story Points

Use story points for backlog and sprint planning.

Recommended scale:

- `1` — trivial, low risk
- `2` — small, clear task
- `3` — moderate task with limited uncertainty
- `5` — larger task with multiple steps
- `8` — complex task with meaningful uncertainty
- `13` — large epic or task that should usually be split

---

## Estimation Factors

Consider:

- implementation complexity
- number of affected files or modules
- dependency on external tools
- data model impact
- UI state complexity
- testing effort
- documentation effort
- risk of regression

---

## When a Card Is Ready to Estimate

A card can be estimated when it has:

- objective
- scope
- acceptance criteria
- dependencies
- affected area or owner

If these are missing, move the card to `🧠 Refinement`.

---

## Splitting Rules

Split a card when:

- estimate is `13` or higher
- acceptance criteria describe unrelated outcomes
- implementation touches unrelated modules
- QA cannot validate it in one focused pass
- the card mixes discovery and implementation

---

## Estimation by Work Type

### Documentation

Usually `1` to `3`.

Can be `5` when it requires architecture decisions or cross-document alignment.

### Feature

Usually `3` to `8`.

Can be higher when it includes UI, state management, data persistence and QA.

### Bug Fix

Estimate after reproduction.

Use higher estimates when root cause is unknown.

### Refactor

Estimate based on blast radius, not number of lines.

Include validation and regression risk.

### Release Work

Estimate based on checklist size, QA effort and coordination.

---

## Confidence Levels

Use confidence informally during planning:

- High: scope and approach are clear
- Medium: known unknowns exist
- Low: discovery is still required

Low-confidence work should enter refinement before implementation.

---

## Acceptance Criteria

- [ ] Cards are estimated only after refinement
- [ ] Large cards are split
- [ ] Risk and uncertainty influence estimates
- [ ] Estimates are reviewed during sprint planning
