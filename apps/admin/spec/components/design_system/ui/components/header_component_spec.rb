require "rails_helper"

RSpec.describe DesignSystem::UI::Components::HeaderComponent, type: :component do
  it "renders title and navigation links" do
    result = render_inline(
      described_class.new(
        title: "Customers Manager",
        navigation: [
          {label: "Dashboard", href: "/admin"},
          {label: "Customers", href: "/admin/customers"}
        ]
      )
    )

    expect(result.text).to include("Customers Manager")
    expect(result.css("a.ds-link").count).to eq(2)
  end

  it "renders user email when provided" do
    result = render_inline(described_class.new(title: "Admin", user_email: "admin@example.com"))

    expect(result.text).to include("admin@example.com")
  end
end
