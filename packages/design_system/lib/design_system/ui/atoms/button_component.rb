module DesignSystem
  module UI
    module Atoms
      # Atomic button component supporting links and native buttons.
      class ButtonComponent < DesignSystem::UI::Component
        def initialize(label:, variant: :primary, type: :button, href: nil, classes: nil)
          @label = label
          @variant = variant
          @type = type
          @href = href
          @classes = classes
        end

        def call
          if @href
            helpers.link_to(@label, @href, class: css_classes)
          else
            helpers.button_tag(@label, type: @type, class: css_classes)
          end
        end

        private

        def css_classes
          helpers.class_names(
            "ds-button",
            "ds-button--#{@variant}",
            @classes
          )
        end
      end
    end
  end
end
