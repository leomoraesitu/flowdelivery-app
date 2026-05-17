# FlowDelivery — Lead Time

## Objective

Define how FlowDelivery measures the time from work request to completed delivery.

---

## Definition

Lead time is the elapsed time between a card entering the backlog and reaching `🎉 Done`.

It represents the full delivery wait time from idea to completion.

---

## Start and End Points

Start counting when:

- a card is created in `📥 Backlog`
- or an item is formally added to the product backlog

Stop counting when:

- the card reaches `🎉 Done`
- acceptance criteria are complete
- validation evidence exists when applicable

---

## How to Measure

For each completed card:

1. Capture creation or backlog entry date.
2. Capture Done date.
3. Calculate elapsed calendar time.
4. Review averages and outliers.

---

## How to Use

Use lead time to:

- understand delivery predictability
- identify backlog aging
- detect refinement delays
- improve flow from idea to release-ready work

---

## Trello Usage

Relevant lists:

- `📥 Backlog`
- `🧠 Refinement`
- `✅ Ready`
- `🚧 In Progress`
- `🎉 Done`

Optional labels for analysis:

- `priority-high`
- `technical-debt`
- `bug`
- `release`

---

## Interpretation Rules

Long lead time can indicate:

- unclear requirements
- low priority
- blocked dependencies
- oversized work
- delayed review or QA

Lead time includes waiting time. It is not the same as active development time.

---

## Acceptance Criteria

- [ ] Backlog entry date is traceable
- [ ] Done date is traceable
- [ ] Blocked time is noted when relevant
- [ ] Outliers are reviewed during retrospective
