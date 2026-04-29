module DesignSystem
  module UI
    module Composites
      # Compact horizontal filter toolbar for admin index pages.
      class FilterBarComponent < DesignSystem::UI::Component
        def initialize(classes: nil)
          @classes = classes
        end

        def call
          helpers.content_tag(:section, class: css_classes) do
            helpers.content_tag(:div, content, class: "ds-filter-bar__content")
          end
        end

        private

        def css_classes
          helpers.class_names("ds-filter-bar", @classes)
        end
      end
    end
  end
end
