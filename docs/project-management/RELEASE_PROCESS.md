# FlowDelivery — Release Process

## Objective

Define the release workflow used to move FlowDelivery from validated work to a stable published version.

---

## Release Principles

Every release must be:

- scoped
- validated
- documented
- reversible when possible
- aligned with the Definition of Done

---

## Release Types

### Patch Release

Used for:

- bug fixes
- small documentation corrections
- low-risk configuration updates

### Minor Release

Used for:

- new user-facing features
- workflow improvements
- non-breaking technical upgrades

### Major Release

Used for:

- breaking changes
- large architecture changes
- major product milestones

---

## Release Workflow

### 1. Scope Definition

Requirements:

- release objective defined
- included cards listed
- excluded items documented
- known risks mapped

Trello location:

- `🚀 Releases`
- `🚀 Ready for Release`

### 2. Code Freeze

After code freeze:

- only release-critical fixes are accepted
- new feature work moves to the next release
- release notes are drafted
- QA checklist is locked

### 3. Validation

Required validation:

- analyzer/build command executed when applicable
- tests executed when applicable
- main user flows reviewed
- documentation impact checked
- known bugs triaged

### 4. Release Notes

Release notes must include:

- release version
- release date
- added functionality
- fixed issues
- technical changes
- known limitations

The release preparation commit (version bump + `docs/releases/vX.Y.Z.md`)
must also update `CHANGELOG.md`: promote the `[Unreleased]` items into a new
`[X.Y.Z] - date` entry and add anything shipped in the release that is not
yet listed. This happens **before** the merge to `main` and the tag, so the
tagged commit already carries the complete changelog entry (v0.3.0 lesson:
the changelog was reconciled post-tag and required an extra commit on `main`).

### 5. Approval

A release can ship when:

- acceptance criteria are complete
- QA has no blocking issues
- risks are accepted or mitigated
- rollback path is understood

### 6. Publish

Publishing may include:

- tag creation
- artifact generation
- README update
- screenshots or demo assets
- deployment or distribution step

Web deployment is automated: pushing a `v*.*.*` tag triggers
`.github/workflows/deploy-web.yml`, which builds the Flutter web app and
publishes it to GitHub Pages at https://leomoraesitu.github.io/flowdelivery-app/.
The only manual post-deploy step is keeping the Supabase Auth URL allow-list in
sync with the Pages origin.

### 7. Post-Release Review

After release:

- confirm release status
- record incidents or regressions
- move completed cards to `🎉 Done`
- create follow-up cards for remaining issues

---

## Rollback Criteria

Rollback is considered when:

- critical flow is broken
- user data integrity is at risk
- build artifact is invalid
- production configuration is incorrect

Rollback action must be documented with:

- reason
- affected version
- mitigation
- follow-up owner

---

## Acceptance Criteria

- [ ] Release scope is documented
- [ ] QA evidence is available
- [ ] Release notes are prepared
- [ ] `CHANGELOG.md` has the version entry before the tag is created
- [ ] Risks are accepted or mitigated
- [ ] Post-release follow-ups are tracked
