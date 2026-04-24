require "rails_helper"

RSpec.describe "CreateCustomer", type: :request do
  it "🔴 creates a customer and triggers async flow" do
    expect {
      post "/admin/customers", params: {
        name: "Angel",
        email: "test@mail.com"
      }
    }.to change(CustomerRecord, :count).by(1)

    expect(response).to have_http_status(:redirect)
  end
end
