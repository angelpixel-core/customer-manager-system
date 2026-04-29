require "rails_helper"

RSpec.describe DesignSystem::UI::Primitives::LabelComponent, type: :component do
  it "renders text and for attribute" do
    result = render_inline(described_class.new(text: "Email", for_id: "customer_email"))

    label = result.css("label.ds-label").first
    expect(label.text).to eq("Email")
    expect(label["for"]).to eq("customer_email")
  end
end
