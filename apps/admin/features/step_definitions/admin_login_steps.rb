require "securerandom"

Given("a verified admin account exists") do
  @admin_email = "admin-#{SecureRandom.hex(4)}@example.com"
  @admin_password = "ChangeMe123!"

  Account.create!(email: @admin_email, password: @admin_password, status: :verified)
end

When("I visit the login page") do
  visit "/login"
end

When("I submit valid admin credentials") do
  fill_in "Login", with: @admin_email
  fill_in "Password", with: @admin_password
  click_button "Login"
end

Then("I should be able to access the admin dashboard") do
  visit "/admin"
  expect(page).to have_current_path("/admin", ignore_query: true)
end
