ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../../config/environment", __dir__)
abort("The Rails environment is running in production mode!") if Rails.env.production?

require "cucumber/rails"
require "capybara/cucumber"
require "database_cleaner/active_record"

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

ActionController::Base.allow_forgery_protection = false

DatabaseCleaner.clean_with(:truncation)
DatabaseCleaner.strategy = :transaction

Before do
  DatabaseCleaner.start
end

After do
  DatabaseCleaner.clean
end
