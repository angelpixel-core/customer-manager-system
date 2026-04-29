require "rails_helper"

RSpec.describe DesignSystem::UI::Primitives::InputComponent, type: :component do
  it "renders label and input association" do
    result = render_inline(described_class.new(name: :email, label: "Email"))

    label = result.css("label.ds-input__label").first
    input = result.css("input.ds-input__control").first
    expect(label["for"]).to eq("email")
    expect(input["id"]).to eq("email")
  end

  it "renders placeholder and type" do
    result = render_inline(described_class.new(name: :email, label: "Email", type: :email, placeholder: "jane@example.com"))

    input = result.css("input.ds-input__control").first
    expect(input["type"]).to eq("email")
    expect(input["placeholder"]).to eq("jane@example.com")
  end

  it "wraps control in ds-input container" do
    result = render_inline(described_class.new(name: :name, label: "Name"))

    expect(result.css("div.ds-input").count).to eq(1)
  end
end
