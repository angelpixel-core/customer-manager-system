# Design System Rules

## Naming

- Components end with `Component`.
- Namespace includes atomic level.
- Prefer semantic names over visual names.

Examples:

- `DesignSystem::UI::Atoms::ButtonComponent`
- `DesignSystem::UI::Molecules::FormFieldComponent`
- `DesignSystem::UI::Organisms::PanelComponent`

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
