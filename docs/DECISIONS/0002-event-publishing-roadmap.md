# 0002 - Event Publishing Roadmap and Event Bus Facade

## Status

Accepted

## Context

The current implementation already publishes domain events from application use
cases through `Publisher` and uses admin adapters (`FaktoryEventBus`,
`RailsDeadLetterStore`, `RailsLogger`).

Architecture docs also list target components that are not fully implemented
yet (`platform/events`, registry, retry handler, serializers, persistent DLQ).
We need a staged plan and a stable `event_bus` facade concept.

## Decision

Adopt a staged implementation plan and implement `EventBus` as a facade over
`Publisher`.

### Plan

1. **Docs alignment**: keep current-state and target-state explicit in architecture docs.
2. **Facade**: add `CustomerCore::Application::Interfaces::Events::EventBus` delegating to `Publisher`.
3. **Notifier port**: introduce a dedicated integration notification port.
4. **Platform events core**: add `platform/events` base objects + registry.
5. **Resilience**: add retry handler and persistent dead-letter queue.
6. **Integrations**: add serializers + n8n forwarder wiring.

## Consequences

### Positive

- Keeps current flows stable while evolving toward the target architecture.
- Provides a stable façade name (`event_bus`) without breaking `Publisher` usage.
- Makes pending platform work explicit and incremental.

### Tradeoffs

- Temporary overlap (`Publisher` and `EventBus`) until full migration patterns are settled.
- Additional abstractions require clear docs and tests to avoid confusion.

## Applied in Repository

- `CustomerCore::Application::Interfaces::Events::EventBus` (facade)
- Architecture TODOs tracked in `docs/ARCHITECTURE.md`
