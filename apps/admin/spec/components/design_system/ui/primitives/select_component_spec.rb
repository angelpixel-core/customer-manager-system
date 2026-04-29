require "rails_helper"

RSpec.describe DesignSystem::UI::Primitives::SelectComponent, type: :component do
  it "renders label and options" do
    result = render_inline(
      described_class.new(
        name: :operator,
        label: "Operator",
        options: [
          {label: "Contains", value: "contains"},
          {label: "Equals", value: "eq"}
        ],
        value: "contains"
      )
    )

    expect(result.text).to include("Operator")
    expect(result.css("select.ds-select__control option").count).to eq(2)
  end
end
