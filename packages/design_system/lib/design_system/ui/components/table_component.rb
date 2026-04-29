module DesignSystem
  module UI
    module Components
      class TableComponent < DesignSystem::UI::Component
        def initialize(columns:, rows:, empty_state: "No records found")
          @columns = columns
          @rows = rows
          @empty_state = empty_state
        end

        def call
          return empty_state_markup if @rows.empty?

          helpers.content_tag(:div, class: "ds-table-wrapper") do
            helpers.content_tag(:table, class: "ds-table") do
              helpers.safe_join([thead_markup, tbody_markup])
            end
          end
        end

        private

        def empty_state_markup
          helpers.content_tag(:p, @empty_state, class: "ds-table__empty")
        end

        def thead_markup
          helpers.content_tag(:thead, class: "ds-table__head") do
            render DesignSystem::UI::Components::TableRowComponent.new do
              helpers.safe_join(
                @columns.map do |column|
                  render DesignSystem::UI::Components::TableCellComponent.new(header: true, align: column.fetch(:align, :left)) do
                    column.fetch(:label)
                  end
                end
              )
            end
          end
        end

        def tbody_markup
          helpers.content_tag(:tbody, class: "ds-table__body") do
            helpers.safe_join(@rows.map { |row| tbody_row_markup(row) })
          end
        end

        def tbody_row_markup(row)
          render DesignSystem::UI::Components::TableRowComponent.new do
            helpers.safe_join(
              @columns.map do |column|
                render DesignSystem::UI::Components::TableCellComponent.new(align: column.fetch(:align, :left)) do
                  resolve_cell(row, column)
                end
              end
            )
          end
        end

        def resolve_cell(row, column)
          return helpers.capture(row, column, &@__vc_render_in_block) if @__vc_render_in_block

          key = column.fetch(:key)
          if row.respond_to?(:[]) && row.respond_to?(:key?) && row.key?(key)
            return row[key]
          end

          row.public_send(key)
        end
      end
    end
  end
end
