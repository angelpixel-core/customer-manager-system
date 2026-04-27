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

  it "wires publisher, logger and dead letter adapters into the use case" do
    expect(CustomerCore::Application::UseCases::Customer::Create).to receive(:call).with(
      hash_including(
        repo: an_instance_of(Admin::Infrastructure::Repositories::ActiveRecord::CustomerRepository),
        publisher: an_instance_of(CustomerCore::Application::Interfaces::Events::EventBus),
        logger: an_instance_of(Admin::Infrastructure::Logging::RailsLogger),
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
end
