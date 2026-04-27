module Admin
  module Infrastructure
    module Repositories
      module ActiveRecord
        # ActiveRecord adapter for persisting domain customers.
        class CustomerRepository < CustomerCore::Application::Interfaces::Customer::Repository
          # @param customer [CustomerCore::Domain::Customer]
          # @return [Customer::Record]
          def create(customer)
            ::Customer::Record.create!(
              name: customer.name,
              email: customer.email
            )
          end
        end
      end
    end
  end
end
