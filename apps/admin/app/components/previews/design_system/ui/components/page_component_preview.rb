module DesignSystem
  module UI
    module Components
      class PageComponentPreview < ViewComponent::Preview
        def basic
          render DesignSystem::UI::Components::PageComponent.new do
            helpers.safe_join([content_label, content_copy])
          end
        end

        private

        def content_label
          helpers.content_tag(:p, "Page content area", class: "ds-label")
        end

        def content_copy
          helpers.content_tag(:p, "Use this wrapper for max-width and spacing.")
        end
      end
    end
  end
end
