# FlowDelivery — Burndown

## Objective

Define how FlowDelivery tracks remaining sprint work over time.

---

## Definition

Burndown shows how much planned sprint work remains during a sprint.

It helps identify whether delivery is progressing at a sustainable pace.

---

## How to Measure

At sprint start:

1. Sum story points for all committed sprint cards.
2. Record total planned scope.

During the sprint:

1. Subtract points only when cards reach `🎉 Done`.
2. Keep unfinished cards in the remaining total.
3. Track scope changes separately.

---

## How to Use

Use burndown to:

- detect blocked work early
- identify sprint scope risk
- support daily progress checks
- decide whether scope needs adjustment

Burndown should trigger conversation, not blame.

---

## Trello Usage

Relevant lists:

- `✅ Ready`
- `🚧 In Progress`
- `👀 Code Review`
- `🧪 QA`
- `🎉 Done`
- `⛔ Blocked`

Recommended tracking:

- total planned points
- remaining points
- completed points
- added or removed scope

---

## Scope Change Rule

If a card is added after sprint start:

- mark it as scope change
- record why it was added
- update burndown notes separately

Do not hide scope change inside normal progress.

---

## Interpretation Rules

A flat burndown can mean:

- work is blocked
- cards are too large
- QA is accumulating
- acceptance criteria are unclear

A steep drop at the end can mean:

- work is batched
- cards are too large
- Done criteria are delayed

---

## Acceptance Criteria

- [ ] Sprint scope is recorded at start
- [ ] Done is the only completion signal
- [ ] Scope changes are visible
- [ ] Blockers are reviewed when burndown stalls
