# Design System Package

Shared Atomic Design system for the Customers Manager monorepo.

## Scope

- Design tokens
- Atomic components (atoms/molecules/organisms)
- Naming and usage rules
- Internal docs for consistent UI implementation

## Namespacing

- Ruby namespace: `DesignSystem::UI`
- Atomic folders:
  - `DesignSystem::UI::Atoms`
  - `DesignSystem::UI::Molecules`
  - `DesignSystem::UI::Organisms`

## Asset Entry

- Propshaft stylesheet: `design_system/application.css`

Usage in Rails layout:

```erb
<%= stylesheet_link_tag "design_system/application", "data-turbo-track": "reload" %>
```

## Component Usage

Example button component:

```erb
<%= render DesignSystem::UI::Atoms::ButtonComponent.new(label: "Create", href: "/admin/customer_records/new") %>
```

## Documentation

- `docs/rules.md`
- `docs/components.md`
