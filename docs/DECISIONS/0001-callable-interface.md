# 0001 - Callable Interface for Action Objects

## Status

Accepted

## Context

The codebase uses command-like objects in the application layer (use cases).
Ruby allows object-level polymorphism with `#call`, which improves composability
and enables passing classes/instances as callable dependencies.

## Decision

Standardize `#call` for action objects and keep explicit method names elsewhere.

- Use `#call` in use cases and orchestration services.
- Provide optional class-level convenience API: `.call(...)`.
- Keep explicit semantic methods in repositories/events/workers/models.

## Consequences

### Positive

- Uniform invocation style for application actions.
- Easier dependency injection and metaprogramming patterns.
- Better readability in controllers/resources when invoking use cases.

### Tradeoffs

- Mixed interfaces across layers are intentional and must be documented.
- Team must avoid overusing `#call` for non-action objects.

## Applied in Repository

- `CustomerCore::Application::UseCases::Customer::Create`
- Call sites in `apps/admin` controller and ActiveAdmin resource.
