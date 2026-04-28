module DesignSystem
  module UI
    module Components
      class TableComponentPreview < ViewComponent::Preview
        def basic
          rows = [
            {id: 2, name: "Customer Bangel.fows@pm.me", email: "angel.fows@pm.me", created_at: "Apr 27, 2026"},
            {id: 1, name: "Customer Aangel.barreda@pm.me", email: "angel.barreda@pm.me", created_at: "Apr 27, 2026"}
          ]

          render DesignSystem::UI::Components::TableComponent.new(columns: columns, rows: rows) do |row, column|
            if column[:key] == :actions
              view_context.link_to("View", "/admin/customer_records/#{row[:id]}", class: "ds-button ds-button--link ds-button--sm")
            else
              row[column[:key]]
            end
          end
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
      end
    end
  end
end
