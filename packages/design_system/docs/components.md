# Component Catalog

Canonical namespaces:

- `DesignSystem::UI::Primitives::*`
- `DesignSystem::UI::Components::*`
- `DesignSystem::UI::Composites::*`

Legacy aliases under `Atoms` and `Organisms` remain temporarily for migration safety.

## Primitives

### ButtonComponent

- Path: `lib/design_system/ui/primitives/button_component.rb`
- Responsibility: action/CTA control as link or native button.
- API:
  - `label:` String (required)
  - `variant:` Symbol (default: `:primary`)
  - `type:` Symbol/String for native buttons (default: `:button`)
  - `href:` Optional URL (when present, renders link)
  - `classes:` Optional custom classes

### InputComponent

- Path: `lib/design_system/ui/primitives/input_component.rb`
- Responsibility: labeled text input primitive.
- API:
  - `name:` Symbol/String (required)
  - `label:` String (required)
  - `value:` Optional current value
  - `type:` Input type (default: `:text`)
  - `placeholder:` Optional placeholder text

### SelectComponent

- Path: `lib/design_system/ui/primitives/select_component.rb`
- Responsibility: select control with optional label.
- API:
  - `name:` Symbol/String (required)
  - `options:` Array of hashes (`{label:, value:}`)
  - `value:` Optional selected value
  - `label:` Optional label text
  - `include_blank:` Optional blank option label
  - `classes:` Optional custom classes

### LabelComponent

- Path: `lib/design_system/ui/primitives/label_component.rb`
- Responsibility: standalone semantic label.
- API:
  - `text:` String (required)
  - `for_id:` Optional target element id
  - `classes:` Optional custom classes

### LinkComponent

- Path: `lib/design_system/ui/primitives/link_component.rb`
- Responsibility: semantic link primitive with style variants.
- API:
  - `label:` String (required)
  - `href:` String (required)
  - `variant:` Symbol (default: `:default`)
  - `size:` Symbol (default: `:md`)
  - `classes:` Optional custom classes

## Components

### CardComponent

- Path: `lib/design_system/ui/components/card_component.rb`
- Responsibility: neutral section shell with title + content body.

### TableComponent

- Path: `lib/design_system/ui/components/table_component.rb`
- Responsibility: responsive data table with configurable columns and optional custom cells.
- API:
  - `columns:` Array of hashes with `key:` and `label:` (optional `align:`)
  - `rows:` Enumerable of records (hashes or objects)
  - `empty_state:` Optional empty-state text

### HeaderComponent

- Path: `lib/design_system/ui/components/header_component.rb`
- Responsibility: neutral header with title, navigation, and optional user info.
- API:
  - `title:` String (required)
  - `navigation:` Array of hashes (`{label:, href:}`)
  - `user_email:` Optional String

## Composites

### FilterGroupComponent

- Path: `lib/design_system/ui/composites/filter_group_component.rb`
- Responsibility: grouped filter UI block with label and slotted content.
- API:
  - `label:` String (required)
  - `classes:` Optional custom classes
