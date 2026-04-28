module DesignSystem
  module UI
    module Atoms
      class InputComponentPreview < ViewComponent::Preview
        def text
          render DesignSystem::UI::Atoms::InputComponent.new(
            name: :name,
            label: "Customer name",
            placeholder: "Jane Doe"
          )
        end

        def email
          render DesignSystem::UI::Atoms::InputComponent.new(
            name: :email,
            label: "Email",
            type: :email,
            placeholder: "jane@example.com"
          )
        end

        def error
          render DesignSystem::UI::Atoms::InputComponent.new(
            name: :email,
            label: "Email",
            value: "invalid",
            state: :error,
            error_message: "Provide a valid email address"
          )
        end

        def disabled
          render DesignSystem::UI::Atoms::InputComponent.new(
            name: :name,
            label: "Customer name",
            value: "Read only",
            state: :disabled,
            hint: "This field is locked"
          )
        end
      end
    end
  end
end
