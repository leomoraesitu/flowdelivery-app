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

### Localization Guard Checklist

Use the exact Localization Guard Checklist below for any card that introduces or changes user-facing text.

- [ ] Every new user-facing string has an ARB key
- [ ] UI reads strings through `AppLocalizations`
- [ ] No hardcoded copy in `Text`, `SnackBar`, `Tooltip`, `AlertDialog`, `BottomSheet`, `showModalBottomSheet`, or `semanticLabel`
- [ ] New placeholders and route placeholders are covered by the guard test

### Theme Guard Checklist

Use the exact Theme Guard Checklist below for any card that introduces or changes user-facing UI styling.

- [ ] UI uses only semantic theme APIs and app tokens (`Theme.of(context)`, `AppSpacing`, `AppRadius`, `AppSizes`, `AppDurations`)
- [ ] No `Color(0x...)` hardcoded values in feature presentation code
- [ ] No direct `AppLightColors` or `AppDarkColors` usage outside `lib/app/theme`
- [ ] No direct `Colors.*` hardcoded usage in feature presentation when equivalent semantic `ColorScheme` roles exist
- [ ] Visual hardcoded guard test remains green after UI changes

### JSON Checklist Structure

Markdown checklist items inside `desc` are useful for human reading, but they are not enough for automation. Any JSON card that needs real Trello checklists must also declare a `checklists` array.

When creating or updating a real Trello card through MCP/API:

- create the card body first;
- create one real Trello checklist for every object in `checklists`;
- create one real Trello checklist item for every `checkItems[]` entry;
- validate the result with `trello_get_card_checklists`;
- do not leave duplicated `- [ ]` checklist items in `desc` after real checklists exist.

Use this structure:

```json
{
  "name": "[FEAT] Example card",
  "desc": "# Objective\nDescribe the expected outcome.\n\n# Acceptance Criteria\n- [ ] First criterion\n- [x] Completed criterion",
  "checklists": [
    {
      "name": "Acceptance Criteria",
      "checkItems": [
        {
          "name": "First criterion",
          "pos": 1,
          "state": "incomplete"
        },
        {
          "name": "Completed criterion",
          "pos": 2,
          "state": "complete"
        }
      ]
    }
  ]
}
```

### UI Card Example (Localization + Theme Guard)

Use this example when creating cards that change user-facing UI:

```json
{
  "name": "[FEAT] Update sign-in screen states",
  "desc": "# Objective\nImprove sign-in feedback and loading states.\n\n# Scope\n- Update button loading state\n- Add error banner and retry action\n\n# Acceptance Criteria\n- [ ] New copy uses ARB keys\n- [ ] UI uses semantic colors and tokens only",
  "checklists": [
    {
      "name": "Localization Guard Checklist",
      "checkItems": [
        {
          "name": "Every new user-facing string has an ARB key",
          "pos": 1,
          "state": "incomplete"
        },
        {
          "name": "UI reads strings through AppLocalizations",
          "pos": 2,
          "state": "incomplete"
        },
        {
          "name": "No hardcoded copy in Text, SnackBar, Tooltip, AlertDialog, BottomSheet, showModalBottomSheet, or semanticLabel",
          "pos": 3,
          "state": "incomplete"
        },
        {
          "name": "New placeholders and route placeholders are covered by the guard test",
          "pos": 4,
          "state": "incomplete"
        }
      ]
    },
    {
      "name": "Theme Guard Checklist",
      "checkItems": [
        {
          "name": "UI uses only semantic theme APIs and app tokens (Theme.of(context), AppSpacing, AppRadius, AppSizes, AppDurations)",
          "pos": 1,
          "state": "incomplete"
        },
        {
          "name": "No Color(0x...) hardcoded values in feature presentation code",
          "pos": 2,
          "state": "incomplete"
        },
        {
          "name": "No direct AppLightColors or AppDarkColors usage outside lib/app/theme",
          "pos": 3,
          "state": "incomplete"
        },
        {
          "name": "No direct Colors.* hardcoded usage in feature presentation when equivalent semantic ColorScheme roles exist",
          "pos": 4,
          "state": "incomplete"
        },
        {
          "name": "Visual hardcoded guard test remains green after UI changes",
          "pos": 5,
          "state": "incomplete"
        }
      ]
    }
  ]
}
```

Automation rules:

- `desc` remains the readable card body.
- `checklists` is the source of truth for creating Trello checklists.
- `checkItems[].state` must be `incomplete` or `complete`.
- `checkItems[].pos` is 1-based and preserves item order.
- Supported generated checklist names are `Scope`, `Acceptance Criteria`, `Dependencies`, `Checklist`, `Features` and `Possibilities`.
- Real Trello card creation is incomplete until checklist parity is verified with `trello_get_card_checklists`.

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
- Localization Guard and Theme Guard checklists attached when card affects user-facing UI

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
- Localization Guard and Theme Guard checklist items completed for user-facing UI cards

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
