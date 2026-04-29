require "securerandom"

return unless Rails.env.development?

seed_admin_email = ENV.fetch("SEED_ADMIN_EMAIL", "admin@example.com")
seed_admin_password = ENV.fetch("SEED_ADMIN_PASSWORD", "ChangeMe123!")

account = Account.find_or_initialize_by(email: seed_admin_email)
account.password = seed_admin_password
account.status = :verified
account.save!

target_customers = ENV.fetch("SEED_CUSTOMERS_COUNT", "100").to_i
existing_customers = Customer::Record.count
missing_customers = [target_customers - existing_customers, 0].max

first_names = %w[Alex Sam Jordan Taylor Casey Morgan Riley Avery Quinn Harper]
last_names = %w[Smith Johnson Brown Davis Wilson Miller Moore Clark Young Hall]

missing_customers.times do |index|
  sequence = existing_customers + index + 1
  first_name = first_names.sample
  last_name = last_names.sample
  token = SecureRandom.alphanumeric(4).downcase
  serial = format("%04d", sequence)

  Customer::Record.create!(
    name: "#{first_name} #{last_name} #{serial}",
    email: "#{first_name.downcase}.#{last_name.downcase}.#{serial}.#{token}@example.test"
  )
end
