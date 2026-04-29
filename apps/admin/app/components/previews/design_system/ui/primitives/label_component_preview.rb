module DesignSystem
  module UI
    module Primitives
      class LabelComponentPreview < ViewComponent::Preview
        def basic
          render DesignSystem::UI::Primitives::LabelComponent.new(
            text: "Customer Email",
            for_id: "customer_email"
          )
        end
      end
    end
  end
end
