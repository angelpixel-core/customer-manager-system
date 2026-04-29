require "rails_helper"

RSpec.describe DesignSystem::UI::Components::PageComponent, type: :component do
  it "renders page container and slotted content" do
    result = render_inline(described_class.new) do
      "Customers content"
    end

    expect(result.css("section.ds-page").count).to eq(1)
    expect(result.css("div.ds-page__container").count).to eq(1)
    expect(result.text).to include("Customers content")
  end
end
