module DesignSystem
  module UI
    module Atoms
      class ButtonComponentPreview < ViewComponent::Preview
        def primary
          render DesignSystem::UI::Atoms::ButtonComponent.new(
            label: "Create Customer",
            variant: :primary,
            href: "/admin/customers/new"
          )
        end

        def default
          render DesignSystem::UI::Atoms::ButtonComponent.new(
            label: "Cancel",
            variant: :default,
            href: "/admin"
          )
        end
      end
    end
  end
end
