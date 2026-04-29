require "rails_helper"
require "securerandom"

RSpec.describe "Admin customer form", type: :system do
  it "creates a customer through design system form" do
    email = "admin-#{SecureRandom.hex(4)}@example.com"
    password = "ChangeMe123!"

    Account.create!(email: email, password: password, status: :verified)

    visit "/login"
    fill_in "Login", with: email
    fill_in "Password", with: password
    click_button "Login"

    visit "/admin/customers/new"

    expect {
      fill_in "Name", with: "Customer One"
      fill_in "Email", with: "customer.one@example.com"
      first("input[type='submit'], button[type='submit']").click
    }.to change(Customer::Record, :count).by(1)

    expect(page).to have_content("Customer One")
  end
end
