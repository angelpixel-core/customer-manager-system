module DesignSystem
  module UI
    module Composites
      class FilterGroupComponentPreview < ViewComponent::Preview
        def basic
          render DesignSystem::UI::Composites::FilterGroupComponent.new(label: "Email") do
            helpers.safe_join([operator_select, email_input])
          end
        end

        private

        def operator_select
          helpers.select_tag(
            :operator,
            helpers.options_for_select([["Contains", "contains"], ["Equals", "eq"]], "contains"),
            class: "ds-select__control"
          )
        end

        def email_input
          helpers.text_field_tag(:email, nil, class: "ds-input__control", placeholder: "customer@example.com")
        end
      end
    end
  end
end
