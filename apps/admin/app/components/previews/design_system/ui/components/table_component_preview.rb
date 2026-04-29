module DesignSystem
  module UI
    module Components
      class TableComponentPreview < ViewComponent::Preview
        def basic
          render DesignSystem::UI::Components::TableComponent.new(columns: columns, rows: sample_rows, &method(:cell_content))
        end

        def empty_state
          render DesignSystem::UI::Components::TableComponent.new(columns: columns, rows: [], empty_state: "No customers yet")
        end

        private

        def columns
          [
            {key: :id, label: "Id", align: :right},
            {key: :name, label: "Name"},
            {key: :email, label: "Email"},
            {key: :created_at, label: "Created At"},
            {key: :actions, label: "Actions", align: :right}
          ]
        end

        def sample_rows
          [
            {id: 2, name: "Customer B", email: "customer.b@example.test", created_at: "Apr 27, 2026"},
            {id: 1, name: "Customer A", email: "customer.a@example.test", created_at: "Apr 27, 2026"}
          ]
        end

        def cell_content(row, column)
          key = column[:key]
          return view_action_link(row) if key == :actions

          row[key]
        end

        def view_action_link(row)
          helpers.link_to("View", "/admin/customers/#{row[:id]}", class: "ds-button ds-button--link ds-button--sm")
        end
      end
    end
  end
end
