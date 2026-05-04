module DesignSystem
  module UI
    module Molecules
      # Molecule wrapper for a labeled form field slot.
      class FormFieldComponent < DesignSystem::UI::Component
        renders_one :field

        def initialize(label:)
          @label = label
        end

        def call
          helpers.content_tag(:div, class: "ds-form-field") do
            helpers.concat helpers.content_tag(:p, @label, class: "ds-form-field__label")
            helpers.concat field
          end
        end
      end
    end
  end
end
