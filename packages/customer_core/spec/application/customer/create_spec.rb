RSpec.describe CustomerCore::Application::UseCases::Customer::Create do
  let(:repo) { double }
  let(:publisher) { double }
  let(:logger) { double }
  let(:notifier) { double }
  let(:dead_letter_store) { double }

  it "creates customer and publishes event using instance call" do
    expect(repo).to receive(:create).and_return(CustomerCore::Application::Result.success)
    expect(publisher).to receive(:publish).and_return(CustomerCore::Application::Result.success)

    use_case = described_class.new(repo: repo, publisher: publisher)
    result = use_case.call(name: "Angel", email: "test@mail.com")

    expect(result).to be_success
    expect(result.value).to be_a(CustomerCore::Domain::Customer)
  end

  it "creates customer and publishes event using class call" do
    expect(repo).to receive(:create).and_return(CustomerCore::Application::Result.success)
    expect(publisher).to receive(:publish).and_return(CustomerCore::Application::Result.success)

    result = described_class.call(
      repo: repo,
      publisher: publisher,
      input: {name: "Angel", email: "test@mail.com"}
    )

    expect(result).to be_success
  end

  it "records dead letter and logs on publish failure" do
    error = StandardError.new("boom")

    allow(repo).to receive(:create).and_return(CustomerCore::Application::Result.success)
    allow(publisher).to receive(:publish).and_raise(error)
    expect(logger).to receive(:error).with(/Failed to publish/)
    expect(dead_letter_store).to receive(:record).with(
      event: an_instance_of(CustomerCore::Events::Customer::Created),
      error: error,
      context: {use_case: "CustomerCore::Application::UseCases::Customer::Create"}
    )

    result = described_class.call(
      repo: repo,
      publisher: publisher,
      logger: logger,
      dead_letter_store: dead_letter_store,
      input: {name: "Angel", email: "test@mail.com"}
    )

    expect(result).to be_failure
    expect(result.code).to eq(:publish_failed)
  end

  it "records dead letter when publisher returns failure result" do
    allow(repo).to receive(:create).and_return(CustomerCore::Application::Result.success)
    allow(publisher).to receive(:publish).and_return(
      CustomerCore::Application::Result.failure(code: :publish_failed, message: "publish boom")
    )
    expect(logger).to receive(:error).with(/Failed to publish/)
    expect(dead_letter_store).to receive(:record).with(
      event: an_instance_of(CustomerCore::Events::Customer::Created),
      error: an_instance_of(StandardError),
      context: hash_including(use_case: "CustomerCore::Application::UseCases::Customer::Create", code: :publish_failed)
    )

    result = described_class.call(
      repo: repo,
      publisher: publisher,
      logger: logger,
      dead_letter_store: dead_letter_store,
      input: {name: "Angel", email: "test@mail.com"}
    )

    expect(result).to be_failure
    expect(result.code).to eq(:publish_failed)
  end

  it "notifies integrations after publishing event" do
    expect(repo).to receive(:create).and_return(CustomerCore::Application::Result.success)
    expect(publisher).to receive(:publish).and_return(CustomerCore::Application::Result.success)
    expect(notifier).to receive(:notify).with(
      event: an_instance_of(CustomerCore::Events::Customer::Created),
      context: {use_case: "CustomerCore::Application::UseCases::Customer::Create"}
    ).and_return(CustomerCore::Application::Result.success)

    result = described_class.call(
      repo: repo,
      publisher: publisher,
      notifier: notifier,
      input: {name: "Angel", email: "test@mail.com"}
    )

    expect(result).to be_success
  end

  it "logs and does not fail when notifier raises" do
    allow(repo).to receive(:create).and_return(CustomerCore::Application::Result.success)
    allow(publisher).to receive(:publish).and_return(CustomerCore::Application::Result.success)
    allow(notifier).to receive(:notify).and_raise(StandardError.new("notify boom"))
    expect(logger).to receive(:error).with(/Failed to notify/)

    result = described_class.call(
      repo: repo,
      publisher: publisher,
      notifier: notifier,
      logger: logger,
      input: {name: "Angel", email: "test@mail.com"}
    )

    expect(result).to be_success
  end

  it "returns failure when repository fails" do
    allow(repo).to receive(:create).and_return(
      CustomerCore::Application::Result.failure(code: :repository_create_failed, message: "db error")
    )

    result = described_class.call(
      repo: repo,
      publisher: publisher,
      input: {name: "Angel", email: "test@mail.com"}
    )

    expect(result).to be_failure
    expect(result.code).to eq(:repository_create_failed)
  end
end
