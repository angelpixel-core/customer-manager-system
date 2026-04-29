# Design System Package

Shared Atomic Design system for the Customers Manager monorepo.

## Scope

- Design tokens
- UI components by layer (primitives/components/composites)
- Naming and usage rules
- Internal docs for consistent UI implementation

## Namespacing

- Ruby namespace: `DesignSystem::UI`
- Canonical folders:
  - `DesignSystem::UI::Primitives`
  - `DesignSystem::UI::Components`
  - `DesignSystem::UI::Composites`

## Asset Entry

- Propshaft stylesheet: `design_system/application.css`

Usage in Rails layout:

```erb
<%= stylesheet_link_tag "design_system/application", "data-turbo-track": "reload" %>
```

## Component Usage

Example button component:

```erb
<%= render DesignSystem::UI::Primitives::ButtonComponent.new(label: "Create", href: "/admin/customers/new") %>
```

## Documentation

- `docs/rules.md`
- `docs/components.md`
