module DesignSystem
  module UI
    module Components
      class PageComponentPreview < ViewComponent::Preview
        def basic
          render DesignSystem::UI::Components::PageComponent.new do
            ActionController::Base.helpers.safe_join([
              ActionController::Base.helpers.content_tag(:p, "Page content area", class: "ds-label"),
              ActionController::Base.helpers.content_tag(:p, "Use this wrapper for max-width and spacing.")
            ])
          end
        end
      end
    end
  end
end
