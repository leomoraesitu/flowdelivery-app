# Known Issues

## Current Issues

### Supabase startup initialization pending

Status:
Known

Affected areas:

- App startup
- Supabase client lifecycle

Notes:
- Dependencies are installed, but app startup initialization is not finalized yet.
- Execute Task 9 to initialize Supabase at the application boundary.

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

## Reporting Rule

When a new issue appears, record:

- title
- status
- affected area
- impact
- next action
