RSpec.describe CustomerCore::Application::UseCases::Customer::Create do
  let(:repo) { double }
  let(:event_bus) { double }

  it "creates customer and publishes event" do
    expect(repo).to receive(:create)
    expect(event_bus).to receive(:publish)

    use_case = described_class.new(repo: repo, event_bus: event_bus)

    use_case.call(name: "Angel", email: "test@mail.com")
  end
end
