return unless Rails.env.development?

seed_admin_email = ENV.fetch("SEED_ADMIN_EMAIL", "admin@example.com")
seed_admin_password = ENV.fetch("SEED_ADMIN_PASSWORD", "ChangeMe123!")

account = Account.find_or_initialize_by(email: seed_admin_email)
account.password = seed_admin_password
account.status = :verified
account.save!
