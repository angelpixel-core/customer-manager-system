require "rails_helper"
require "securerandom"

RSpec.describe "Admin customer records index", type: :system do
  it "renders the design system table with actions" do
    email = "admin-#{SecureRandom.hex(4)}@example.com"
    password = "ChangeMe123!"

    Account.create!(email: email, password: password, status: :verified)
    Customer::Record.create!(name: "Customer One", email: "customer.one@example.com")

    visit "/login"
    fill_in "Login", with: email
    fill_in "Password", with: password
    click_button "Login"

    visit "/admin/customers"

    expect(page).to have_content("Id")
    expect(page).to have_content("Name")
    expect(page).to have_content("Email")
    expect(page).to have_content("Created At")
    expect(page).to have_content("Actions")
    expect(page).to have_css("table.ds-table")
    expect(page).to have_content("Customer One")
  end
end
