module DesignSystem
  module UI
    module Composites
      # Composite filter group with label and arbitrary filter controls.
      class FilterGroupComponent < DesignSystem::UI::Component
        def initialize(label:, classes: nil)
          @label = label
          @classes = classes
        end

        def call
          helpers.content_tag(:section, class: css_classes) do
            helpers.concat helpers.content_tag(:div, @label, class: "ds-filter-group__label")
            helpers.concat helpers.content_tag(:div, content, class: "ds-filter-group__content")
          end
        end

        private

        def css_classes
          helpers.class_names("ds-filter-group", @classes)
        end
      end
    end
  end
end
