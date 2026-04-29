module DesignSystem
  module UI
    module Components
      class TableRowComponent < DesignSystem::UI::Component
        def call
          helpers.content_tag(:tr, content, class: "ds-table__row")
        end
      end
    end
  end
end
