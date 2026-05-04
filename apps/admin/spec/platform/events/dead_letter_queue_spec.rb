require "rails_helper"

RSpec.describe Platform::Events::DeadLetterQueue do
  it "persists dead letter records" do
    raw_event = CustomerCore::Events::Customer::Created.new(
      CustomerCore::Domain::Customer.new(name: "Angel", email: "test@mail.com")
    )
    error = StandardError.new("publish boom")

    expect {
      described_class.new.push(event: raw_event, error: error, metadata: {source: "spec"})
    }.to change(Platform::Events::DeadLetterRecord, :count).by(1)

    record = Platform::Events::DeadLetterRecord.order(:id).last
    expect(record.event_name).to eq("CustomerCore::Events::Customer::Created")
    expect(record.error_class).to eq("StandardError")
    expect(record.metadata).to include("source" => "spec")
  end
end
