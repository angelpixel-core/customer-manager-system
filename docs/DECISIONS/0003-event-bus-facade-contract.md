# 0003 - Event Bus Facade Contract

## Status

Accepted

## Context

`Publisher` is already the operative port used by application use cases.
`EventBus` was introduced as a facade name to reduce naming drift and keep a
stable integration point while the platform event layer is still evolving.

The open question was whether `EventBus` should be:

1. a lightweight alias over `Publisher`, or
2. a full orchestration facade (publish + retry + DLQ).

## Decision

Adopt **option 1** in core now: `EventBus` is a lightweight facade over
`Publisher`.

- `EventBus` exposes `publish(event)` and delegates to an injected publisher.
- `EventBus` does not implement retry orchestration, handler registry, or
  persistent dead-letter behavior in `customer_core`.
- Retry, registry, and persistent DLQ remain part of the target
  `platform/events` implementation.

## Rationale

- Keeps `customer_core` focused on application/domain contracts.
- Avoids coupling core to infrastructure policy decisions too early.
- Preserves a stable facade name (`EventBus`) for call sites.
- Enables incremental migration to platform-level orchestration later.

## Consequences

### Positive

- Clear boundary: core contract vs platform orchestration.
- No breaking changes to existing use cases and adapters.
- Easier testability in core (pure delegation contract).

### Tradeoffs

- Advanced event concerns remain temporarily outside the facade.
- Full orchestration still requires future `platform/events` rollout.

## Applied in Repository

- `CustomerCore::Application::Interfaces::Events::EventBus`
- `CustomerCore::Application::Interfaces::Events::Publisher`

## Follow-up

- When `platform/events` is implemented, evaluate promoting orchestration
  responsibilities to a platform `EventBus` facade and keep core interface
  compatibility.
