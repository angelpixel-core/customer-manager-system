require "rails_helper"

RSpec.describe Platform::Events::RetryHandler do
  it "retries until success" do
    attempts = 0

    result = described_class.new(max_attempts: 3).call do
      attempts += 1
      raise "boom" if attempts < 3

      :ok
    end

    expect(result).to eq(:ok)
    expect(attempts).to eq(3)
  end

  it "raises exhausted retries error after max attempts" do
    handler = described_class.new(max_attempts: 2)

    expect {
      handler.call { raise StandardError, "boom" }
    }.to raise_error(Platform::Events::RetryHandler::ExhaustedRetriesError)
  end
end
