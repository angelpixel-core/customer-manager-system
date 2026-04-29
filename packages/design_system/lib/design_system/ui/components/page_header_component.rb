module DesignSystem
  module UI
    module Components
      # Page header with title and optional actions slot.
      class PageHeaderComponent < DesignSystem::UI::Component
        def initialize(title:)
          @title = title
        end

        def call
          helpers.content_tag(:header, class: "ds-page-header") do
            helpers.concat helpers.content_tag(:h1, @title, class: "ds-page-header__title")
            helpers.concat actions_markup if content.present?
          end
        end

        private

        def actions_markup
          helpers.content_tag(:div, content, class: "ds-page-header__actions")
        end
      end
    end
  end
end
