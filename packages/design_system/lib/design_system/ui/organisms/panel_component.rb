module DesignSystem
  module UI
    module Organisms
      # Organism-level section panel with title and body.
      class PanelComponent < DesignSystem::UI::Component
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
