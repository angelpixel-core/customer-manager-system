module DesignSystem
  module UI
    module Primitives
      class SelectComponentPreview < ViewComponent::Preview
        def basic
          render DesignSystem::UI::Primitives::SelectComponent.new(
            name: :operator,
            label: "Operator",
            include_blank: "Choose",
            options: [
              {label: "Contains", value: "contains"},
              {label: "Equals", value: "eq"}
            ],
            value: "contains"
          )
        end
      end
    end
  end
end
