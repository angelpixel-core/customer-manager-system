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

    result = described_class.new(registry: registry).publish(raw_event)

    expect(dispatched_event).to be_a(Platform::Events::Event)
    expect(dispatched_event.raw_event).to eq(raw_event)
    expect(dispatched_event.name).to eq("CustomerCore::Events::Customer::Created")
    expect(result).to be_success
  end

  it "does nothing when event has no handlers" do
    raw_event = CustomerCore::Events::Customer::Created.new(
      CustomerCore::Domain::Customer.new(name: "Angel", email: "test@mail.com")
    )

    result = described_class.new(registry: registry).publish(raw_event)
    expect(result).to be_success
  end

  it "retries handler and sends to dead letter queue after exhaustion" do
    attempts = 0
    dead_letter_queue = double
    metrics = double(retry: nil, failure: nil, dead_letter_recorded: nil)

    raw_event = CustomerCore::Events::Customer::Created.new(
      CustomerCore::Domain::Customer.new(name: "Angel", email: "test@mail.com")
    )

    registry.register(raw_event.class) do
      attempts += 1
      raise StandardError, "handler boom"
    end

    retry_handler = Platform::Events::RetryHandler.new(max_attempts: 3, base_delay_seconds: 0)

    expect(dead_letter_queue).to receive(:push).with(
      event: an_instance_of(Platform::Events::Event),
      error: an_instance_of(StandardError),
      metadata: hash_including(:handler, attempts: 3)
    )
    expect(metrics).to receive(:retry).twice
    expect(metrics).to receive(:failure).once
    expect(metrics).to receive(:dead_letter_recorded).once

    result = described_class.new(
      registry: registry,
      retry_handler: retry_handler,
      dead_letter_queue: dead_letter_queue,
      metrics: metrics
    ).publish(raw_event)

    expect(attempts).to eq(3)
    expect(result).to be_failure
    expect(result.code).to eq(:handler_exhausted)
  end
end
