module DesignSystem
  module UI
    module Atoms
      # Atomic labeled input field component.
      class InputComponent < DesignSystem::UI::Component
        STATES = %i[default error disabled].freeze

        def initialize(
          name:,
          label:,
          value: nil,
          type: :text,
          placeholder: nil,
          state: :default,
          hint: nil,
          error_message: nil,
          required: false,
          id: nil,
          autocomplete: nil
        )
          @name = name
          @label = label
          @value = value
          @type = type
          @placeholder = placeholder
          @state = normalize_state(state)
          @hint = hint
          @error_message = error_message
          @required = required
          @id = id || @name
          @autocomplete = autocomplete
        end

        def call
          helpers.content_tag(:div, class: wrapper_classes) do
            helpers.concat helpers.label_tag(@id, @label, class: "ds-input__label")
            helpers.concat helpers.text_field_tag(
              @name,
              @value,
              id: @id,
              type: @type,
              placeholder: @placeholder,
              class: "ds-input__control",
              autocomplete: @autocomplete,
              required: @required,
              disabled: @state == :disabled,
              aria: aria_attributes
            )
            helpers.concat helpers.content_tag(:p, @hint, id: hint_id, class: "ds-input__hint") if @hint
            if @error_message
              helpers.concat helpers.content_tag(:p, @error_message, id: error_id, class: "ds-input__error", role: "alert")
            end
          end
        end

        private

        def normalize_state(state)
          value = state.to_sym
          return value if STATES.include?(value)

          :default
        end

        def wrapper_classes
          helpers.class_names(
            "ds-input",
            "ds-input--#{@state}"
          )
        end

        def hint_id
          "#{@id}-hint"
        end

        def error_id
          "#{@id}-error"
        end

        def aria_attributes
          attrs = {}
          attrs[:invalid] = true if @state == :error || @error_message

          describedby = [(@hint ? hint_id : nil), (@error_message ? error_id : nil)].compact.join(" ")
          attrs[:describedby] = describedby unless describedby.empty?
          attrs
        end
      end
    end
  end
end
