require "rails_helper"

RSpec.describe DesignSystem::UI::Composites::FilterGroupComponent, type: :component do
  it "renders label and slotted content" do
    result = render_inline(described_class.new(label: "Email")) do
      "Filter controls"
    end

    expect(result.text).to include("Email")
    expect(result.text).to include("Filter controls")
  end
end
