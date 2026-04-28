module Admin
  module Infrastructure
    module Repositories
      module ActiveRecord
        # ActiveRecord adapter for persisting domain customers.
        class CustomerRepository < CustomerCore::Application::Interfaces::Customer::Repository
          # @param customer [CustomerCore::Domain::Customer]
          # @return [CustomerCore::Application::Result]
          def create(customer)
            record = ::Customer::Record.create!(
              name: customer.name,
              email: customer.email
            )

            CustomerCore::Application::Result.success(record)
          rescue ActiveRecord::ActiveRecordError => e
            CustomerCore::Application::Result.failure(
              code: :repository_create_failed,
              message: e.message,
              cause: e
            )
          end
        end
      end
    end
  end
end
