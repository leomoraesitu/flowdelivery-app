# Known Issues

## Current Issues

### Dependencies not installed yet

Status:
Known

Affected areas:

- Riverpod
- GoRouter
- Supabase client

Notes:
- These are architecture decisions, but package installation has not happened yet.
- Do not import missing packages before adding dependencies intentionally.

### Trello synchronization is local-only

Status:
Known

Affected areas:

- Trello boards
- Trello templates

Notes:
- Local JSON/Markdown artifacts exist.
- Real Trello synchronization depends on authenticated integration.

## Reporting Rule

When a new issue appears, record:

- title
- status
- affected area
- impact
- next action
