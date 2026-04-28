require "rails_helper"

RSpec.describe DesignSystem::UI::Components::TableComponent, type: :component do
  let(:columns) do
    [
      {key: :id, label: "Id", align: :right},
      {key: :name, label: "Name"},
      {key: :actions, label: "Actions", align: :right}
    ]
  end

  it "renders headers and rows" do
    rows = [{id: 1, name: "Customer One", actions: "View"}]

    result = render_inline(described_class.new(columns: columns, rows: rows))

    expect(result.text).to include("Id")
    expect(result.text).to include("Customer One")
  end

  it "renders empty state when no rows are present" do
    result = render_inline(described_class.new(columns: columns, rows: [], empty_state: "No customers yet"))

    expect(result.css("p.ds-table__empty").text).to eq("No customers yet")
  end

  it "renders custom cells via block" do
    rows = [{id: 1, name: "Customer One", actions: nil}]

    result = render_inline(described_class.new(columns: columns, rows: rows)) do |row, column|
      if column[:key] == :actions
        "Inspect ##{row[:id]}"
      else
        row[column[:key]]
      end
    end

    expect(result.text).to include("Inspect #1")
  end
end
