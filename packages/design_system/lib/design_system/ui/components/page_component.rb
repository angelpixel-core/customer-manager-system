module DesignSystem
  module UI
    module Components
      # Page-level layout wrapper with consistent spacing and width.
      class PageComponent < DesignSystem::UI::Component
        def call
          helpers.content_tag(:section, class: "ds-page") do
            helpers.content_tag(:div, content, class: "ds-page__container")
          end
        end
      end
    end
  end
end
