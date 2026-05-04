## Summary

- What changed?
- Why now?

## Type of Change

- [ ] feat
- [ ] fix
- [ ] refactor
- [ ] test
- [ ] docs
- [ ] chore

## Architecture Impact

- [ ] `packages/customer_core` (domain/application/use cases)
- [ ] `apps/admin` adapters/controllers/workers
- [ ] platform events/integrations
- [ ] no architecture impact

If architecture changed, explain boundary decisions:

## Result Convention

- [ ] Public application boundaries return `CustomerCore::Application::Result`
- [ ] Failure codes/messages are explicit for changed paths
- [ ] No new exception-driven control flow introduced between use case and adapters

## Quality Gates

- [ ] `bin/gates` (or relevant stage targets) passes locally
- [ ] Reek changed-file check passes
- [ ] If docs/public API changed, YARD docs updated

Commands executed:

```bash
# Example
cd apps/admin
bin/gates
```

## Data / Migrations

- [ ] no migration
- [ ] migration included and backward-compatible

Migration notes:

## Risk and Rollback

- Main risks:
- Rollback plan:

## Screenshots / Logs (if applicable)

## Checklist

- [ ] Scope is minimal and focused
- [ ] Tests added/updated for changed behavior
- [ ] Docs updated (`ARCHITECTURE`, ADR, RUNBOOK) when relevant
