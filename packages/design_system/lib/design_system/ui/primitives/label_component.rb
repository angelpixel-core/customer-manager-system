module DesignSystem
  module UI
    module Primitives
      # Primitive standalone label component.
      class LabelComponent < DesignSystem::UI::Component
        def initialize(text:, for_id: nil, classes: nil)
          @text = text
          @for_id = for_id
          @classes = classes
        end

        def call
          helpers.label_tag(@for_id, @text, class: css_classes)
        end

        private

        def css_classes
          helpers.class_names("ds-label", @classes)
        end
      end
    end
  end
end
