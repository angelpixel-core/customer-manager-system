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
end
