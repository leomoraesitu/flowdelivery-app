# Security Policy

## Supported Versions

FlowDelivery is in Sprint 0 foundation phase. Security practices are defined before production release.

## Reporting Security Issues

Do not disclose security issues publicly before review.

For portfolio development, report issues directly to the project owner.

## Secret Handling

- Never commit real API keys.
- Never commit Supabase service role keys.
- Use local environment files for development secrets.
- Use repository or organization secrets for CI/CD.

## Application Security Baseline

- Enable Row Level Security for Supabase tables.
- Validate user input.
- Keep privileged operations outside the Flutter client.
- Restrict access by authenticated user and role.
