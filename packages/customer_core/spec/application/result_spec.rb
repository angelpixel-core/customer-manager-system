RSpec.describe CustomerCore::Application::Result do
  it "builds a success result" do
    result = described_class.success(:ok, metadata: {source: "spec"})

    expect(result).to be_success
    expect(result).not_to be_failure
    expect(result.value).to eq(:ok)
    expect(result.metadata).to eq({source: "spec"})
  end

  it "builds a failure result" do
    cause = StandardError.new("boom")
    result = described_class.failure(code: :publish_failed, message: "failed", cause: cause)

    expect(result).to be_failure
    expect(result).not_to be_success
    expect(result.code).to eq(:publish_failed)
    expect(result.message).to eq("failed")
    expect(result.cause).to eq(cause)
  end
end
