module DesignSystem
  module UI
    module Organisms
      class PanelComponentPreview < ViewComponent::Preview
        def basic
          render DesignSystem::UI::Organisms::PanelComponent.new(title: "Customer Summary") do
            "Use this panel as a reusable section shell for dashboard blocks and forms."
          end
        end
      end
    end
  end
end
