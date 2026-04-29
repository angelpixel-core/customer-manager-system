module DesignSystem
  module UI
    module Atoms
      class InputComponentPreview < ViewComponent::Preview
        def text
          render DesignSystem::UI::Primitives::InputComponent.new(
            name: :name,
            label: "Customer name",
            placeholder: "Jane Doe"
          )
        end

        def email
          render DesignSystem::UI::Primitives::InputComponent.new(
            name: :email,
            label: "Email",
            type: :email,
            placeholder: "jane@example.com"
          )
        end
      end
    end
  end
end
