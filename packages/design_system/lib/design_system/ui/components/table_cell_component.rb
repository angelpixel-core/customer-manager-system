module DesignSystem
  module UI
    module Components
      class TableCellComponent < DesignSystem::UI::Component
        def initialize(header: false, align: :left)
          @header = header
          @align = align
        end

        def call
          helpers.content_tag(tag_name, content, class: css_classes)
        end

        private

        def tag_name
          @header ? :th : :td
        end

        def css_classes
          helpers.class_names(
            "ds-table__cell",
            {"ds-table__cell--header": @header},
            "ds-table__cell--align-#{normalize_align}"
          )
        end

        def normalize_align
          value = @align.to_sym
          return value if %i[left center right].include?(value)

          :left
        end
      end
    end
  end
end
