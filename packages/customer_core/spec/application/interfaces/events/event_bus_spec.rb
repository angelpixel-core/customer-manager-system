RSpec.describe CustomerCore::Application::Interfaces::Events::EventBus do
  let(:publisher) { double }

  it "delegates publish to publisher adapter" do
    event = CustomerCore::Events::Customer::Created.new(
      CustomerCore::Domain::Customer.new(name: "Angel", email: "test@mail.com")
    )

    expect(publisher).to receive(:publish).with(event).and_return(CustomerCore::Application::Result.success)

    result = described_class.new(publisher: publisher).publish(event)

    expect(result).to be_success
  end
end
