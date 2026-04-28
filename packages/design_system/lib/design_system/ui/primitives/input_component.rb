module DesignSystem
  module UI
    module Primitives
      # Primitive labeled input field component.
      class InputComponent < DesignSystem::UI::Component
        def initialize(name:, label:, value: nil, type: :text, placeholder: nil)
          @name = name
          @label = label
          @value = value
          @type = type
          @placeholder = placeholder
        end

        def call
          helpers.content_tag(:div, class: "ds-input") do
            helpers.concat helpers.label_tag(@name, @label, class: "ds-input__label")
            helpers.concat helpers.text_field_tag(
              @name,
              @value,
              type: @type,
              placeholder: @placeholder,
              class: "ds-input__control"
            )
          end
        end
      end
    end
  end
end
