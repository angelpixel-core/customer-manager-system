require "rails_helper"

RSpec.describe DesignSystem::UI::Components::SectionComponent, type: :component do
  it "renders title and body content when title is present" do
    result = render_inline(described_class.new(title: "Filters")) do
      "Filter controls"
    end

    expect(result.css("section.ds-section").count).to eq(1)
    expect(result.css("h2.ds-section__title").text).to include("Filters")
    expect(result.css("div.ds-section__body").text).to include("Filter controls")
  end

  it "renders body content without title" do
    result = render_inline(described_class.new) do
      "Table results"
    end

    expect(result.css("h2.ds-section__title").count).to eq(0)
    expect(result.css("div.ds-section__body").text).to include("Table results")
  end
end
