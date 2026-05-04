require "rails_helper"

RSpec.describe Platform::Integrations::Serializers::CustomerCreated do
  it "serializes customer created domain event for integration payload" do
    raw_event = CustomerCore::Events::Customer::Created.new(
      CustomerCore::Domain::Customer.new(name: "Angel", email: "test@mail.com")
    )
    platform_event = Platform::Events::Event.new(raw_event: raw_event, context: {origin: "spec"})

    payload = described_class.new.serialize(platform_event)

    expect(payload[:event_name]).to eq("customer.created")
    expect(payload[:source]).to eq("customers_manager_system")
    expect(payload[:customer]).to eq({name: "Angel", email: "test@mail.com"})
    expect(payload[:context]).to eq({origin: "spec"})
  end
end
