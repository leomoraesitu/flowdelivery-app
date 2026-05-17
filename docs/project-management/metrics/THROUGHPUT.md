# FlowDelivery — Throughput

## Objective

Define how FlowDelivery tracks the number of completed work items over time.

---

## Definition

Throughput is the count of cards completed during a time period.

Unlike velocity, throughput counts cards, not story points.

---

## How to Measure

For a chosen period:

1. Count cards moved to `🎉 Done`.
2. Group by work type when useful.
3. Compare against previous periods.

Recommended periods:

- sprint
- week
- release cycle

---

## How to Use

Use throughput to:

- understand delivery flow
- detect whether work is moving steadily
- compare card completion volume across sprints
- balance small fixes, features and technical debt

---

## Trello Usage

Relevant lists:

- `🎉 Done`
- `🚀 Ready for Release`

Useful grouping labels:

- `feat`
- `fix`
- `docs`
- `refactor`
- `chore`
- `technical-debt`
- `release`

---

## Interpretation Rules

High throughput does not always mean high value.

Low throughput does not always mean poor progress.

Review throughput together with:

- velocity
- cycle time
- card size
- release impact
- quality outcomes

---

## Anti-Patterns

Avoid:

- splitting cards only to inflate throughput
- ignoring large high-value work
- comparing unrelated work types directly
- counting cards that are not truly Done

---

## Acceptance Criteria

- [ ] Only Done cards are counted
- [ ] Period is defined before reporting
- [ ] Card type is considered during analysis
- [ ] Throughput is reviewed with quality context
