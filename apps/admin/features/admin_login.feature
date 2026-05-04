Feature: Admin login
  As an admin
  I want to sign in
  So that I can access the admin dashboard

  Scenario: Sign in with a verified account
    Given a verified admin account exists
    When I visit the login page
    And I submit valid admin credentials
    Then I should be able to access the admin dashboard
