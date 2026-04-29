require "rails_helper"

RSpec.describe DesignSystem::UI::Components::PageHeaderComponent, type: :component do
  it "renders title" do
    result = render_inline(described_class.new(title: "Customers"))

    expect(result.css("header.ds-page-header").count).to eq(1)
    expect(result.css("h1.ds-page-header__title").text).to include("Customers")
  end

  it "renders actions slot content" do
    result = render_inline(described_class.new(title: "Customers")) do
      "New customer"
    end

    expect(result.css(".ds-page-header__actions").count).to eq(1)
    expect(result.text).to include("New customer")
  end
end
