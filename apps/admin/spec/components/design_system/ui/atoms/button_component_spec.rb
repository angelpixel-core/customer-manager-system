require "rails_helper"

RSpec.describe DesignSystem::UI::Atoms::ButtonComponent, type: :component do
  it "renders primary button classes" do
    result = render_inline(described_class.new(label: "Create", variant: :primary))

    button = result.css("button.ds-button.ds-button--primary").first
    expect(button.text).to include("Create")
  end

  it "renders a link when href is provided" do
    result = render_inline(described_class.new(label: "View", href: "/admin", variant: :secondary))

    link = result.css("a.ds-button.ds-button--secondary").first
    expect(link["href"]).to eq("/admin")
  end

  it "renders native button type" do
    result = render_inline(described_class.new(label: "Delete", variant: :primary, type: :submit))

    button = result.css("button.ds-button").first
    expect(button["type"]).to eq("submit")
  end
end
