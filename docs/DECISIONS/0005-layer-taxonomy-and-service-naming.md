# 0005 - Layer Taxonomy and Service Naming

## Status

Accepted

## Context

The term `Service` is overloaded in Ruby/Rails ecosystems:

- service object as synonym for use case,
- orchestration object in delivery layer,
- infrastructure service wrapper.

This created ambiguity in architecture discussions and naming decisions.

## Decision

Adopt explicit taxonomy and naming rules.

### Canonical terms

- `UseCase`: application action object in core (`CustomerCore::Application::UseCases::*`).
- `Port/Interface`: abstract contract in core (`CustomerCore::Application::Interfaces::*`).
- `Adapter`: concrete implementation of a port in delivery/infrastructure layers.
- `Domain Service`: pure domain collaboration object (if needed) inside domain layer.
- `Orchestration Service`: optional delivery-layer coordinator, not a synonym for use case.

### Naming rules

- New application actions in core MUST be named as use cases, not `*Service`.
- `*Service` is reserved for:
  - domain services in domain layer, or
  - explicit orchestration services in delivery layer.
- Do not use `Service` as a generic alias for use case in docs or code.

## Consequences

### Positive

- Clear mental model across team and layers.
- Less naming drift between docs and implementation.
- Easier onboarding and review consistency.

### Tradeoffs

- Requires discipline when introducing new action objects.
- Some target-architecture sections may reference optional services that are not implemented yet.

## Applied in Repository

- Current runtime action object: `CustomerCore::Application::UseCases::Customer::Create`.
- `services/` directories in architecture docs are considered target/pending unless explicitly marked implemented.

## Follow-up

- Keep architecture docs split into `Implemented today` and `Target / pending` views.
- Enforce naming in PR review checklist.
