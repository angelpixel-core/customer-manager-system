require "rails_helper"

RSpec.describe "Admin::CustomersExtensions", type: :request do
  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate_admin).and_return(true)
  end

  it "returns ok health payload" do
    get "/admin/customers/health"

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)).to eq("status" => "ok")
  end
end
