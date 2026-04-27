RSpec.describe CustomerCore::Application::UseCases::Customer::Create do
  let(:repo) { double }
  let(:publisher) { double }
  let(:logger) { double }
  let(:dead_letter_store) { double }

  it "creates customer and publishes event using instance call" do
    expect(repo).to receive(:create)
    expect(publisher).to receive(:publish)

    use_case = described_class.new(repo: repo, publisher: publisher)

    use_case.call(name: "Angel", email: "test@mail.com")
  end

  it "creates customer and publishes event using class call" do
    expect(repo).to receive(:create)
    expect(publisher).to receive(:publish)

    described_class.call(
      repo: repo,
      publisher: publisher,
      input: {name: "Angel", email: "test@mail.com"}
    )
  end

  it "records dead letter and logs on publish failure" do
    error = StandardError.new("boom")

    allow(repo).to receive(:create)
    allow(publisher).to receive(:publish).and_raise(error)
    expect(logger).to receive(:error).with(/Failed to publish/)
    expect(dead_letter_store).to receive(:record).with(
      event: an_instance_of(CustomerCore::Events::Customer::Created),
      error: error,
      context: {use_case: "CustomerCore::Application::UseCases::Customer::Create"}
    )

    expect {
      described_class.call(
        repo: repo,
        publisher: publisher,
        logger: logger,
        dead_letter_store: dead_letter_store,
        input: {name: "Angel", email: "test@mail.com"}
      )
    }.to raise_error(StandardError, "boom")
  end
end
