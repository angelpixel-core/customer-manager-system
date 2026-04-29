module DesignSystem
  module UI
    module Components
      # Neutral header component with title, navigation and optional user info.
      class HeaderComponent < DesignSystem::UI::Component
        def initialize(title:, navigation: [], user_email: nil)
          @title = title
          @navigation = navigation
          @user_email = user_email
        end

        def call
          helpers.content_tag(:header, class: "ds-header") do
            helpers.concat helpers.content_tag(:div, @title, class: "ds-header__title")
            helpers.concat navigation_markup if @navigation.any?
            helpers.concat helpers.content_tag(:div, @user_email, class: "ds-header__user") if @user_email
          end
        end

        private

        def navigation_markup
          helpers.content_tag(:nav, class: "ds-header__nav", "aria-label": "Primary") do
            helpers.content_tag(:ul, class: "ds-header__list") do
              helpers.safe_join(@navigation.map { |item| navigation_item(item) })
            end
          end
        end

        def navigation_item(item)
          html_options = item.fetch(:html_options, {})

          helpers.content_tag(:li, class: "ds-header__item") do
            helpers.link_to(item.fetch(:label), item.fetch(:href), {class: "ds-link ds-link--default"}.merge(html_options))
          end
        end
      end
    end
  end
end
