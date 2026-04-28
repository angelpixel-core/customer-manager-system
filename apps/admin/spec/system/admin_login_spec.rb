require "rails_helper"
require "securerandom"

RSpec.describe "Admin login", type: :system do
  it "allows a verified account to sign in" do
    email = "admin-#{SecureRandom.hex(4)}@example.com"
    password = "ChangeMe123!"

    Account.create!(email: email, password: password, status: :verified)

    visit "/login"
    fill_in "Login", with: email
    fill_in "Password", with: password
    click_button "Login"

    visit "/admin"

    expect(page).to have_current_path("/admin", ignore_query: true)
  end
end
