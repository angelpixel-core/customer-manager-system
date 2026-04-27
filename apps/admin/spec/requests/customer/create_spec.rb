require "rails_helper"

RSpec.describe "CreateCustomer", type: :request do
  before do
    allow_any_instance_of(CustomersController).to receive(:authenticate_admin).and_return(true)
  end

  it "creates a customer and triggers async flow" do
    expect {
      post "/admin/customers", params: {
        name: "Angel",
        email: "test@mail.com"
      }
    }.to change(Customer::Record, :count).by(1)

    expect(response).to have_http_status(:redirect)
  end

  it "wires publisher, notifier, logger and dead letter adapters into the use case" do
    expect(CustomerCore::Application::UseCases::Customer::Create).to receive(:call).with(
      hash_including(
        repo: an_instance_of(Admin::Infrastructure::Repositories::ActiveRecord::CustomerRepository),
        publisher: an_instance_of(CustomerCore::Application::Interfaces::Events::EventBus),
        logger: an_instance_of(Admin::Infrastructure::Logging::RailsLogger),
        notifier: an_instance_of(Admin::Infrastructure::Notifications::RailsNotifier),
        dead_letter_store: an_instance_of(Admin::Infrastructure::Events::RailsDeadLetterStore),
        input: {name: "Angel", email: "test@mail.com"}
      )
    )

    post "/admin/customers", params: {
      name: "Angel",
      email: "test@mail.com"
    }

    expect(response).to have_http_status(:redirect)
  end

  it "runs end-to-end publish flow to worker and integration forwarder" do
    n8n_forwarder = double
    allow(n8n_forwarder).to receive(:call)
    allow(Platform::Integrations::N8n::EventForwarder).to receive(:new).and_return(n8n_forwarder)
    allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new("development"))

    expect(Admin::Infrastructure::SendWelcomeEmailWorker).to receive(:perform_async).with("e2e@test.com")
    expect(n8n_forwarder).to receive(:call).with(an_instance_of(Platform::Events::Event))

    expect {
      post "/admin/customers", params: {
        name: "E2E",
        email: "e2e@test.com"
      }
    }.to change(Customer::Record, :count).by(1)

    expect(response).to have_http_status(:redirect)
  end

  it "persists dead letter when publisher fails during request flow" do
    allow_any_instance_of(CustomerCore::Application::Interfaces::Events::EventBus).to receive(:publish)
      .and_raise(StandardError.new("publish boom"))

    expect {
      begin
        post "/admin/customers", params: {
          name: "Failing",
          email: "failing@test.com"
        }
      rescue StandardError
      end
    }.to change(Platform::Events::DeadLetterRecord, :count).by(1)
  end
end
