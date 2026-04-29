require "rails_helper"

RSpec.describe DesignSystem::UI::Composites::FilterBarComponent, type: :component do
  it "renders horizontal toolbar wrapper and slotted content" do
    result = render_inline(described_class.new) do
      "Filter controls"
    end

    expect(result.css("section.ds-filter-bar").count).to eq(1)
    expect(result.css("div.ds-filter-bar__content").count).to eq(1)
    expect(result.text).to include("Filter controls")
  end
end
