module DesignSystem
  module UI
    module Composites
      class FilterBarComponentPreview < ViewComponent::Preview
        def basic
          render DesignSystem::UI::Composites::FilterBarComponent.new do
            helpers.safe_join(filter_controls)
          end
        end

        private

        def filter_controls
          [email_input, operator_select, name_input, apply_button, clear_link]
        end

        def email_input
          helpers.render(DesignSystem::UI::Primitives::InputComponent.new(name: :email_query, label: "Email", placeholder: "customer@example.com"))
        end

        def operator_select
          helpers.render(
            DesignSystem::UI::Primitives::SelectComponent.new(
              name: :email_operator,
              label: "Operator",
              options: [{label: "Contains", value: "contains"}, {label: "Equals", value: "eq"}],
              value: "contains"
            )
          )
        end

        def name_input
          helpers.render(DesignSystem::UI::Primitives::InputComponent.new(name: :name_query, label: "Name", placeholder: "Customer name"))
        end

        def apply_button
          helpers.render(DesignSystem::UI::Primitives::ButtonComponent.new(label: "Apply", type: :submit, variant: :primary, classes: "ds-button--sm"))
        end

        def clear_link
          helpers.render(DesignSystem::UI::Primitives::LinkComponent.new(label: "Clear", href: "/admin/customers", variant: :subtle, size: :sm))
        end
      end
    end
  end
end
