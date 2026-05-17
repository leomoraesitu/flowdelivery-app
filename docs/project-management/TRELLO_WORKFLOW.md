# FlowDelivery — Trello Workflow

## Objective

Define the operational workflow used in Trello for FlowDelivery project management.

---

## Boards

### FlowDelivery - Project Management

Board for governance, architecture decisions, project documentation, releases, metrics and risks.

Lists:

- 🏛️ Governance
- 🏔️ Epics
- 🛣️ Roadmap
- 📚 Documentation
- 🏗️ Architecture
- 🎨 Design System
- 🤖 AI & Codex
- ⚙️ DevOps & Infrastructure
- 🚀 Releases
- 📊 Metrics
- ⚠️ Risks & Blockers
- ✅ Decisions Log
- 🧊 Archive

### FlowDelivery - Product Backlog

Board for epics, roadmap items, sprint-ready work and implementation workflow.

Lists:

- 🏔️ Epics
- 🛣️ Roadmap
- 📥 Backlog
- 🧠 Refinement
- ✅ Ready
- 🚧 In Progress
- 👀 Code Review
- 🧪 QA
- 🚀 Ready for Release
- 🎉 Done
- ⛔ Blocked

---

## Card Structure

### Title Pattern

```text
[TYPE] Task Name
```

Examples:

```text
[FEAT] Authentication Flow
[FIX] Cart persistence issue
[DOCS] MVVM architecture
[CHORE] Configure Flutter CI
```

### Required Card Sections

```text
# Objective

# Scope

# Acceptance Criteria

# Dependencies

# Technical Notes
```

---

## Labels

### Technical

- frontend
- backend
- supabase
- mvvm
- architecture
- api
- database
- security
- performance

### Process

- docs
- feat
- fix
- refactor
- chore
- test
- qa
- release
- blocked

### Product and Portfolio

- ai
- auth
- analytics
- design-system
- flutterflow
- recruiter-portfolio
- technical-debt
- ux

### Priority

- priority-high
- priority-medium
- priority-low

---

## Product Backlog Workflow Rules

### Backlog → Refinement

Requirements:

- objective drafted
- expected outcome identified
- ownership or area defined

### Refinement → Ready

Requirements:

- scope defined
- acceptance criteria defined
- dependencies mapped
- labels assigned

### Ready → In Progress

Requirements:

- item selected for execution
- implementation approach clear
- branch or working context identified

### In Progress → Code Review

Requirements:

- implementation completed
- `flutter analyze` executed when applicable
- `flutter test` executed when applicable
- documentation updated when needed

### Code Review → QA

Requirements:

- review completed
- no blocking issues
- validation evidence available

### QA → Ready for Release

Requirements:

- QA approved
- no blocking bugs
- release impact understood

### Ready for Release → Done

Requirements:

- release or documentation state finalized
- acceptance criteria satisfied
- related docs/cards updated

### Any List → Blocked

Use when:

- external dependency prevents progress
- credentials or access are missing
- product or technical decision is unresolved

---

## Project Management Board Usage

Use Project Management lists for cross-cutting work:

- governance standards
- roadmap planning
- architecture decisions
- design system decisions
- AI/Codex process rules
- DevOps and infrastructure tasks
- release notes
- project metrics
- risks and blockers
- decision logs
- archived governance artifacts

---

## Sprint Cadence

Recommended:

- Sprint duration: 1 or 2 weeks
- Sprint Planning
- Daily progress validation
- Sprint Review
- Retrospective

---

## AI Workflow

Codex must:

1. Analyze repository context.
2. Propose a short plan.
3. Wait for confirmation.
4. Implement incrementally.
5. Validate the smallest executable scope.
6. Explain what changed and how it was validated.
