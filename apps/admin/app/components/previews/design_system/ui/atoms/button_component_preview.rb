module DesignSystem
  module UI
    module Atoms
      class ButtonComponentPreview < ViewComponent::Preview
        def primary
          render DesignSystem::UI::Atoms::ButtonComponent.new(
            label: "Create Customer",
            variant: :primary,
            size: :md,
            href: "/admin/customer_records/new"
          )
        end

        def secondary
          render DesignSystem::UI::Atoms::ButtonComponent.new(
            label: "Cancel",
            variant: :secondary,
            href: "/admin"
          )
        end

        def danger_disabled
          render DesignSystem::UI::Atoms::ButtonComponent.new(
            label: "Delete",
            variant: :danger,
            disabled: true
          )
        end
      end
    end
  end
end
