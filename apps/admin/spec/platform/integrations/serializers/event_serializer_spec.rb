require "rails_helper"

RSpec.describe Platform::Integrations::Serializers::EventSerializer do
  it "routes known event to specific serializer" do
    raw_event = CustomerCore::Events::Customer::Created.new(
      CustomerCore::Domain::Customer.new(name: "Angel", email: "test@mail.com")
    )
    platform_event = Platform::Events::Event.new(raw_event: raw_event)

    payload = described_class.new.serialize(platform_event)

    expect(payload[:event_name]).to eq("customer.created")
  end

  it "returns nil for unknown events" do
    raw_event = Struct.new(:foo).new("bar")
    platform_event = Platform::Events::Event.new(raw_event: raw_event)

    expect(described_class.new.serialize(platform_event)).to be_nil
  end
end
