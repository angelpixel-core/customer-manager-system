# YARD Conventions by Layer

## Purpose

Define concise, consistent YARD documentation rules for this monorepo.

## Scope

- `packages/customer_core` (high rigor, public core APIs)
- `packages/design_system` (high rigor, public component APIs)
- `apps/admin` (medium rigor, internal architecture and entrypoints)

## Required tags for scoped public methods

- one-line description (what the method does)
- `@param` for each input argument
- `@return` with output type/shape

## Optional tags (use when relevant)

- `@raise` for expected boundary exceptions
- brief example for non-obvious APIs

## Layer-specific guidance

### customer_core

- Document namespace modules and all public `UseCases` / `Interfaces`.
- Keep behavior-oriented wording (business intent first).

### design_system

- Document public component classes and `#call` methods.
- Include expected arguments and rendering contract.

### apps/admin

- Prioritize controllers, ActiveAdmin resources, workers, and integration
  entrypoints.
- Keep docs architecture-focused; avoid over-documenting Rails boilerplate.

## PR Documentation Rule

If a PR changes a scoped public API, it MUST update YARD docs in the same PR.

Examples:

- new/changed public method signature
- changed return contract
- changed behavior of integration entrypoints

## Review Checklist (YARD)

1. Are `@param` and `@return` present for changed public methods?
2. Do docs reflect the actual current contract (types/shape/behavior)?
3. If behavior changed, was the description updated accordingly?
