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

### Trello synchronization is partial/manual

Status:
Known

Affected areas:

- Trello boards
- Trello templates

Notes:
- Local JSON/Markdown artifacts exist.
- The real Trello card for base navigation strategy was updated through authenticated Zapier tooling.
- Broad Trello synchronization is still manual/partial and depends on authenticated integration availability per task.

## Reporting Rule

When a new issue appears, record:

- title
- status
- affected area
- impact
- next action
