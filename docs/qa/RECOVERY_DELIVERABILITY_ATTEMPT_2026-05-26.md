# Recovery Deliverability Attempt - 2026-05-26

## Scope

Validate password-recovery email deliverability for a non-local QA mailbox using the runbook in `docs/setup/SUPABASE_SETUP.md`.

## Execution Status

Completed with evidence.

## Follow-up Attempt - 2026-05-27

QA mailbox/provider became available and the full runbook was executed.

## Preconditions Check

- Supabase runtime configuration file exists locally: `.vscode/supabase.local.json`.
- App-level recovery flow implementation is already validated in focused automated tests and local recovery-link QA.

## Execution Evidence

- Mail provider/mailbox: Outlook (Hotmail) non-local QA inbox.
- Recovery email arrival: confirmed in inbox.
- Recovery link target URL: `http://localhost:3000/reset-password?...`.
- Recovery page rendering: confirmed at `/reset-password` on local web run.
- Password update submission: successful; app banner confirmed password update completion.

## Anomaly Notes

- During repeated attempts, Supabase Auth responded with `429 Too Many Requests` (`email rate limit exceeded`) until cooldown elapsed.
- One follow-up URL carried `otp_expired` query params, but the final controlled attempt still completed with a successful password update flow after using a fresh link and consistent browser context.

## Next Action

Keep as monitoring evidence only. For future recovery QA runs, use a fixed local origin (`http://localhost:3000`) and avoid mixed browser contexts to prevent PKCE/session drift.
