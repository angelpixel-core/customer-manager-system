# 0004 - Result Convention for Application Ports

## Status

Accepted

## Context

The codebase evolved with mixed error handling styles:

- exceptions for expected adapter failures,
- partial rescue/log patterns in use cases,
- non-uniform return values across ports/adapters.

This made failure flows harder to reason about and harder to compose across
layers (core use cases, admin adapters, platform events, integrations).

## Decision

Adopt a global convention in application boundaries:

- use `CustomerCore::Application::Result` as the standard return type for
  application use cases and port/interface operations,
- represent successful outcomes with `Result.success(value, metadata:)`,
- represent expected failures with
  `Result.failure(code:, message:, cause:, metadata:)`.

### Scope

This convention applies to:

- use cases in `CustomerCore::Application::UseCases::*`,
- application ports/interfaces in
  `CustomerCore::Application::Interfaces::*`,
- adapters implementing those ports in `apps/admin`.

Domain entities/value objects remain exception/invariant oriented and are not
forced to return `Result`.

## Rationale

- Makes success/failure explicit at architecture boundaries.
- Avoids exceptions as normal control flow between layers.
- Simplifies retry/DLQ/integration orchestration because failures are typed.
- Improves test readability and deterministic assertions.

## Consequences

### Positive

- Uniform contract across core and adapters.
- Better composability in event pipelines and integration forwarders.
- Easier to expose predictable error behavior to delivery layers.

### Tradeoffs

- Additional boilerplate (`success?`, `failure?`, failure mapping).
- Existing call sites must check `result.success?` explicitly.

## Applied in Repository

- `packages/customer_core/lib/customer_core/application/result.rb`
- `packages/customer_core/lib/customer_core/application/interfaces/**/*`
- `packages/customer_core/lib/customer_core/application/use_cases/customer/create.rb`
- `apps/admin/app/controllers/customers_controller.rb`
- `apps/admin/app/admin/customers.rb`
- `apps/admin/app/admin/infrastructure/**/*`
- `apps/admin/lib/platform/events/event_bus.rb`
- `apps/admin/lib/platform/integrations/n8n/event_forwarder.rb`

## Follow-up

- Keep adding explicit failure codes per use case and adapter.
- Document a small shared code list (`:invalid_input`, `:publish_failed`,
  `:repository_create_failed`, etc.) as conventions stabilize.
