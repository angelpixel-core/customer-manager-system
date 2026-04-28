module DesignSystem
  module UI
    module Composites
      class FilterGroupComponentPreview < ViewComponent::Preview
        def basic
          render DesignSystem::UI::Composites::FilterGroupComponent.new(label: "Email") do
            ActionController::Base.helpers.safe_join([
              ActionController::Base.helpers.select_tag(
                :operator,
                ActionController::Base.helpers.options_for_select([
                  ["Contains", "contains"],
                  ["Equals", "eq"]
                ], "contains"),
                class: "ds-select__control"
              ),
              ActionController::Base.helpers.text_field_tag(
                :email,
                nil,
                class: "ds-input__control",
                placeholder: "customer@example.com"
              )
            ])
          end
        end
      end
    end
  end
end
