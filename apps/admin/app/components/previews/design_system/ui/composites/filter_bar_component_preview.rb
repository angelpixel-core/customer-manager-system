module DesignSystem
  module UI
    module Composites
      class FilterBarComponentPreview < ViewComponent::Preview
        def basic
          render DesignSystem::UI::Composites::FilterBarComponent.new do
            ActionController::Base.helpers.safe_join([
              ActionController::Base.helpers.render(
                DesignSystem::UI::Primitives::InputComponent.new(
                  name: :email_query,
                  label: "Email",
                  placeholder: "customer@example.com"
                )
              ),
              ActionController::Base.helpers.render(
                DesignSystem::UI::Primitives::SelectComponent.new(
                  name: :email_operator,
                  label: "Operator",
                  options: [
                    {label: "Contains", value: "contains"},
                    {label: "Equals", value: "eq"}
                  ],
                  value: "contains"
                )
              ),
              ActionController::Base.helpers.render(
                DesignSystem::UI::Primitives::InputComponent.new(
                  name: :name_query,
                  label: "Name",
                  placeholder: "Customer name"
                )
              ),
              ActionController::Base.helpers.render(
                DesignSystem::UI::Primitives::ButtonComponent.new(
                  label: "Apply",
                  type: :submit,
                  variant: :primary,
                  classes: "ds-button--sm"
                )
              ),
              ActionController::Base.helpers.render(
                DesignSystem::UI::Primitives::LinkComponent.new(
                  label: "Clear",
                  href: "/admin/customers",
                  variant: :subtle,
                  size: :sm
                )
              )
            ])
          end
        end
      end
    end
  end
end
