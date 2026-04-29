# Design System Rules

## Naming

- Components end with `Component`.
- Prefer canonical namespaces: `Primitives`, `Components`, `Composites`.
- Prefer semantic names over visual names.

Examples:

- `DesignSystem::UI::Primitives::ButtonComponent`
- `DesignSystem::UI::Components::TableComponent`
- `DesignSystem::UI::Composites::FilterGroupComponent`

## Atomic Boundaries

- Atoms: single primitive element (`button`, `input`, `badge`)
- Molecules: composition of atoms for one interaction unit
- Organisms: larger sections composed from molecules/atoms

## Style Rules

- Use token variables from `design_system/tokens.css`.
- Avoid hardcoded colors and spacing in component styles.
- Keep selectors flat and component-scoped.

## Delivery Rules

- No domain logic in components.
- Delivery layer composes components and passes plain data.

## Component Definition of Done

- A real usage exists in at least one screen.
- Accessibility baseline is verified (focus states, labels, ARIA where applicable).
- Variants and states are explicit in API and styles.
- A Lookbook preview exists for normal and edge states.
- Component-level specs exist and pass in CI.
- Public API and usage examples are documented in `docs/components.md`.

## Promotion Rule

- If a UI pattern is needed in 2+ places, it is a candidate for Design System extraction.

## Alias Lifecycle

### Introduced

- Legacy aliases under `Atoms` and `Organisms` exist to preserve compatibility during migration to canonical namespaces.

### Migration target

- All new usages must reference canonical namespaces:
  - `DesignSystem::UI::Primitives::*`
  - `DesignSystem::UI::Components::*`
  - `DesignSystem::UI::Composites::*`
- New code should not introduce additional dependencies on `DesignSystem::UI::Atoms::*`.

### Removal trigger

- Remove alias files only when:
  1. Legacy usage inventory is zero.
  2. Component and system tests pass.
  3. CI remains green after alias deletion.

## Legacy Migration Tracker

| Legacy namespace | Current usage count | Owner | Removal milestone |
|---|---|---|---|
| `DesignSystem::UI::Atoms::*` | TBD | UI/Frontend | After full namespace migration |
| `DesignSystem::UI::Organisms::*` | TBD | UI/Frontend | After card/panel callsite migration |
