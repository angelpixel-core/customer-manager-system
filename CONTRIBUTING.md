# Contributing

Thanks for contributing to Customers Manager System.

## Branching

- Base branch for integration PRs: `development`.
- Preferred branch prefixes: `feat/`, `fix/`, `chore/`, `docs/`, `refactor/`, `test/`.

## Development setup

```bash
cd apps/admin
bin/setup --skip-server
```

## Quality checks

Primary gate command:

```bash
cd apps/admin
bin/gates
```

Additional CI-aligned checks:

```bash
cd apps/admin
bin/ci
```

## Architecture expectations

- Keep domain and application core in `packages/customer_core`.
- Keep adapters/infrastructure in `apps/admin`.
- Use ports/interfaces for cross-layer boundaries.
- Use `CustomerCore::Application::Result` on application boundary returns.

## Documentation expectations

- If public API changes, update YARD docs in same PR.
- Follow `docs/YARD_CONVENTIONS.md`.
- Update architecture/decision docs when boundaries or patterns change.

## Pull Requests

- Use `.github/pull_request_template.md`.
- Keep PRs focused and atomic.
- Include migration notes and rollback plan when applicable.
