module DesignSystem
  module UI
    module Components
      # Logical section wrapper with optional title and body.
      class SectionComponent < DesignSystem::UI::Component
        def initialize(title: nil)
          @title = title
        end

        def call
          helpers.content_tag(:section, class: "ds-section") do
            helpers.concat helpers.content_tag(:h2, @title, class: "ds-section__title") if @title
            helpers.concat helpers.content_tag(:div, content, class: "ds-section__body")
          end
        end
      end
    end
  end
end
