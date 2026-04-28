# Component Catalog (Initial)

## Atoms

### ButtonComponent

- Path: `lib/design_system/ui/atoms/button_component.rb`
- Responsibility: action/CTA link or button with variants.

### InputComponent

- Path: `lib/design_system/ui/atoms/input_component.rb`
- Responsibility: labeled input field with optional placeholder.

## Molecules

### FormFieldComponent

- Path: `lib/design_system/ui/molecules/form_field_component.rb`
- Responsibility: wraps a label + custom field block for forms.

## Organisms

### PanelComponent

- Path: `lib/design_system/ui/organisms/panel_component.rb`
- Responsibility: reusable section shell with title and body.

## Components

### TableComponent

- Path: `lib/design_system/ui/components/table_component.rb`
- Responsibility: renders responsive data tables with configurable columns and optional custom cells.
- API:
  - `columns:` Array of hashes with `key:` and `label:` (optional `align:`)
  - `rows:` Enumerable of records (hashes or objects)
  - `empty_state:` Optional text for empty datasets

Example:

```erb
<%= render DesignSystem::UI::Components::TableComponent.new(
  columns: [
    { key: :id, label: "Id", align: :right },
    { key: :name, label: "Name" },
    { key: :email, label: "Email" }
  ],
  rows: @customers
) do |row, column| %>
  <% if column[:key] == :actions %>
    <%= link_to "View", admin_customer_record_path(row), class: "ds-button ds-button--link ds-button--sm" %>
  <% else %>
    <%= row.public_send(column[:key]) %>
  <% end %>
<% end %>
```
