require "rails_helper"
require "securerandom"

RSpec.describe "Admin customers index", type: :system do
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

    expect(page).to have_link("Customers", href: "/admin/customers")
    expect(page).to have_link("Logout", href: "/logout")
    expect(page).not_to have_link("Login", href: "/login")

    expect(page).to have_content("Id")
    expect(page).to have_content("Name")
    expect(page).to have_content("Email")
    expect(page).to have_content("Created At")
    expect(page).to have_content("Actions")
    expect(page).to have_css("table.ds-table")
    expect(page).to have_content("Customer One")
  end

  it "submits filters as get params" do
    email = "admin-#{SecureRandom.hex(4)}@example.com"
    password = "ChangeMe123!"

    Account.create!(email: email, password: password, status: :verified)
    Customer::Record.create!(name: "Match Customer", email: "match@example.com")
    Customer::Record.create!(name: "Other Customer", email: "other@example.com")

    visit "/login"
    fill_in "Login", with: email
    fill_in "Password", with: password
    click_button "Login"

    visit "/admin/customers"
    fill_in "Email", with: "match@example.com"
    click_button "Apply"

    expect(page).to have_current_path(/\/admin\/customers\?/, ignore_query: false)
    expect(page).to have_content("match@example.com")
    expect(page).not_to have_content("other@example.com")
  end
end
