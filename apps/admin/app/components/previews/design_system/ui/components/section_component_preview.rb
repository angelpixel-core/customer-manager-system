module DesignSystem
  module UI
    module Components
      class SectionComponentPreview < ViewComponent::Preview
        def titled
          render DesignSystem::UI::Components::SectionComponent.new(title: "Filters") do
            ActionController::Base.helpers.content_tag(:p, "Filter controls go here.")
          end
        end

        def untitled
          render DesignSystem::UI::Components::SectionComponent.new do
            ActionController::Base.helpers.content_tag(:p, "Section without title for flexible composition.")
          end
        end
      end
    end
  end
end
