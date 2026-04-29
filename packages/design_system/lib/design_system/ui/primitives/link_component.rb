module DesignSystem
  module UI
    module Primitives
      # Primitive link component with DS variants.
      class LinkComponent < DesignSystem::UI::Component
        def initialize(label:, href:, variant: :default, size: :md, classes: nil)
          @label = label
          @href = href
          @variant = variant
          @size = size
          @classes = classes
        end

        def call
          helpers.link_to(@label, @href, class: css_classes)
        end

        private

        def css_classes
          helpers.class_names(
            "ds-link",
            "ds-link--#{@variant}",
            "ds-link--#{@size}",
            @classes
          )
        end
      end
    end
  end
end
