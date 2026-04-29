module DesignSystem
  module UI
    module Components
      # Component-level section card with title and body.
      class CardComponent < DesignSystem::UI::Component
        def initialize(title:)
          @title = title
        end

        def call
          helpers.content_tag(:section, class: "ds-panel") do
            helpers.concat helpers.content_tag(:h2, @title, class: "ds-panel__title")
            helpers.concat helpers.content_tag(:div, content, class: "ds-panel__body")
          end
        end
      end
    end
  end
end
