require "rails_helper"

RSpec.describe Platform::Events::EventBus do
  let(:registry) { Platform::Events::Registry.new }

  it "dispatches registered handlers with a platform event envelope" do
    dispatched_event = nil
    raw_event = CustomerCore::Events::Customer::Created.new(
      CustomerCore::Domain::Customer.new(name: "Angel", email: "test@mail.com")
    )

    registry.register(raw_event.class) do |platform_event|
      dispatched_event = platform_event
    end

    described_class.new(registry: registry).publish(raw_event)

    expect(dispatched_event).to be_a(Platform::Events::Event)
    expect(dispatched_event.raw_event).to eq(raw_event)
    expect(dispatched_event.name).to eq("CustomerCore::Events::Customer::Created")
  end

  it "does nothing when event has no handlers" do
    raw_event = CustomerCore::Events::Customer::Created.new(
      CustomerCore::Domain::Customer.new(name: "Angel", email: "test@mail.com")
    )

    expect { described_class.new(registry: registry).publish(raw_event) }.not_to raise_error
  end
end
