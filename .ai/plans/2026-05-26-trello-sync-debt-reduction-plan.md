# Trello Sync Debt Reduction Plan

## Objective

Reduce manual synchronization drift between versioned project-management artifacts and real Trello cards without pretending that local files can prove external Trello state.

## Current Problem

The repository already has a local guard for documentation and Trello JSON templates, but real Trello cards can still drift because checklist states live outside git. This creates a human QA problem: docs may be correct while the board is stale, or the board may be updated without evidence in the repo.

## Approved Approach

Use a small operational workflow:

1. Keep `DEFINITION_OF_DONE.md`, `TRELLO_WORKFLOW.md`, and Trello JSON templates aligned through the local guard.
2. Require `trello_get_card_checklists` after creating or updating real cards.
3. Use `trello_update_checklist_item_state` only after local validation evidence exists.
4. Add a Trello comment when a real card is used as delivery evidence.
5. Keep the debt in `Reduced / Monitoring` because Trello remains an external stateful system.

## Scope

- Document the real Trello parity check in `docs/project-management/TRELLO_WORKFLOW.md`.
- Reconcile the local workflow checklist text with the canonical Definition of Done.
- Update technical debt notes to point at the new operating rule.

## Out of Scope

- Full Trello-to-git synchronization.
- CI access to Trello credentials.
- Automatic closure of Trello items without human validation.
- Migration of old cards unless they are touched by active work.

## Validation

- Run `flutter test test/app/project_management/trello_guard_checklists_test.dart`.
- For any real card touched during active work, confirm state with `trello_get_card_checklists`.

## Risks

- Real Trello state can still drift if updates happen outside the documented workflow.
- MCP availability and credentials are session-dependent.
- Local guards validate structure and canonical text, not delivery truth.
