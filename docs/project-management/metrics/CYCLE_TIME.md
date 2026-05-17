# FlowDelivery — Cycle Time

## Objective

Define how FlowDelivery measures the active time required to complete work once execution starts.

---

## Definition

Cycle time is the elapsed time between a card entering `🚧 In Progress` and reaching `🎉 Done`.

It focuses on delivery execution after work has been selected.

---

## Start and End Points

Start counting when:

- a card moves to `🚧 In Progress`

Stop counting when:

- the card reaches `🎉 Done`
- acceptance criteria are complete
- QA and review are complete when required

---

## How to Measure

For each completed card:

1. Capture the date it entered `🚧 In Progress`.
2. Capture the date it reached `🎉 Done`.
3. Calculate elapsed calendar time.
4. Compare by work type and priority.

---

## How to Use

Use cycle time to:

- find delivery bottlenecks
- evaluate review and QA flow
- detect oversized cards
- improve sprint execution

---

## Trello Usage

Relevant lists:

- `🚧 In Progress`
- `👀 Code Review`
- `🧪 QA`
- `🚀 Ready for Release`
- `🎉 Done`
- `⛔ Blocked`

Track separately when work spends time in:

- Code Review
- QA
- Blocked

---

## Interpretation Rules

Long cycle time can indicate:

- unclear implementation approach
- too much work in progress
- review delay
- QA bottleneck
- hidden dependencies

Cycle time should be interpreted with card size and complexity.

---

## Acceptance Criteria

- [ ] In Progress date is traceable
- [ ] Done date is traceable
- [ ] Review and QA delays are visible
- [ ] Blocked periods are documented
