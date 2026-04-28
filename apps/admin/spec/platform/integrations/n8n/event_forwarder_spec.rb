require "rails_helper"

RSpec.describe Platform::Integrations::N8n::EventForwarder do
  let(:serializer) { double }
  let(:client) { double }
  let(:logger) { double(info: nil, error: nil) }
  let(:raw_event) do
    CustomerCore::Events::Customer::Created.new(
      CustomerCore::Domain::Customer.new(name: "Angel", email: "test@mail.com")
    )
  end
  let(:platform_event) { Platform::Events::Event.new(raw_event: raw_event) }

  it "forwards serialized payload to n8n client" do
    payload = {event_name: "customer.created"}
    response = Net::HTTPOK.new("1.1", "200", "OK")

    allow(serializer).to receive(:serialize).with(platform_event).and_return(payload)
    allow(client).to receive(:post_json).with(url: "https://example.com/webhook", payload: payload).and_return(response)

    result = described_class.new(
      webhook_url: "https://example.com/webhook",
      serializer: serializer,
      client: client,
      logger: logger
    ).call(platform_event)

    expect(result).to be_success
  end

  it "skips when webhook URL is not configured" do
    allow(serializer).to receive(:serialize).with(platform_event).and_return({event_name: "customer.created"})
    expect(client).not_to receive(:post_json)
    expect(logger).to receive(:info).with(/webhook URL not configured/)

    result = described_class.new(webhook_url: nil, serializer: serializer, client: client, logger: logger).call(platform_event)
    expect(result).to be_success
    expect(result.metadata).to eq({skipped: true})
  end

  it "returns failure and logs when client returns non-success response" do
    payload = {event_name: "customer.created"}
    response = Net::HTTPInternalServerError.new("1.1", "500", "Internal Server Error")

    allow(serializer).to receive(:serialize).with(platform_event).and_return(payload)
    allow(client).to receive(:post_json).and_return(response)
    expect(logger).to receive(:error).with(/N8n forwarder failed/)

    result = described_class.new(
      webhook_url: "https://example.com/webhook",
      serializer: serializer,
      client: client,
      logger: logger
    ).call(platform_event)

    expect(result).to be_failure
    expect(result.code).to eq(:n8n_http_error)
  end
end
