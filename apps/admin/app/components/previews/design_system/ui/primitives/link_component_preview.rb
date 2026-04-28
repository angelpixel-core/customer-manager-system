module DesignSystem
  module UI
    module Primitives
      class LinkComponentPreview < ViewComponent::Preview
        def default
          render DesignSystem::UI::Primitives::LinkComponent.new(
            label: "Open customer",
            href: "/admin/customer_records",
            variant: :default,
            size: :md
          )
        end

        def subtle
          render DesignSystem::UI::Primitives::LinkComponent.new(
            label: "Back to list",
            href: "/admin/customer_records",
            variant: :subtle,
            size: :sm
          )
        end
      end
    end
  end
end
