# Known Issues

## Current Issues

### Supabase startup initialization completed

Status:
Resolved

Affected areas:

- App startup
- Supabase client lifecycle

Notes:
- App startup initialization was implemented at the app boundary.
- Keep this item as resolved history to avoid reintroducing startup initialization drift.

### Trello synchronization is partial/manual

Status:
Resolved for Sprint 0 completed open items

Affected areas:

- Trello boards
- Trello templates

Notes:
- Local JSON/Markdown artifacts exist.
- The real Trello card for base navigation strategy was updated through authenticated Zapier tooling.
- Theme structure, GitHub labels and Sprint 0 open item cards were updated through authenticated Zapier/Trello tooling.
- Future Trello synchronization still depends on authenticated integration availability per task.

### Auth localization drift risk after rapid stabilization slices

Status:
Resolved

Affected areas:

- Authentication UI copy
- User-safe auth error copy
- Design system documentation consistency

Notes:
- Auth flow text was translated to PT-BR.
- Auth copy was centralized in Flutter gen-l10n ARB files and generated `AppLocalizations`.
- Font, locale, and localization-guard references were aligned in design-system, sprint, and workflow docs.
- Focused auth tests remained green after refactor.

## Reporting Rule

When a new issue appears, record:

- title
- status
- affected area
- impact
- next action
