require "rails_helper"

RSpec.describe DesignSystem::UI::Primitives::LinkComponent, type: :component do
  it "renders label and href" do
    result = render_inline(described_class.new(label: "Open", href: "/admin/customers"))

    link = result.css("a.ds-link").first
    expect(link.text).to eq("Open")
    expect(link["href"]).to eq("/admin/customers")
  end

  it "applies variant and size classes" do
    result = render_inline(described_class.new(label: "Back", href: "/admin", variant: :subtle, size: :sm))

    expect(result.css("a.ds-link.ds-link--subtle.ds-link--sm").count).to eq(1)
  end
end
