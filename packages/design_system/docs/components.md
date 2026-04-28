# Component Catalog (Initial)

## Atoms

### ButtonComponent

- Path: `lib/design_system/ui/atoms/button_component.rb`
- Responsibility: action/CTA link or button with variants.
- API:
  - `label:` String (required)
  - `variant:` `:primary | :secondary | :ghost | :link | :danger` (default: `:primary`)
  - `size:` `:sm | :md | :lg` (default: `:md`)
  - `type:` button type for native button (default: `:button`)
  - `href:` optional URL (renders link when present)
  - `disabled:` Boolean (default: `false`)
  - `aria_label:` optional accessible label override

Example:

```erb
<%= render DesignSystem::UI::Atoms::ButtonComponent.new(
  label: "Create customer",
  variant: :primary,
  size: :md,
  type: :submit
) %>
```

### InputComponent

- Path: `lib/design_system/ui/atoms/input_component.rb`
- Responsibility: labeled input field with optional placeholder.
- API:
  - `name:` Symbol/String (required)
  - `label:` String (required)
  - `value:` optional value
  - `type:` input type (default: `:text`)
  - `placeholder:` optional placeholder
  - `state:` `:default | :error | :disabled` (default: `:default`)
  - `hint:` optional helper text
  - `error_message:` optional error text
  - `required:` Boolean (default: `false`)
  - `id:` optional custom id
  - `autocomplete:` optional autocomplete value

Example:

```erb
<%= render DesignSystem::UI::Atoms::InputComponent.new(
  name: :email,
  label: "Email",
  type: :email,
  state: :error,
  error_message: "Provide a valid email address"
) %>
```

## Molecules

### FormFieldComponent

- Path: `lib/design_system/ui/molecules/form_field_component.rb`
- Responsibility: wraps a label + custom field block for forms.

## Organisms

### PanelComponent

- Path: `lib/design_system/ui/organisms/panel_component.rb`
- Responsibility: reusable section shell with title and body.
